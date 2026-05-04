Star = Object:extend()
Star.image = nil

Star.frames = {}

function Star:new(x, y)
    local frame_width = 16
    local frame_height = 16
    if Star.image == nil then
        Star.image = love.graphics.newImage("assets/star.png")
        local imgW, imgH = Star.image:getDimensions()
       for i = 0, 8 do
            table.insert(Star.frames, love.graphics.newQuad(frame_height * i, 0, frame_width, frame_height, imgW, imgH))
        end
    end
    self.frames = Star.frames
    self.currentFrame = 1
    self.dead = false
    self.x = x or 0
    self.y = y or 300
    self.scale = 3
    self.speed = 500
    self.width = 16 * self.scale
    self.height = 16 * self.scale
end

function Star:update(dt)
    -- increment currentFrame
    local animationSpeed = 8
    self.currentFrame = self.currentFrame + dt * animationSpeed
    if self.currentFrame >= #self.frames + 1 then
        self.currentFrame = 1
    end
    self.y = self.y + self.speed * dt

end

-- add collision detection to the item so we can tell if the player has grabbed it
function Star:checkCollision(obj)
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

    if self_right > obj_left and self_left < obj_right and self_bottom > obj_top and self_top < obj_bottom then
        self.dead = true
        Player.stars = Player.stars + 1
    end
end

function Star:draw()
    if self.dead ~= true then
        love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)], self.x, self.y, 0, self.scale,
            self.scale)

    end
end
