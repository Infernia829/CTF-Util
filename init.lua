time_left = 0
timer = 0

function format_time(seconds)
    local minutes = math.floor(seconds / 60)
    local remaining_seconds = seconds % 60
    return string.format("%02d:%02d", minutes, remaining_seconds)
end

function say(message)
    minetest.send_chat_message(message)
    if minetest.get_server_info().protocol_version < 29 then
        local name = minetest.localplayer:get_name()
        minetest.display_chat_message("<"..name.."> " .. message)
    end
end

function check_ignorelist(message)
    local ignorelist = (minetest.settings:get("ignore_list") or ""):split(",")
    for i = 1, #ignorelist do
        search_string = "<" .. ignorelist[i] .. ">"
        if string.find(message, search_string) then
            return true
        end
    end
    return false
end

function donate_counter(dtime)
    local hudpos = {x = 0.9, y = 0.3}
    timer = timer + dtime
    if timer >= 1 then
        if time_left > 0 then
            time_left = time_left - 1
        end
        timer = timer - 1
    end
    if minetest.localplayer then
        formatted_time = format_time(time_left)
        
        if is_declared then
            minetest.localplayer:hud_change(donate_number, "text", formatted_time)
        else
            donate_text = minetest.localplayer:hud_add({hud_elem_type = "text", position = hudpos, offset = {x = 0, y = 0}, text = "Donate: ", alignment = {x = 1, y = 1}, scale = {x = 1, y = 1}, number = 0xFFFFFF})
            donate_number = minetest.localplayer:hud_add({hud_elem_type = "text", position = hudpos, offset = {x = 70, y = 0}, text = formatted_time, alignment = {x = 1, y = 1}, scale = {x = 1, y = 1}, number = 0xFFFFFF})
            is_declared = true
        end
    end
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
                print(message .. " is already blocked!")
                return
            end
            local temp_data = minetest.settings:get("ignore_list")
            local temp_data = temp_data .. "," .. message
            minetest.settings:set("ignore_list", temp_data)
            print("Added " .. message .. " to your ignore list.")
            return
        end
        print("Please enter a name.")
    end
})

minetest.register_chatcommand("unblock", {
    params = "<player_name>",
    description = "Remove players from your ignore list.",
    func = function(message)
        if message then
            local found_name = false
            local str = minetest.settings:get("ignore_list")
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
                print("Removed " .. message .. " from your ignore list.")
            else
                print(message .. " isn't blocked!")
            end
            return
        end
        print("Please enter a name.")
    end
})

minetest.register_on_sending_chat_message(function(message)
    if string.sub(message, 1, 1) == "/" then
        return false
    else
        say(message .. string.char(127))
        return true
    end
end)

minetest.register_on_receiving_chat_message(function(message)
    if minetest.localplayer then
        local player_name = minetest.localplayer:get_name()
        local search_string = player_name .. " donated"
        local handled = check_ignorelist(message)
        if string.find(message, search_string) then
            time_left = 600
        end
        if handled == false then
            if minetest.settings:get_bool("show_other_ctf_util_users") == true then
                if string.find(message, string.char(127)) then
                    custom = minetest.settings:get("custom_message")
                    print(minetest.colorize("#FF5000", custom .. " ") .. message)
                    return true
                end
            end
        end
        return(handled)
    end
end)

minetest.register_globalstep(function(dtime)
    if minetest.settings:get_bool("donate_counter") == true then
        donate_counter(dtime)
    end
end)