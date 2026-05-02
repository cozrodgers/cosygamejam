Button = Object:extend()

function Button:new(x, y, w, h, text, onClick)
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    self.text = text
    self.onClick = onClick
    self.hovered = false
end

function Button:update(dt)
    -- get mouse position
    local mouseX, mouseY = love.mouse.getPosition()

    self.hovered = mouseX >= self.x and mouseX <= self.x + self.width and
        mouseY >= self.y and mouseY <= self.y + self.height
end

function Button:mousepressed(x, y)
    if self.hovered and self.onClick then
        print("Button clicked: ", self.text, " at position: ", x, y)
        self.onClick()
    end
end

function Button:draw()
    if self.hovered then
        love.graphics.setColor(0.7, 0.7, 0.7) -- lighter color on hover
    else
        love.graphics.setColor(1, 1, 1)       -- normal color
    end

    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0, 0, 0) -- black text
    love.graphics.printf(self.text, self.x, self.y + self.height / 2 - 6, self.width, "center")
end
