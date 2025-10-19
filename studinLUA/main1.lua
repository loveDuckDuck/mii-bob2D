function testMetaTable()
    local tableIndex = {
        name = "tab",
        val = 10
    }


    tab1 = { 7 }
    tab2 = { 7 }

    local metatable = {}

    metatable.__add = function(t1, t2)
        return t1[1] + t2[1]
    end

    metatable.__eq = function(t1, t2)
        return t1[1] == t2[1]
    end

    metatable.__index = tableIndex


    setmetatable(tab1, metatable)
    setmetatable(tab2, metatable)


    print("tab1 + tab2 = " .. (tab1 + tab2))
    print("tab1 == tab2 : " .. tostring(tab1 == tab2))

    print("tab1.name : " .. tab1.name)
    print("tab2.name : " .. tab2.name)
    print("tab1.val : " .. tab1.val)
    print("tab2.val : " .. tab2.val)


    local metatable2 = {
        __call = function(self, ...)
            print(...)
        end
    }

    local myTable = {}
    setmetatable(myTable, metatable2)
    myTable(1, 2, 3, 4, 5)
end

function defineEnenmy()
    Enemy = {
        __call = function(self, ...)
            print("Creating enemy...")
        end

    }
    Enemy.__index = Enemy

    function Enemy.new(name, x, y, health)
        local enemy = {
            name = name,
            x = x,
            y = y,
            health = health
        }

        setmetatable(enemy, Enemy)
        return enemy
    end

    function Enemy:damage(damage)
        self.health = self.health - damage
        if self.health < 0 then
            self.health = 0
        end
    end

    function Enemy:move(dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end

    local zombie = Enemy.new("Zombie", 0, 0, 100)
    zombie:move(10, 5)
    zombie:damage(30)
    zombie()
    print(zombie.name .. " is at (" .. zombie.x .. "," .. zombie.y .. ") with " .. zombie.health .. " health.")


    -- BiggerEnemy = setmetatable({}, { __index = Enemy })
    -- BiggerEnemy.__index = BiggerEnemy


    BiggerEnemy = setmetatable({}, { __index = Enemy })
    BiggerEnemy.__index = BiggerEnemy


    function BiggerEnemy.new(name, x, y, health)
        local enemy = Enemy.new(name, x, y, health)
        setmetatable(enemy, BiggerEnemy)
        return enemy
    end

    function BiggerEnemy:roar()
        print("ROAR!!!")
    end

    local bigZombie = BiggerEnemy.new("Big Zombie", 0, 0, 300)
    bigZombie:move(20, 10)
    Enemy.damage(bigZombie, 50)
    print(bigZombie.name ..
        " is at (" .. bigZombie.x .. "," .. bigZombie.y .. ") with " .. bigZombie.health .. " health.")
    bigZombie:roar()
end


function defineTheMetaTableObject()
    local object_MT = {
        __call = function (self, ...)
            local instance = {}
            setmetatable(instance,self)
            self.new(instance,...)

            return instance
            
        end
    }


    Enemy = {}
    Enemy.__index = Enemy
    setmetatable(Enemy,object_MT)
    function Enemy:new(name,x,y,health)
        self.name = name
        self.x = x
        self.y = y
        self.health = health
    end
local zombieX  = Enemy("zombie",1,1,10)
print(zombieX.name)    
end

--testMetaTable()
defineTheMetaTableObject()


function love.draw()
    -- Draw a point at the screen's actual (10, 10)
    love.graphics.point(10, 10)

    love.graphics.push()
        -- Move the origin to (100, 100)
        love.graphics.translate(100, 100)

        -- Draw a point at the new (10, 10)
        -- This appears at screen coordinate (110, 110)
        love.graphics.point(10, 10)
    love.graphics.pop()
end
