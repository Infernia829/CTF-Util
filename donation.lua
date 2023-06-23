---------------------------------------------------------------------------------
------------                                                         ------------
------------             █▀▄ █▀█ █▀█ █▀█ ▀█▀ ▀█▀ █▀█ █▀█             ------------
------------             █ █ █ █ █ █ █▀█  █   █  █ █ █ █             ------------
------------             ▀▀  ▀▀▀ ▀ ▀ ▀ ▀  ▀  ▀▀▀ ▀▀▀ ▀ ▀             ------------     
------------          █ █ █▀▄ ▀█▀ ▀█▀ ▀█▀ █▀▀ █▀█   █▀▄ █ █          ------------
------------          █▄█ █▀▄  █   █   █  █▀▀ █ █   █▀▄  █           ------------
------------          ▀ ▀ ▀ ▀ ▀▀▀  ▀   ▀  ▀▀▀ ▀ ▀   ▀▀   ▀           ------------
------------   █▀▀ █   █▀█ █▄█ ▀█▀ █▀█ █▀▀ █▀▄ █▀▀ █▀▀ █▀█ █▀▄ █▀▀   ------------
------------   █▀▀ █   █▀█ █ █  █  █ █ █ █ █▀▄ █   █   █▀█ █▀▄ ▀▀█   ------------
------------   ▀   ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀   ------------
---------------------------------------------------------------------------------

minetest.register_chatcommand("toggle_donate_counter", {
    params = "none",
    description = "Toggle the Donate Counter on or off.",
    func = function(params)
        local donate_counter = minetest.settings:get_bool("donate_counter")
        minetest.settings:set_bool("donate_counter",  not donate_counter)
        local str = "Disabled"
        local color = "red"
        if donate_counter == false then str = "Enabled" color = "green" else is_declared = false minetest.localplayer:hud_remove(donate_number) minetest.localplayer:hud_remove(donate_text) end
        minetest.display_chat_message(minetest.colorize(color, str) .. minetest.colorize("yellow", " Donate Counter."))
    end
})

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

time_left = 0
timer = 0
has_loaded = false
function format_time(seconds)
    local minutes = math.floor(seconds / 60)
    local remaining_seconds = seconds % 60
    return string.format("%02d:%02d", minutes, remaining_seconds)
end

minetest.register_on_receiving_chat_message(function(message)
    if minetest.localplayer then
        local player_name = minetest.localplayer:get_name()
        local search_string = player_name .. " donated"
        if string.find(message, search_string) then
            time_left = 600
        end
        return false
    end
end)

minetest.register_globalstep(function(dtime)
    if minetest.settings:get_bool("donate_counter") == true then
        donate_counter(dtime)
    end
end)