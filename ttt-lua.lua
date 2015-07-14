function check_game_field_state(game, dimension, first, second, blank)
	-- Check horizontal
	for i=1, dimension do
		win = true
		c = game[i][1]
		for j=2, dimension do
			if c ~= game[i][j] then
				win = false
			end
		end

		if win == true and c == first then
			return 1
		elseif win == true and c == second then
			return 2
		end
	end

	-- Check vertical
	for j=1, dimension do
		win = true
		c = game[1][j]
		for i=2, dimension do
			if c ~= game[i][j] then
				win = false
			end
		end

		if win == true and c == first then
			return 1
		elseif win == true and c == second then
			return 2
		end
	end

	-- Check diagonal (back slash)
	win = true
	c = game[1][1]
	i = 2
	while i <= dimension do
		if c ~= game[i][i] then
			win = false
		end
		i = i + 1
	end

	if win == true and c == first then
		return 1
	elseif win == true and c == second then
		return 2
	end

	-- Check diagonal (forward slash)
	win = true
	c = game[1][dimension]
	i = 2
	j = dimension - 1
	while i <= dimension do
		if c ~= game[i][j] then
			win = false
		end
		i = i + 1
		j = j - 1
	end

	if win == true and c == first then
		return 1
	elseif win == true and c == second then
		return 2
	end

	-- Check draw
	draw = true
	for i=1, dimension do
		for j=1, dimension do
			if game[i][j] == blank then
				draw = false
			end
		end
	end
	if draw == true then
		return -1
	end

	return 0
end


-- Print game board
function game_field_to_string(game, dimension)
	output = ""
	output = output .. "#####"
	for i=1, dimension do
		output = output .. "##"
	end
	output = output .. "##"
	output = output .. "\n"

	output = output .. "## ~ "
	for i=1, dimension do
		output = output .. i .. " "
	end
	output = output .. "##"
	output = output .. "\n"

	for i=1, dimension do
		output = output .. "## " .. i .. " "
		for j=1, dimension do
			output = output .. game[i][j] .. " "
		end
		output = output .. "##"
		output = output .. "\n"
	end

	output = output .. "#####"
	for i=1, dimension do
		output = output .. "##"
	end
	output = output .. "##"
	output = output .. "\n"


	return output
end

function mini_max(game, dimension, maximizing, first, second, blank)
	game_result = check_game_field_state(game, dimension, first, second, blank)
	if game_result == 1 then
		return 10, -1, -1
	elseif game_result == 2 then
		return -10, -1, -1
	elseif game_result == -1 then
		return 0, -1, -1
	end

	if maximizing == true then
		best_val = -100
		best_x, best_y = -1, -1

		for i=1, dimension do
			for j=1, dimension do
				if game[i][j] == blank then
					game[i][j] = first
					tmp_best_val = mini_max(game, dimension, false, first, second, blank)
					-- Get max of children
					if tmp_best_val > best_val then
						best_val = tmp_best_val
						best_x, best_y = i, j
					end
					game[i][j] = blank
				end
			end
		end
		return best_val, best_x, best_y
	else
		best_val = 100
		best_x, best_y = -1, -1

		for i=1, dimension do
			for j=1, dimension do
				if game[i][j] == blank then
					game[i][j] = second
					tmp_best_val = mini_max(game, dimension, true, first, second, blank)
					-- Get min of children
					if tmp_best_val < best_val then
						best_val = tmp_best_val
						best_x, best_y = i, j
					end
					game[i][j] = blank
				end
			end
		end
		return best_val, best_x, best_y
	end
end

-- Main
-- field = { {'O', 'X', 'O'}, {'O', 'X', 'O'}, {'X', 'O', 'X'} }

player1 = 'X'
player2 = 'O'
blankspace = '-'
boarddimension = 3

field = { {'-', '-', '-'}, {'-', '-', '-'}, {'-', '-', '-'} }

local response
repeat
	io.write("Do you want to go first? (y/n) ")
	io.flush()
	response = io.read()
until response == "y" or response == "n"

if response == 'y' then
	while check_game_field_state(field, boarddimension, player1, player2, blankspace) == 0 do
		print("Current board: (your turn)")
		print(game_field_to_string(field, boarddimension))
		while true do
			local x
			local y
			io.write("Make your move! (x y) ")
			io.flush()
			x = io.read("*number")
			y = io.read("*number")
			if field[y][x] == '-' and x>0 and x<=boarddimension and y>0 and y<=boarddimension then
				field[y][x] = player1
				break
			end
		end

		if check_game_field_state(field, boarddimension, player1, player2, blankspace) ~= 0 then
			break
		end

		print("Current board: (cpu turn)")
		print(game_field_to_string(field, boarddimension))
		mm_val, mm_x, mm_y = mini_max(field, boarddimension, true, player2, player1, blankspace)
		field[mm_x][mm_y] = player2
		print("Player 2 placed at " .. mm_x .. mm_y)
		print(mm_val)
	end
else
	while check_game_field_state(field, boarddimension, player1, player2, blankspace) == 0 do
		print("Current board: (cpu turn)")
		print(game_field_to_string(field, boarddimension))
		mm_val, mm_x, mm_y = mini_max(field, boarddimension, true, player2, player1, blankspace)
		field[mm_x][mm_y] = player1
		print("Player 2 placed at " .. mm_x .. mm_y)
		print(mm_val)

		if check_game_field_state(field, boarddimension, player2, player1, blankspace) ~= 0 then
			break
		end

		print("Current board: (your turn)")
		print(game_field_to_string(field, boarddimension))
		while true do
			local x
			local y
			io.write("Make your move! (x y) ")
			io.flush()
			x = io.read("*number")
			y = io.read("*number")
			if field[y][x] == '-' and x>0 and x<=boarddimension and y>0 and y<=boarddimension then
				field[y][x] = player2
				break
			end
		end
	end
end


-- Print winner
print("Final board: ")
print(game_field_to_string(field, boarddimension))
result = check_game_field_state(field, boarddimension, player1, player2, blankspace)
if result == 1 and response == "y" then
	print("You win!")
elseif result == 2 and response == "n" then
	print("You win!")
elseif result == -1 then
	print("Draw!")
else
	print("You lose!")
end





