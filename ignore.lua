---------------------------------------------------------------------------------
------------                                                         ------------
------------                 ▀█▀ █▀▀ █▀█ █▀█ █▀▄ █▀▀                 ------------
------------                  █  █ █ █ █ █ █ █▀▄ █▀▀                 ------------
------------                 ▀▀▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀                 ------------     
------------          █ █ █▀▄ ▀█▀ ▀█▀ ▀█▀ █▀▀ █▀█   █▀▄ █ █          ------------
------------          █▄█ █▀▄  █   █   █  █▀▀ █ █   █▀▄  █           ------------
------------          ▀ ▀ ▀ ▀ ▀▀▀  ▀   ▀  ▀▀▀ ▀ ▀   ▀▀   ▀           ------------
------------   █▀▀ █   █▀█ █▄█ ▀█▀ █▀█ █▀▀ █▀▄ █▀▀ █▀▀ █▀█ █▀▄ █▀▀   ------------
------------   █▀▀ █   █▀█ █ █  █  █ █ █ █ █▀▄ █   █   █▀█ █▀▄ ▀▀█   ------------
------------   ▀   ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀   ------------
---------------------------------------------------------------------------------

function check_ignorelist(message)
    local ignorelist = (minetest.settings:get("ignore_list") or ""):split(",")
    for i = 1, #ignorelist do
        if string.find(message, ignorelist[i]) then
            return true
        else
            return false
        end
    end
    return false
end

minetest.register_chatcommand("block", {
    params = "<player_name>",
    description = "Add players to your ignore list.",
    func = function(message)
        if message then
            local found_name = false
            local str = minetest.settings:get("ignore_list")
            local str_table = str:split(",")
            for i, name in ipairs(str_table) do
                if name == message then
                    found_name = true
                    break
                end
            end
            if found_name then
                minetest.display_chat_message(minetest.colorize("orange", message .. " is already blocked!"))
                return
            end
            local temp_data = minetest.settings:get("ignore_list")
            local temp_data = temp_data .. "," .. message
            minetest.settings:set("ignore_list", temp_data)
            minetest.display_chat_message(minetest.colorize("green", "Added " .. message .. " to your ignore list."))
            return
        end
        minetest.display_chat_message(minetest.colorize("orange", "Please enter a name."))
    end
})

minetest.register_chatcommand("unblock", {
    params = "<player_name>",
    description = "Remove players from your ignore list.",
    func = function(message)
        if message then
            local found_name = false
            local str = minetest.settings:get("ignore_list")
			if not str then
				str = ""
			end
            local str_table = str:split(",")
            for i, name in ipairs(str_table) do
                if name == message then
                    table.remove(str_table, i)
                    found_name = true
                    break
                end
            end
            if found_name then
                local new_str = table.concat(str_table, ",")
                minetest.settings:set("ignore_list", new_str)
                minetest.display_chat_message(minetest.colorize("green", "Removed " .. message .. " from your ignore list."))
            else
                minetest.display_chat_message(minetest.colorize("orange", message .. " isn't blocked!"))
            end
            return
        end
        minetest.display_chat_message(minetest.colorize("orange", "Please enter a name."))
    end
})

minetest.register_on_receiving_chat_message(function(message)
    local handled = check_ignorelist(message)
    return handled
end)