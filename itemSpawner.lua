ItemSpawner = Object:extend()

function ItemSpawner:new(x, y, w, h)
    self.spawnTimer = 0
    self.spawnInterval = 2 -- spawn food every 2 seconds
    self.x = x
    self.y = y
    self.width = w or 100
    self.height = h or 10
    self.items = {} -- Table to store spawned items
    return self
end

function ItemSpawner:spawnItem(dt)
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer >= self.spawnInterval then
        print("Food counter: ", #self.items)
        self.spawnTimer = 0
        -- spawn new food at the spawner's location
        local newFood = Food()
        newFood.y = self.y
        newFood.x = math.random(self.x, self.x + self.width - newFood.width)
        table.insert(self.items, newFood)
    end
end

function ItemSpawner:update(dt)
    ItemSpawner:spawnItem(dt)
    for i = #self.items, 1, -1 do
        local items = self.items[i]
        items:update(dt)

        -- if item goes off screen or collides with player, remove it from the table
        if items.x > VIRTUAL_WIDTH or items:checkCollision(Player) then
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
