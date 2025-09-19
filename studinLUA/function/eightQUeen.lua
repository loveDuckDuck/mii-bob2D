-- File: main.lua

-- Define the board size.
local N = 8

-- A table to hold all the solutions found.
local solutions = {}

-- The index of the solution currently being displayed.
local currentSolutionIndex = 1

-- The size of each square on the board.
local squareSize

-- The color for the light squares.
local lightSquareColor = {0.9, 0.8, 0.7, 1} -- Light brown

-- The color for the dark squares.
local darkSquareColor = {0.4, 0.3, 0.2, 1} -- Dark brown

-- The color for the queens.
local queenColor = {0.2, 0.5, 0.8, 1} -- A blue-ish color

-- Check whether position (n,c) is free from attacks.
-- a: the board configuration (a table where a[i] is the column of the queen in row i)
-- n: the current row being considered
-- c: the current column being considered
local function isplaceok(a, n, c)
    for i = 1, n - 1 do
        -- Check if any existing queen shares the same column or a diagonal.
        if (a[i] == c) or              -- Same column
           (math.abs(a[i] - c) == math.abs(i - n)) then -- Same diagonal
            return false
        end
    end
    return true
end

-- Store a valid board configuration.
local function storesolution(a)
    -- Create a copy of the board and add it to our list of solutions.
    table.insert(solutions, {unpack(a)})
end

-- Add to board 'a' all queens from 'n' to 'N'.
-- This is the main backtracking function.
local function addqueen(a, n)
    if n > N then -- Base case: All queens have been placed successfully.
        storesolution(a)
    else -- Recursive step: Try to place the n-th queen.
        for c = 1, N do
            if isplaceok(a, n, c) then
                a[n] = c -- Place n-th queen at column 'c'
                addqueen(a, n + 1)
            end
        end
    end
end

-- LÖVE 2D's main callback function.
-- This function runs only once when the program starts.
function love.load()
    -- Start the backtracking process to find all solutions.
    -- This is a one-time calculation, which is much more efficient than doing it every frame.
    addqueen({}, 1)

    -- Set the window title.
    love.window.setTitle("N-Queens Solver")

    -- Calculate the size of each square based on the window size.
    local minDimension = math.min(love.graphics.getWidth(), love.graphics.getHeight())
    squareSize = math.floor(minDimension / (N + 2))
end

-- LÖVE 2D's callback for handling keyboard input.
function love.keypressed(key)
    -- Press the right arrow key to move to the next solution.
    if key == "right" then
        currentSolutionIndex = currentSolutionIndex + 1
        -- Wrap around to the first solution if we go past the last one.
        if currentSolutionIndex > #solutions then
            currentSolutionIndex = 1
        end
    -- Press the left arrow key to move to the previous solution.
    elseif key == "left" then
        currentSolutionIndex = currentSolutionIndex - 1
        -- Wrap around to the last solution if we go past the first one.
        if currentSolutionIndex < 1 then
            currentSolutionIndex = #solutions
        end
    end
end

-- LÖVE 2D's main drawing callback function.
-- This function runs every frame and is used to render the game world.
function love.draw()
    -- Clear the background to a light gray color.
    love.graphics.setBackgroundColor(0.9, 0.9, 0.9, 1)

    -- Get the current solution to draw.
    local solution = solutions[currentSolutionIndex]

    if not solution then
        -- Handle the case where no solutions were found (e.g., for N=2 or N=3).
        love.graphics.printf("No solutions found for N=" .. N, 0, 0, love.graphics.getWidth(), "center")
        return
    end

    -- Calculate the top-left corner of the board to center it.
    local boardWidth = N * squareSize
    local boardHeight = N * squareSize
    local startX = (love.graphics.getWidth() - boardWidth) / 2
    local startY = (love.graphics.getHeight() - boardHeight) / 2

    -- Draw the checkerboard pattern.
    for i = 1, N do
        for j = 1, N do
            -- Alternate the colors of the squares.
            if (i + j) % 2 == 0 then
                love.graphics.setColor(lightSquareColor)
            else
                love.graphics.setColor(darkSquareColor)
            end
            love.graphics.rectangle("fill", startX + (i-1) * squareSize, startY + (j-1) * squareSize, squareSize, squareSize)
        end
    end

    -- Draw the queens on the board.
    love.graphics.setColor(queenColor)
    for i = 1, N do
        local queenCol = solution[i]
        love.graphics.rectangle("fill", startX + (i-1) * squareSize, startY + (queenCol-1) * squareSize, squareSize, squareSize)
    end

    -- Reset the color for the text.
    love.graphics.setColor(0, 0, 0, 1)

    -- Display the current solution number.
    local text = "Solution: " .. currentSolutionIndex .. " of " .. #solutions
    love.graphics.printf(text, 0, 10, love.graphics.getWidth(), "center")

    -- Add a hint for the user.
    love.graphics.printf("Use the LEFT and RIGHT arrow keys to change the solution.", 0, love.graphics.getHeight() - 40, love.graphics.getWidth(), "center")
end