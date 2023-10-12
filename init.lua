local modname = assert(core.get_current_modname())
local modpath = core.get_modpath(modname)
dofile(modpath .. "chat_welcome.lua")
dofile(modpath .. "show_ctf_util.lua")
dofile(modpath .. "capture_counter.lua")
dofile(modpath .. "donation.lua")
dofile(modpath .. "particles.lua")
dofile(modpath .. "ignore.lua")
dofile(modpath .. "xray.lua")
dofile(modpath .. "help.lua")

minetest.register_on_sending_chat_message(function(message)
    return say(message)
end)

function say(message)
    if string.sub(message, 1, 1) ~= "/" then
        message = message .. string.char(127)
    else
        return false
    end
    minetest.send_chat_message(message)
	local name = minetest.localplayer:get_name()
	minetest.display_chat_message("<"..name.."> " .. message)
    return true
end