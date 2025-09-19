local numberOne = 0
local numberTwo = 0

function love.draw()
    if numberOne then
        love.graphics.print(numberOne)
    end
end

function love.update(dt)

end

function love.load()
    love.window.setTitle("N-Queens Solver")
end

function love.keypressed(key)
    local operation
    if key == "1" or key == "2" or key == "3" or key == "4" or
        key == "5" or key == "6" or key == "7" or key == "8" or key == "9"
    then
        numberOne = numberOne .. key
    end

    if key == "+" then
        operation = key
    end

end
