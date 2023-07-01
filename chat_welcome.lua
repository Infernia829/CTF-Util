---------------------------------------------------------------------------------
------------                                                         ------------
------------       █▀█ █ █ ▀█▀ █▀█ █ █ █▀▀ █   █▀▀ █▀█ █▄█ █▀▀       ------------
------------       █▀█ █ █  █  █ █ █▄█ █▀▀ █   █   █ █ █ █ █▀▀       ------------
------------       ▀ ▀ ▀▀▀  ▀  ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀▀▀       ------------     
------------          █ █ █▀▄ ▀█▀ ▀█▀ ▀█▀ █▀▀ █▀█   █▀▄ █ █          ------------
------------          █▄█ █▀▄  █   █   █  █▀▀ █ █   █▀▄  █           ------------
------------          ▀ ▀ ▀ ▀ ▀▀▀  ▀   ▀  ▀▀▀ ▀ ▀   ▀▀   ▀           ------------
------------         █▀█ █▀▀ █▀█ █▀▀ █▀▀ ▀█  ▀▀▄ ▀▀█ █ █ █▀▀         ------------
------------         █▀▀ █▀▀ █▀█ █   █▀▀  █  ▄▀   ▀▄  ▀█ ▀▀▄         ------------
------------         ▀   ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀    ▀ ▀▀          ------------
---------------------------------------------------------------------------------

minetest.register_chatcommand("toggle_welcome_messages", {
    params =  "",
    description = "Toggle sending welcome messages on or off.",
    func = function(params)
        local welcome_messages = minetest.settings:get_bool("welcome_messages")
        minetest.settings:set_bool("welcome_messages",  not welcome_messages)
        local str = "Disabled"
        local color = "red"
        if welcome_messages == false then str = "Enabled" color = "green" end
        minetest.display_chat_message(minetest.colorize(color, str) .. minetest.colorize("yellow", " sending welcome messages."))
    end
})

storage = core.get_mod_storage()
minetest.register_chatcommand("welcome", {
    params = "<player_name>",
    description = "Welcome a player when they join",
    func = function(message)
        temp_data = (storage:get_string("names"))
        data_list = temp_data:split(",")
        local alreadyin = false
        for i = 1, #data_list do
            if (data_list[i] == message) then
                alreadyin = true
            end
        end
        if alreadyin == false then
            temp_data = temp_data .. "," .. message
            storage:set_string("names", temp_data)
            storage:set_string(message, "")
            minetest.display_chat_message(minetest.colorize("#FF5000", "Will welcome " .. message .. " next time they log on."))
        else
            minetest.display_chat_message(minetest.colorize("#FF5000", "Already in list"))
        end
    end,
})

minetest.register_chatcommand("dont_welcome", {
    params = "<player_name>",
    description = "Stop welcoming a player when they join.",
    func = function(message)
        if storage:get_string("names"):find(message) then
            storage:set_string("names",storage:get_string("names"):sub(1, storage:get_string("names"):find(message)-2) .. storage:get_string("names"):sub(storage:get_string("names"):find(message)+storage:get_string("names"):len(),-1))
            minetest.display_chat_message(minetest.colorize("#FF5000", "Removed player " .. message .. " from welcome list."))
        else
            minetest.display_chat_message(minetest.colorize("#FF5000", "Cannot remove, not in welcome list"))
        end
    end,
})

minetest.register_chatcommand("set_welcome_message", {
    params = "<player> <message>",
    description = "Set the welcome message for a specific player.",
    func = function(message)
        player = tostring(message:sub(1,message:find(" ")-1))
        storage:set_string(player,message:sub(message:find(" ")+1,-1))
        minetest.display_chat_message(minetest.colorize("#FF5000", "Message to send to " .. player .. " is: " .. storage:get_string(player)))
    end,
})

minetest.register_chatcommand("reset_welcomes", {
    params =  "",
    description = "Reset your welcome list.",
    func = function(message)
        temp_data = (storage:get_string("names"))
        data_list = temp_data:split(",")
        for i = 1, #data_list do
           storage:set_string(data_list[i], "")
        end
        storage:set_string("names", "")
    end,
})

minetest.register_chatcommand("list_welcomes", {
    params =  "",
    description = "List players to be welcomed.",
    func = function(message)
        minetest.display_chat_message(minetest.colorize("#FF5000", "Welcome names: " .. storage:get_string("names")))
    end,
})


minetest.register_on_receiving_chat_message(function(message)
    if string.find(message, "***") and string.find(message, " joined the game.") and not (minetest.settings:get_bool("welcome_messages") == false) then
        local name = minetest.localplayer:get_name()
        start = (string.find(message, "*** "))
        stop = (string.find(message, " joined the game."))
        message = string.sub(message,start+16,stop-13)
        
        local temp_msg = tostring(message)
    	temp_data = (storage:get_string("names"))
        data_list = temp_data:split(",")
        local indata = false
        for i = 1, #data_list do
           if (data_list[i] == message) then
               indata = true
           end
        end
        if indata == true and not(name == message) then
            minetest.display_chat_message(minetest.colorize("#FF5000", "Welcomed " .. message))
            temp_wb = "wb " .. message
            if not (storage:get_string(message) == "") then
                temp_wb = (storage:get_string(message))
            end
            if storage:get_string(message):find("<name>") then
                temp_wb = (storage:get_string(message):sub(1,storage:get_string(message):find("<name>")-1) .. message .. storage:get_string(message):sub(storage:get_string(message):find("<name>")+6,-1))
            end
            say(temp_wb)
        message = ""
        end
    end
end)

