# class Sudoku < Sinatra::Application

#   get '/new_game/:cells_to_remove' do
#     generate_new_puzzle(params[:cells_to_remove].to_i)
#     @current_solution = session[:current_solution] || session[:puzzle]
#     @puzzle = session[:puzzle]
#     @solution = session[:solution]
#     redirect to("/")
#   end

#   get '/' do
#     prepare_to_check_solution
#     generate_new_puzzle_if_necessary
#     @current_solution = session[:current_solution] || session[:puzzle]
#     @puzzle = session[:puzzle]
#     @solution = session[:solution]
#     erb :index
#   end

#   get '/solution' do
#     @current_solution = session[:solution]
#     @puzzle = session[:puzzle]
#     @solution = session[:solution]
#     erb :index
#   end

#   get '/help' do
#     erb :help
#   end

#   post '/' do
#     cells = box_order_to_row_order(params["cell"])
#     session[:current_solution] = cells.map{|value| value.to_i }.join
#     session[:check_solution] = true
#     redirect to("/")
#   end

#   get '/restart' do
#     session[:current_solution] = session[:puzzle]
#     redirect to("/")
#   end
# end