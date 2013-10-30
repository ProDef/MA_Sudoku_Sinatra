require 'app'

describe 'App' do 

	it 'can remove one of the entries from a sudoku puzzle' do
		sudoku = ['2', '9']
		sudoku_removed = [['2', ' '], [' ', '9']]
		expect(sudoku_removed).to include remove_one_value_from sudoku
	end

	it 'knows how many blank values there are in a sudoku' do
		sudoku = ['2', '1', ' ', '7', '1', ' ', '8']
		expect(count_blanks_in sudoku).to eq 2
	end	

	it 'can make a given number of values into blanks' do
		sudoku = ['2', '1', '8', '7', '1', '5', '8', '9', '4', '6', '3', '3', '3']
		insert_number_of_blanks_in sudoku, 7
		expect(count_blanks_in sudoku).to eq 7
	end

end