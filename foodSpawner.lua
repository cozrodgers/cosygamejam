FoodSpawner = Object:extend()

function FoodSpawner:new(x,y,w,h)
    self.spawnTimer = 0
    self.spawnInterval = 2 -- spawn food every 2 seconds
    self.x = x
    self.y = y
    self.width = w or 100
    self.height = h or 10
    self.foods = {} -- Table to store spawned foods
end

function FoodSpawner:update(dt)
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer >= self.spawnInterval then
        print("Food counter: ", #self.foods)
        self.spawnTimer = 0
        -- spawn new food at the spawner's location
        local newFood = Food()
        newFood.y = self.y
        newFood.x = math.random(self.x, self.x + self.width - newFood.width)
        table.insert(self.foods, newFood)
    end

    for i = #self.foods, 1, -1 do
        local food = self.foods[i]
        food:update(dt)

        -- if item goes off screen or collides with player, remove it from the table
        if food.x > VIRTUAL_WIDTH or food:checkCollision(Player) then
            table.remove(self.foods, i)
        end
    end
end

function FoodSpawner:draw()
    -- love.graphics.setColor(1, 0, 0, 0.5) -- Semi-transparent red
    -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(1, 1, 1, 1)   -- Reset
    for i, food in ipairs(self.foods) do
        food:draw()
    end
end
