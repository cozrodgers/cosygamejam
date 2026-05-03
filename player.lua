Player = Object:extend()

SPEED_FACTOR = 100
function Player:new()
    self.image = love.graphics.newImage("assets/mouse.png")
    local spriteSize = 32
    -- quad is a reference to coords on an image, in this case the spritesheet
    self.quad = love.graphics.newQuad(0, 0, spriteSize, spriteSize, self.image:getDimensions())
   
    self.y = 400
    self.lives = 5
    self.speed = 5
    self.scale = 3
    self.score = 0
    -- 1. Define your visual padding (empty pixels inside the 32x32 box)
    -- You can tweak these numbers to tighten the hitbox
    self.padLeft = 11
    self.padRight = 11
    self.padTop = 10
    self.padBottom = 4

    -- 2. Calculate the REAL physical width/height of the mouse (The Hitbox)
    local realWidth = spriteSize - self.padLeft - self.padRight
    local realHeight = spriteSize - self.padTop - self.padBottom

    self.width = realWidth * self.scale
    self.height = realHeight * self.scale

    -- 4. Center the player safely
    self.x = (VIRTUAL_WIDTH / 2) - (self.width)
    self.y = (VIRTUAL_HEIGHT) - (self.height)
end

function Player:update(dt)
    ProcessMovement(self, dt)
    -- check if player too far left of the screen
    if (self.x < 0) then
        self.x = 0
    elseif (self.x + self.width > VIRTUAL_WIDTH) then
        self.x = VIRTUAL_WIDTH - self.width
    end

    if (self.y + self.height > VIRTUAL_HEIGHT) then
        self.y = VIRTUAL_HEIGHT - self.height
    elseif (self.y < 0) then
        self.y = 0
    end
end

function ProcessMovement(player, dt)
    if love.keyboard.isDown("a") then
        player.x = player.x - (player.speed * SPEED_FACTOR) * dt
    elseif love.keyboard.isDown("d") then
        player.x = player.x + (player.speed * SPEED_FACTOR) * dt
    end
end

function Player:draw()
    local drawX = self.x - (self.padLeft * self.scale)
    local drawY = self.y - (self.padTop * self.scale)
    love.graphics.draw(self.image, self.quad, drawX, drawY, 0, self.scale, self.scale, 0)
    -- love.graphics.setColor(1, 0, 0, 0.5) -- Semi-transparent red
    -- love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(1, 1, 1, 1) -- Reset color back to normal
end
