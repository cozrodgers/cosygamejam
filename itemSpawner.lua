ItemSpawner = Object:extend()

function ItemSpawner:new(x, y, w, h)
    self.spawnTimer = 0
    self.spawnInterval = 2 -- spawn food every 2 seconds
    self.x = x
    self.y = y
    self.width = w or 100
    self.height = h or 10
    self.bombChance = 0.7
    self.starChance = 0.1
    self.items = {} -- Table to store spawned items
    return self
end

function ItemSpawner:spawnItem(dt)
    -- decide whether to spawn a bomb or food

    -- update timer this frame
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer >= self.spawnInterval then
        print("Item counter: ", #self.items)
        self.spawnTimer = 0
        -- spawn new item at the spawner's location
        local rand = math.random()
        local shouldDropBomb = rand <= self.bombChance

        rand = math.random()
        local shouldDropStar = rand <= self.starChance
        if (shouldDropStar == true) then
            local newStar = Star()
            newStar.y = self.y
            newStar.x = math.random(self.x, self.x + self.width - newStar.width)
            table.insert(self.items, newStar)
        if (shouldDropBomb == true) then
            local newBomb = Bomb()
            newBomb.y = self.y
            newBomb.x = math.random(self.x, self.x + self.width - newBomb.width)
            table.insert(self.items, newBomb)
        end
        else
            local newFood = Food()
            newFood.y = self.y
            newFood.x = math.random(self.x, self.x + self.width - newFood.width)
            table.insert(self.items, newFood)

        end
    end
end

function ItemSpawner:update(dt)
    ItemSpawner:spawnItem(dt)

    -- loop over the count of items backwards
    for i = #self.items, 1, -1 do
        local item = self.items[i]
        item:update(dt)
        -- if item goes off screen or collides with player, remove it from the table
        if item.x > VIRTUAL_WIDTH or item:checkCollision(Player) then
            table.remove(self.items, i)
        end
    end
end

function ItemSpawner:draw()
    -- love.graphics.setColor(1, 0, 0, 0.5) -- Semi-transparent red
    -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(1, 1, 1, 1)   -- Reset
    for i, food in ipairs(self.items) do
        food:draw()
    end
end
