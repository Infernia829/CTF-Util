local modname = assert(core.get_current_modname())
dofile(core.get_modpath(modname) .. "chat_welcome.lua")
dofile(core.get_modpath(modname) .. "capture_counter.lua")
dofile(core.get_modpath(modname) .. "donation.lua")
dofile(core.get_modpath(modname) .. "particles.lua")
dofile(core.get_modpath(modname) .. "ignore.lua")

function say(message)
    minetest.send_chat_message(message)
    if minetest.get_server_info().protocol_version < 29 then
        local name = minetest.localplayer:get_name()
        minetest.display_chat_message("<"..name.."> " .. message)
    end
end

minetest.register_on_sending_chat_message(function(message)
    if string.sub(message, 1, 1) == "/" then
        return false
    else
        say(message .. string.char(127))
        return true
    end
end)