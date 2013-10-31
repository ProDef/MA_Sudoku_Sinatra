require 'sinatra'
require 'sinatra/partial' 
require 'rack-flash'
require_relative 'sudoku'
require_relative 'cell'
require_relative 'helpers'

use Rack::Flash
register Sinatra::Partial

enable :sessions

set :partial_template_engine, :erb
set :views, File.join(File.dirname(__FILE__), '..', 'views')
set :session_secret, "bubble"


def random_sudoku
  seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
  sudoku = Sudoku.new(seed.join)
  sudoku.solve!
  sudoku.to_s.chars
end

def remove_one_value_from sudoku
	sudoku[rand(sudoku.count)] = 0
	sudoku
end

def count_blanks_in sudoku
	sudoku.count(0)
end

def insert_number_of_blanks_in sudoku, number
	until count_blanks_in(sudoku) == number
		sudoku = remove_one_value_from sudoku
	end
	sudoku
end

def puzzle(sudoku)
	sudoku_copy = sudoku.dup
	insert_number_of_blanks_in sudoku_copy, 40
end

def prepare_to_check_solution
  @check_solution = session[:check_solution]
  if @check_solution
    flash[:notice] = "Incorrect values are highlighted in orange"
  end
  session[:check_solution] = nil
end

def generate_new_puzzle_if_necessary
  return if session[:current_solution]
  sudoku = random_sudoku
  session[:solution] = sudoku
  session[:puzzle] = puzzle(sudoku)
  session[:current_solution] = session[:puzzle]    
end

def generate_new_puzzle
  sudoku = random_sudoku
  session[:solution] = sudoku
  session[:puzzle] = puzzle(sudoku)
  session[:current_solution] = session[:puzzle]    
end

def box_order_to_row_order(cells)
  boxes = cells.each_slice(9).to_a
  (0..8).to_a.inject([]) { |memo, i|
    first_box_index = i / 3 * 3
    three_boxes = boxes[first_box_index, 3]
    three_rows_of_three = three_boxes.map do |box| 
      row_number_in_a_box = i % 3
      first_cell_in_the_row_index = row_number_in_a_box * 3
      box[first_cell_in_the_row_index, 3]
    end
    memo += three_rows_of_three.flatten
  }
end

get '/new_game' do
  generate_new_puzzle
  @current_solution = session[:current_solution] || session[:puzzle]
  @puzzle = session[:puzzle]
  @solution = session[:solution]
  redirect to("/")
end

get '/' do
  prepare_to_check_solution
  generate_new_puzzle_if_necessary
  @current_solution = session[:current_solution] || session[:puzzle]
  @puzzle = session[:puzzle]
  @solution = session[:solution]
  erb :index
end

get '/solution' do
  @current_solution = session[:solution]
  @puzzle = session[:puzzle]
  @solution = session[:solution]
  erb :index
end

post '/' do
  cells = box_order_to_row_order(params["cell"])
  session[:current_solution] = cells.map{|value| value.to_i }.join
  session[:check_solution] = true
  redirect to("/")
end


