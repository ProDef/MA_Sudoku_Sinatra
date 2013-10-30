require 'sinatra'
require_relative 'sudoku'
require_relative 'cell'

enable :sessions

set :views, File.join(File.dirname(__FILE__), '..', 'views')

def random_sudoku
  seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
  sudoku = Sudoku.new(seed.join)
  sudoku.solve!
  sudoku.to_s.chars
end

def remove_one_value_from sudoku
	sudoku[rand(sudoku.count)] = ' '
	sudoku
end

def count_blanks_in sudoku
	sudoku.count(' ')
end

def insert_number_of_blanks_in sudoku, number
	until count_blanks_in(sudoku) == number
		sudoku = remove_one_value_from sudoku
	end
	sudoku
end

def puzzle(sudoku)
	insert_number_of_blanks_in sudoku, 40
  sudoku 
end

get '/' do
  sudoku = random_sudoku
  session[:solution] = sudoku
  @current_solution = puzzle(sudoku)
  erb :index
end

get '/solution' do
  @current_solution = session[:solution]
  erb :index
end