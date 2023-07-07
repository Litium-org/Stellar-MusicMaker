sndeditor = {}

function sndeditor.init()
    interface = require 'src.Interface'
    interface.load("jcss/editor.jcss")

    Note = love.graphics.newImage("resources/images/note.png")

    currentPart = 0

    pointer = {
        position = 1,
        section = 1,
        channel = 1,
    }

    colors = {
        {0, 255, 255},
        {255, 85, 0},
        {0, 128, 0},
        {170, 0, 0},
        {109, 109, 109},
    }

    currentLayer = 1
    sectionBase = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    }
end

function sndeditor.render()
    local txtY = 0
    local txtYList = 199
    --% render the grid %--
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 128, 192, 1024, 512)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setColor(1, 1, 1, 0.3)
    for y = 1, 16 , 1 do
        for x = 1, 32, 1 do
            love.graphics.rectangle("line", 96 + (x * 32), 160 + (y * 32), 32, 32)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", 128, 192, 1024, 512)

    --%  Cursor %--
    if love.mouse.getX() >= 128 and love.mouse.getX() < 1152 and love.mouse.getY() >= 192 and love.mouse.getY() < 704 then
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", mx, my, 32, 32)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineWidth(1)
    end

    --% Render the notes %--
    for note = 1, #Song.sections[pointer.section][pointer.channel], 1 do
        if Song.sections[pointer.section][pointer.channel][note] > 0 then
            if 160 + -(currentPart * 32) + (Song.sections[pointer.section][pointer.channel][note] * 32) >= 192 then
                if 160 + -(currentPart * 32) + (Song.sections[pointer.section][pointer.channel][note] * 32) <= 702 then
                    love.graphics.setColor(colors[pointer.channel][1] / 255, colors[pointer.channel][2] / 255, colors[pointer.channel][3] / 255, 1)
                    love.graphics.draw(Note, 96 + (note * 32), 160 + -(currentPart * 32) + (Song.sections[pointer.section][pointer.channel][note] * 32) , 0, 2, 2)
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
        end
    end

    --% Render the notes hex %--
    for n = 1 + currentPart, 16 + currentPart, 1 do
        love.graphics.print(string.format("%s", tostring(tones[n])), 64, txtYList)
        txtYList = txtYList + 32
    end

    --% debug %--
    for note = 1, #Song.sections[pointer.section][pointer.channel], 1 do
        love.graphics.print(Song.sections[pointer.section][pointer.channel][note], 10, txtY)
        txtY = txtY + 15
    end
end

function sndeditor.update(elapsed)
    interface.generate()
    if pointer.channel < 1 then
        pointer.channel = 1
    elseif pointer.channel > 5 then
        pointer.channel = 5
    end
    if pointer.section < 1 then
        pointer.section = 1
    elseif pointer.section > 64 then
        pointer.section = 64
    end

    if currentPart < 0 then
        currentPart = 0
    elseif currentPart > 0 then
        currentPart = 0
    end

    local cx, cy = love.mouse.getPosition()
    mx, my = math.floor(cx / 32) * 32, math.floor(cy / 32) * 32
end

function sndeditor.wheelmoved(x, y)
    if y > 0 then
        currentPart = currentPart - 1
    elseif y < 0 then
        currentPart = currentPart + 1
    end
end

function sndeditor.mousepressed(x, y, button)
    if button == 1 then
        if x >= 128 and x < 1152 and y >= 192 and y < 704 then
            if Song.sections[pointer.section][pointer.channel][math.floor(mx / 32 - 3)] > 0 then
                Song.sections[pointer.section][pointer.channel][math.floor(mx / 32 - 3)] = 0
            else
                Song.sections[pointer.section][pointer.channel][math.floor(mx / 32 - 3)] = math.floor(my / 32 - 5) + currentPart
            end
        end
    end
end

---------------------------------------------------------------------



return sndeditor