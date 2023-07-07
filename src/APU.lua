apu = {
    Pointer = {
        isPlaying = false,
        isLooping = false,
        timer = 0,
        position = 1,
        section = 1,
    },
    Channels = {
        ["square"] = {},
        ["sine"] = {},
        ["triangle"] = {},
        ["sawtooth"] = {},
        ["noise"] = {},
    },
    songData = {}
}

function apu.loadSong(path)
    if type(path) == "table" then
        apu.songData = path
    else
        apu.songData = json.decode(love.filesystem.read(path))
    end
    print("song loaded")
    apu.Channels.square = apu.songData.sections[apu.Pointer.section][1]
    apu.Channels.sine = apu.songData.sections[apu.Pointer.section][2]
    apu.Channels.triangle = apu.songData.sections[apu.Pointer.section][3]
    apu.Channels.sawtooth = apu.songData.sections[apu.Pointer.section][4]
    apu.Channels.noise = apu.songData.sections[apu.Pointer.section][5]
    print(debug.getTableContent(apu.Channels))
end

function apu.play()
    print("shit playing")
    apu.Pointer.isPlaying = true
end

function apu.update()
    if apu.Pointer.isPlaying then
        print("is shit updating")
        apu.Channels.square = apu.songData.sections[apu.Pointer.section][1]
        apu.Channels.sine = apu.songData.sections[apu.Pointer.section][2]
        apu.Channels.triangle = apu.songData.sections[apu.Pointer.section][3]
        apu.Channels.sawtooth = apu.songData.sections[apu.Pointer.section][4]
        apu.Channels.noise = apu.songData.sections[apu.Pointer.section][5]

        apu.Pointer.timer = apu.Pointer.timer + 1
        if apu.Pointer.timer > apu.songData.speed then
            print("is shit updating 2")
            apu.Pointer.timer = 0
            apu.Pointer.position = apu.Pointer.position + 1

            if apu.Channels["square"][apu.Pointer.position] > 0 then
                soundthread.newTone(apu.Channels["square"][apu.Pointer.position], 2, "square", 1, 1)
            end
            if apu.Channels["sine"][apu.Pointer.position] > 0 then
                soundthread.newTone(apu.Channels["sine"][apu.Pointer.position], 2, "sine", 1, 1)
            end
            if apu.Channels["triangle"][apu.Pointer.position] > 0 then
                soundthread.newTone(apu.Channels["triangle"][apu.Pointer.position], 2, "triangle", 1, 1)
            end
            if apu.Channels["sawtooth"][apu.Pointer.position] > 0 then
                soundthread.newTone(apu.Channels["sawtooth"][apu.Pointer.position], 2, "sawtooth", 1, 1)
            end
            if apu.Channels["noise"][apu.Pointer.position] > 0 then
                soundthread.newTone(apu.Channels["noise"][apu.Pointer.position], 2, "noise", 1, 1)
            end

            if apu.Pointer.position >= 32 then
                apu.Pointer.position = 1
                apu.Pointer.section = apu.Pointer.section + 1
                if apu.Pointer.section >= #apu.songData.sections then
                    if apu.Pointer.isLooping then
                        apu.Pointer.position = 1
                        apu.Pointer.section = 1
                    else
                        apu.Pointer.position = 1
                        apu.Pointer.section = 1
                        apu.Pointer.isPlaying = false
                        print("stop")
                    end
                end
            end
        end
    end
end

return apu