-- main.lua

function love.load()

end

function love.update(dt)


end

function love.draw()
    -- Draw a point at the screen's actual (10, 10)
    love.graphics.points(10, 10)

    love.graphics.push()
    -- Move the origin to (100, 100)
    --love.graphics.translate(100, 100)

    -- Draw a point at the new (10, 10)
    -- This appears at screen coordinate (110, 110)
    love.graphics.points(10, 10)
    love.graphics.pop()
end