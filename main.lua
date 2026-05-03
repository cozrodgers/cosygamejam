VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 600

local screenScale = 1
local offsetX = 0
local offsetY = 0

local bgImage
local game_started = false


function love.load()

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(VIRTUAL_HEIGHT, VIRTUAL_WIDTH, { resizable = true, minwidth = 400, minheight = 400 })
    love.window.setTitle("Mouse Whomp")

    Object = require "classic"
    require "player"
    require "lives"
    require "food"
    require "bomb"
    require "itemSpawner"

    Player = Player()
    ItemSpawner = ItemSpawner(0, 0, VIRTUAL_WIDTH, 10)
    LivesUI = LivesUI()

    start_btn = {}
    start_btn.id = "start"
    start_btn.x = (VIRTUAL_HEIGHT / 2) - 40
    start_btn.y = (VIRTUAL_WIDTH / 2) - 30
    start_btn.w = 82
    start_btn.h = 40
    bgImage = love.graphics.newImage("assets/desert.png")
end

function love.resize(w, h)
    updateScaling(w, h)
end

function updateScaling(ww, wh)
    -- find max scale we can hit before cutting off the game
    screenScale = math.min(ww / VIRTUAL_WIDTH, wh / VIRTUAL_HEIGHT)
    -- calcuate any offsets so we an center the game in the window
    offsetX = (ww - VIRTUAL_WIDTH * screenScale) / 2
    offsetY = (wh - VIRTUAL_HEIGHT * screenScale) / 2
end

function love.update(dt)
    if game_started then
        Player:update(dt)
        ItemSpawner:update(dt)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if (button == 1) then
        -- check if hovering bounding box of button
        local was_collision = CheckCollision(start_btn.x, start_btn.y, start_btn.w, start_btn.h, x, y, 10, 10)
        if was_collision then
            game_started = true
        end
        print("Left mouse button pressed: ", x, y)
    elseif (button == 2) then
        print("Right mouse button pressed: ", x, y)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if (key == "space") then
        print("Space key pressed")
        local previousPos = Player.y
        Player.y = Player.y - 8
        Player.y = previousPos
    end
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
        x2 < x1 + w1 and
        y1 < y2 + h2 and
        y2 < y1 + h1
end

function DrawGameScreen()
    love.graphics.draw(
        bgImage,
        VIRTUAL_WIDTH / 2,
        VIRTUAL_HEIGHT / 2,
        math.pi / 2,
        2,
        2,
        bgImage:getWidth() / 2,
        bgImage:getHeight() / 2
    )
    love.graphics.print("Time till next food: " .. (ItemSpawner.spawnInterval - ItemSpawner.spawnTimer), 10, 10)
    love.graphics.print("Score: " .. Player.score, 10, 30)
    ItemSpawner:draw()
    Player:draw()
    LivesUI:draw()
end

function DrawStartScreen()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH)
    DrawButton(start_btn)
end

function DrawButton(button)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", button.x, button.y, button.w, button.h)
    love.graphics.printf("Click to Start", 0, VIRTUAL_WIDTH / 2 - 20, VIRTUAL_HEIGHT, "center")
end

function love.draw()
    -- save the defaul unscaled graphics state
    love.graphics.push()

    -- move drawing start to account for the letterboxing
    love.graphics.translate(offsetX, offsetY)

    -- scale the entire game
    love.graphics.scale(screenScale, screenScale)

    if (game_started == false) then
        DrawStartScreen()
    else
        DrawGameScreen()
    end

    love.graphics.pop()
end
