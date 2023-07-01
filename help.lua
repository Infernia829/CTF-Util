---------------------------------------------------------------------------------
------------                                                         ------------
------------                    █ █ █▀▀ █   █▀█                      ------------
------------                    █▀█ █▀▀ █   █▀▀                      ------------
------------                    ▀ ▀ ▀▀▀ ▀▀▀ ▀                        ------------     
------------          █ █ █▀▄ ▀█▀ ▀█▀ ▀█▀ █▀▀ █▀█   █▀▄ █ █          ------------
------------          █▄█ █▀▄  █   █   █  █▀▀ █ █   █▀▄  █           ------------
------------          ▀ ▀ ▀ ▀ ▀▀▀  ▀   ▀  ▀▀▀ ▀ ▀   ▀▀   ▀           ------------
------------   █▀▀ █   █▀█ █▄█ ▀█▀ █▀█ █▀▀ █▀▄ █▀▀ █▀▀ █▀█ █▀▄ █▀▀   ------------
------------   █▀▀ █   █▀█ █ █  █  █ █ █ █ █▀▄ █   █   █▀█ █▀▄ ▀▀█   ------------
------------   ▀   ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀   ------------
---------------------------------------------------------------------------------

minetest.register_chatcommand("help", {
    params =  "",
    description = "Send the CTF Util help message",
    func = function(params)
        minetest.display_chat_message(minetest.colorize("forestgreen", "*** Help ***"))
        for command, definition in pairs(minetest.registered_chatcommands) do
            local commandName = command
            local description = definition.description
            local syntax = definition.params
            minetest.display_chat_message(minetest.colorize("slateblue", "." .. commandName .. " " .. syntax ..": " .. description))
        end
    end
})