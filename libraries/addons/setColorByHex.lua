function love.graphics.setHexColor(hex)
    if type(hex) == "number" then
        hex = ("%x"):format(hex)
    end

    if #hex < 8 then
        hex = hex..("f"):rep(8 - #hex)
    end

    local r = tonumber(hex:sub(1, 2), 16)/255
    local g = tonumber(hex:sub(3, 4), 16)/255
    local b = tonumber(hex:sub(5, 6), 16)/255
    local a = tonumber(hex:sub(7, 8), 16)/255

    love.graphics.setColor(r, g, b, a)
end

return love.graphics.setHexColor