Food = Object:extend()
Food.image = nil
Food.quads = {}
function Food:new()
    -- 1. Check if we have already loaded the image.
    -- If not, load it and slice the quads ONCE for the whole game.
    if Food.image == nil then
        Food.image = love.graphics.newImage("assets/food.png")
        local imgW, imgH = Food.image:getDimensions()

        Food.quads = {love.graphics.newQuad(0, 0, 16, 16, imgW, imgH), love.graphics.newQuad(16, 0, 16, 16, imgW, imgH),
                      love.graphics.newQuad(32, 0, 16, 16, imgW, imgH),
                      love.graphics.newQuad(0, 48, 16, 16, imgW, imgH),
                      love.graphics.newQuad(0, 16, 16, 16, imgW, imgH),
                      love.graphics.newQuad(0, 32, 16, 16, imgW, imgH), love.graphics.newQuad(0, 64, 16, 16, imgW, imgH)}
    end

    -- 1.
    self.dead = false

    -- 2.
    self.quad = Food.quads[math.random(1, #Food.quads)]

    self.x = 0
    self.y = 300
    self.scale = 3
    self.velocity = 500
    self.gravity = 500 
    self.width = 16 * self.scale
    self.height = 16 * self.scale
end

function Food:update(dt)
    -- move across the screen to the right
    -- the higher the Y value, the faster we should fall
    self.velocity = self.velocity + self.gravity * dt
    self.y = self.y + self.velocity * dt

end

-- add collision detection to the item so we can tell if the player has grabbed it
function Food:checkCollision(obj)
    local offset = 20
    if self.dead then
        return
    end
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if self_right > obj_left and self_left < obj_right and self_bottom - offset > obj_top and self_top < obj_bottom then
        self.dead = true
        -- add some score
        Player.score = Player.score + 1
    end
end

function Food:draw()
    if self.dead ~= true then
        love.graphics.draw(self.image, self.quad, self.x, self.y, 0, self.scale, self.scale)
    end
end
