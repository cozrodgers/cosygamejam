LivesUI = Object:extend()

-- globals
LivesUI.image = nil
function LivesUI:new(x, y, w, h)
    if LivesUI.image == nil then
        LivesUI.image = love.graphics.newImage("assets/hearts.png")
        local imgW, imgH = LivesUI.image:getDimensions()
        self.quad = love.graphics.newQuad(0, 0, 16, 16, imgW, imgH)
    end
    self.scale = 2
    self.x = x or VIRTUAL_WIDTH / 2 
    self.y = y or self.height
end

function LivesUI:update(dt)
end

function LivesUI:draw()
    -- for each life left need to draw a heart sprite
    for i = 1, Player.lives, 1 do
        love.graphics.draw(self.image, self.quad, self.x + ((self.scale * 16) * i), self.y, 0, self.scale, self.scale)
    end
end
