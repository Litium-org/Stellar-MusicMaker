interface = {}

interface.items = {}

pitchSlider = {
    value = 1,
    min = 0.1,
    max = 3,
    step = 0.1
}

speedSlider = {
    value = 3,
    min = 1,
    max = 20,
    step = 1
}

function interface.load(file)
    interface.items = json.decode(love.filesystem.read(file))
end

function interface.generate()
    for _, item in ipairs(interface.items.elements) do
        if item.type == "button" then
            suit.Button(item.text, {id = item.id}, item.position[1], item.position[2], item.size[1], item.size[2])
        elseif item.type == "label" then
            suit.Label(item.text, item.position[1], item.position[2], item.size[1], item.size[2])
        end
    end
    suit.Label(tostring(pointer.channel .. "/ 5"), 32, 64, 32, 32)
    suit.Label(tostring(pointer.section .. "/ 64"), 128, 128, 64, 32)

    if suit.isHit("btn_minusLayer") then
        pointer.channel = pointer.channel - 1
    end
    if suit.isHit("btn_plusLayer") then
        pointer.channel = pointer.channel + 1
    end

    if suit.isHit("btn_minusSection") then
        table.remove(Song.sections, pointer.section)
        pointer.section = pointer.section - 1
    end
    if suit.isHit("btn_plusSection") then
        Song.sections[pointer.section + 1] = sectionBase
        pointer.section = pointer.section + 1
    end
    
    if suit.isHit("btn_Export") then
        Song.pitch = round(pitchSlider.value)
        Song.speed = math.floor(speedSlider.value)
        local exportFile = love.filesystem.newFile("Toolkit/MusicTracker/exportSong.smf", "w")
        exportFile:write(love.data.compress("string", "zlib", json.encode(Song)))
        exportFile:close()
    end

    if suit.isHit("btn_Play") then
        Song.pitch = round(pitchSlider.value)
        Song.speed = math.floor(speedSlider.value)
        apu.loadSong(Song)
        apu.play()
    end

    suit.Slider(pitchSlider, {vertical = true}, 640, 96, 24, 72)
    suit.Label(tostring(round(pitchSlider.value)), 640, 64, 128, 24)
    suit.Label(tostring(math.floor(speedSlider.value)), 666, 72, 128, 24)
    suit.Slider(speedSlider, {vertical = true}, 666, 96, 24, 72)
end

function round(a)
    return tonumber(string.format("%.3f", a))
end

return interface