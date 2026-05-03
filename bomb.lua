Bomb = Object:extend()
Bomb.image = nil
Bomb.quad = nil

Bomb.frames = {}

function Bomb:new(x, y)
    local frame_width = 16
    local frame_height = 16
    if Bomb.image == nil then
        Bomb.image = love.graphics.newImage("assets/bomb.png")
        local imgW, imgH = Bomb.image:getDimensions()
        table.insert(Bomb.frames,
            love.graphics.newQuad(144, 0, frame_width, frame_height, imgW, imgH))
        table.insert(Bomb.frames,
            love.graphics.newQuad(304, 0, frame_width, frame_height, imgW, imgH))
        Bomb.quad = love.graphics.newQuad(160, 0, 16, 16, imgW, imgH)
    end

    self.currentFrame = 1

    self.quad = Bomb.quad
    self.dead = false
    self.x = x or 0
    self.y = x or 300
    self.scale = 3
    self.speed = 500
    self.width = 16 * self.scale
    self.height = 16 * self.scale
end

function Bomb:update(dt)
    -- increment currentFrame
    local animationSpeed = 8
    self.currentFrame = self.currentFrame + dt * animationSpeed
    if self.currentFrame >= #self.frames + 1 then
        self.currentFrame = 1
    end
    -- move across the screen to the right
    self.y = self.y + self.speed * dt
end

-- add collision detection to the item so we can tell if the player has grabbed it
function Bomb:checkCollision(obj)
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

    if self_right > obj_left
        and self_left < obj_right
        and self_bottom > obj_top
        and self_top < obj_bottom then
        self.dead = true
        Player.lives = Player.lives - 1
    end
end

function Bomb:draw()
    if self.dead ~= true then
        love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)], self.x, self.y, 0, self.scale,
            self.scale)
    end
end
