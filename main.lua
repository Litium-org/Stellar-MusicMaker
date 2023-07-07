function love.load()
    suit = require 'libraries.suit'
    json = require 'libraries.json'
    lue = require 'libraries.lue'

    --% addons loader --
    Addons = love.filesystem.getDirectoryItems("libraries/addons")
    for addon = 1, #Addons, 1 do
        require("libraries.addons." .. string.gsub(Addons[addon], ".lua", ""))
    end

    love.graphics.setDefaultFilter("nearest", "nearest")

    --% folders --
    love.filesystem.createDirectory("Toolkit/MusicTracker")
    --love.filesystem.createDirectory("Toolkit/MusicTracker/")

    tones = require 'src.Tones'
    soundthread = require 'src.SoundThread'
    sndeditor = require 'src.SoundEditor'
    apu = require 'src.APU'

    table.sort(tones, function(a, b)
        return a > b
    end)

    _Section = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    }

    Song = {
        _version = "0.0.1",
        speed = 10,
        pitch = 1,
        sections = {}
    }

    for s = 1, 1, 1 do
        table.insert(Song.sections, _Section)
    end

    gradient = love.graphics.newImage("resources/images/gradient.png")
    --lue:setColor("my-color", {255, 255, 255})
    lue:setHueSpeed(30)

    sndeditor.init()
end

function love.draw()
    love.graphics.setColor(lue:getHueColor(255, 50, 255))
    love.graphics.draw(gradient, 0, love.graphics.getHeight() - gradient:getHeight(), 0, love.graphics.getWidth(), 1)
    love.graphics.draw(gradient, 0, gradient:getHeight(), 0, love.graphics.getWidth(), -1)
    love.graphics.setColor(1, 1, 1, 1)
    sndeditor.render()
    suit.draw()
end

function love.update(elapsed)
    lue:update(elapsed)
    sndeditor.update(elapsed)
    apu.update()
end

function love.keypressed(k)
    suit.keypressed(k)
end

function love.wheelmoved(x, y)
    sndeditor.wheelmoved(x, y)
end

function love.mousepressed(x, y, button)
    sndeditor.mousepressed(x, y, button)
end
