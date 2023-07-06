---------------------------------------------------------------------------------------
------------                                                               ------------
------------  █▀▀ █ █ █▀█ █ █   █▀█ ▀█▀ █ █ █▀▀ █▀▄   █ █ █▀▀ █▀▀ █▀▄ █▀▀  ------------
------------  ▀▀█ █▀█ █ █ █▄█   █ █  █  █▀█ █▀▀ █▀▄   █ █ ▀▀█ █▀▀ █▀▄ ▀▀█  ------------
------------  ▀▀▀ ▀ ▀ ▀▀▀ ▀ ▀   ▀▀▀  ▀  ▀ ▀ ▀▀▀ ▀ ▀   ▀▀▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀▀▀  ------------     
------------             █ █ █▀▄ ▀█▀ ▀█▀ ▀█▀ █▀▀ █▀█   █▀▄ █ █             ------------
------------             █▄█ █▀▄  █   █   █  █▀▀ █ █   █▀▄  █              ------------
------------             ▀ ▀ ▀ ▀ ▀▀▀  ▀   ▀  ▀▀▀ ▀ ▀   ▀▀   ▀              ------------
------------      █▀▀ █   █▀█ █▄█ ▀█▀ █▀█ █▀▀ █▀▄ █▀▀ █▀▀ █▀█ █▀▄ █▀▀      ------------
------------      █▀▀ █   █▀█ █ █  █  █ █ █ █ █▀▄ █   █   █▀█ █▀▄ ▀▀█      ------------
------------      ▀   ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀      ------------
---------------------------------------------------------------------------------------

minetest.register_chatcommand("toggle_show_other_users", {
    params =  "",
    description = "Toggle showing other users on or off.",
    func = function(params)
        local show_other_ctf_util_users = minetest.settings:get_bool("show_other_ctf_util_users")
        minetest.settings:set_bool("show_other_ctf_util_users", not show_other_ctf_util_users)
        local str = "Disabled"
        local color = "red"
        if show_other_ctf_util_users == false then str = "Enabled" color = "green" end
        minetest.display_chat_message(minetest.colorize(color, str) .. minetest.colorize("yellow", " showing other CTF Util users."))
    end
})

minetest.register_on_receiving_chat_message(function(message)
    if minetest.localplayer then
        local handled = check_ignorelist(message)
        if handled == false then
            if minetest.settings:get_bool("show_other_ctf_util_users") == true then
                if string.find(message, string.char(127)) then
                    custom = minetest.settings:get("custom_message")
					if custom then
                    	minetest.display_chat_message(minetest.colorize("#FF5000", custom .. " ") .. message)
					end
                    return true
                end
            end
        end
        return(handled)
    end
end)