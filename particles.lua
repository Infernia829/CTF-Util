---------------------------------------------------------------------------------
------------                                                         ------------
------------           █▀█ █▀█ █▀▄ ▀█▀ ▀█▀ █▀▀ █   █▀▀ █▀▀           ------------
------------           █▀▀ █▀█ █▀▄  █   █  █   █   █▀▀ ▀▀█           ------------
------------           ▀   ▀ ▀ ▀ ▀  ▀  ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀           ------------     
------------          █ █ █▀▄ ▀█▀ ▀█▀ ▀█▀ █▀▀ █▀█   █▀▄ █ █          ------------
------------          █▄█ █▀▄  █   █   █  █▀▀ █ █   █▀▄  █           ------------
------------          ▀ ▀ ▀ ▀ ▀▀▀  ▀   ▀  ▀▀▀ ▀ ▀   ▀▀   ▀           ------------
------------   █▀▀ █   █▀█ █▄█ ▀█▀ █▀█ █▀▀ █▀▄ █▀▀ █▀▀ █▀█ █▀▄ █▀▀   ------------
------------   █▀▀ █   █▀█ █ █  █  █ █ █ █ █▀▄ █   █   █▀█ █▀▄ ▀▀█   ------------
------------   ▀   ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀   ------------
---------------------------------------------------------------------------------

minetest.register_chatcommand("toggle_particles", {
    params =  "",
    description = "Toggle hit particles on or off.",
    func = function(params)
        local particles = minetest.settings:get_bool("particles")
        minetest.settings:set_bool("particles",  not particles)
        local str = "Disabled"
        local color = "red"
        if particles == false then str = "Enabled" color = "green" end
        minetest.display_chat_message(minetest.colorize(color, str) .. minetest.colorize("yellow", " particles."))
    end
})

function register_hits()
	if not minetest.localplayer then
		return false
	end
    if minetest.localplayer:get_control().dig and not lmbpress then
        lmbpress = true
        local player_pos = core.camera:get_pos()
        local player_dir = core.camera:get_look_dir()
        local raycast = minetest.raycast(player_pos, vector.add(player_pos, vector.multiply(player_dir, 4)), true, false)
        for pointed_thing in raycast do
            local new_pos = vector.add(pointed_thing.intersection_point, vector.new(-0.2, -0.4, -0.2))
            local other_pos = vector.add(pointed_thing.intersection_point, vector.new(0.2, 0.4, 0.2))
            if pointed_thing.type == "object" then
                minetest.add_particlespawner({
                    amount = 75,
                    time = 0.1,
                    minpos = new_pos,
                    maxpos = other_pos,
                    minvel = {x = -1, y = -2, z = -1},
                    maxvel = {x = 1, y = 2, z = 1},
                    minacc = {x = -0.1, y = -0.1, z = -0.1},
                    maxacc = {x = 0.1, y = 0.1, z = 0.1},
                    minexptime = 0.5,
                    maxexptime = 0.7,
                    minsize = 1,
                    maxsize = 2,
                    collisiondetection = true,
                    collision_removal = false,
                    object_collision = false,
                    vertical = false,
                    texture = "hit.png"
                })
                break
            end
        end
    elseif not minetest.localplayer:get_control().dig then
        lmbpress = false
    end
end

minetest.register_globalstep(function(dtime)
    if minetest.settings:get_bool("particles") == true then
        register_hits()
    end
end)