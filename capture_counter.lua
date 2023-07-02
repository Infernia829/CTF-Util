---------------------------------------------------------------------------------
------------                                                         ------------
------------         █▀▀ █▀█ █▀█ █▀▀ █▀█ █ █ █▀█ ▀█▀ █▀▀ █▀▄         ------------
------------         █   █▀█ █▀▀ █   █ █ █ █ █ █  █  █▀▀ █▀▄         ------------
------------         ▀▀▀ ▀ ▀ ▀   ▀▀▀ ▀▀▀ ▀▀▀ ▀ ▀  ▀  ▀▀▀ ▀ ▀         ------------     
------------          █ █ █▀▄ ▀█▀ ▀█▀ ▀█▀ █▀▀ █▀█   █▀▄ █ █          ------------
------------          █▄█ █▀▄  █   █   █  █▀▀ █ █   █▀▄  █           ------------
------------          ▀ ▀ ▀ ▀ ▀▀▀  ▀   ▀  ▀▀▀ ▀ ▀   ▀▀   ▀           ------------
------------         █▀█ █▀▀ █▀█ █▀▀ █▀▀ ▀█  ▀▀▄ ▀▀█ █ █ █▀▀         ------------
------------         █▀▀ █▀▀ █▀█ █   █▀▀  █  ▄▀   ▀▄  ▀█ ▀▀▄         ------------
------------         ▀   ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀    ▀ ▀▀          ------------
---------------------------------------------------------------------------------

minetest.register_chatcommand("toggle_capture_counter", {
    params =  "",
    description = "Toggle the Capture Counter on or off.",
    func = function(params)
        local capture_counter = minetest.settings:get_bool("capture_counter")
        minetest.settings:set_bool("capture_counter",  not capture_counter)
        local str = "Disabled"
        local color = "red"
        if capture_counter == false then str = "Enabled" color = "green" else minetest.localplayer:hud_remove(hud) hud = nil end
        minetest.display_chat_message(minetest.colorize(color, str) .. minetest.colorize("yellow", " Capture Counter."))
    end
})

local time = 0
local subtract = 0
local refresh = 0.1
local time_multiplier = 1
local names = {}
local times = {}
core.register_on_receiving_chat_message(function(message)
    if string.find(message, "has taken ") and string.find(message, " flag") then
        player = message:sub(13,string.find(message, "has taken ")-26)
        names[#names+1] = player
        times[#times+1] = time
    elseif string.find(message, "has dropped ") and string.find(message, " flag") then
        player = message:sub(13,string.find(message, "has dropped ")-26)
        for i=1, #names do
            if names[i] == player then
                times[i], names[i] = nil
            end
        end
    elseif string.find(message, "has captured ") and string.find(message, " flag") then
        player = message:sub(13,string.find(message, "has captured ")-26)
        for i = 1, #names do
            if names[i] == player then
                times[i], names[i] = nil
            end
        end
    end
    if string.find(message, "Map: ") and string.find(message, " by ") then
        names = {}
        times = {}
        if hud then
            minetest.localplayer:hud_change(hud, "text", "")
        end
    end
end)

minetest.register_globalstep(function(dtime)
    time = time + dtime
    if time - subtract > refresh then
        local hudpos = {x = 0.5, y = 0.09}
        subtract = subtract + refresh
        local screen_message = ""
        for i = 1, #names do
            name = names[i]
            starttime = times[i]
            if starttime and name then
                remainingtime = format_time((180-(time - starttime))*time_multiplier)
                if (180-(time - starttime))*time_multiplier > 0 then
                    screen_message = screen_message .. name .. " has " .. remainingtime .. " seconds to capture.\n"
                else
                    names[i], times[i] = nil
                    if minetest.settings:get_bool("capture_counter") == true then
                        minetest.localplayer:hud_change(hud, "text", minetest.colorize("orange", screen_message))
                    end
                end
            end
        end
        
        if screen_message and minetest.settings:get_bool("capture_counter") == true  and minetest.localplayer then
            if hud then
                minetest.localplayer:hud_change(hud, "text", minetest.colorize("orange", screen_message))
            else
                hud = minetest.localplayer:hud_add({hud_elem_type = "text", position = hudpos, offset = {x = 0, y = 0}, text = minetest.colorize("orange", screen_message), alignment = {x = 0, y = 0}, scale = {x = 1, y = 1}, number = 0xFFFFFF})
            end
        end
    end
end)

function format_time(seconds)
    local minutes = math.floor(seconds / 60)
    local remaining_seconds = seconds % 60
    return string.format("%02d:%02d", minutes, remaining_seconds)
end