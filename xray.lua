---------------------------------------------------------------------------------
------------														 ------------
------------					█ █ █▀▄ █▀█ █ █						 ------------
------------					▄▀▄ █▀▄ █▀█  █						 ------------
------------					▀ ▀ ▀ ▀ ▀ ▀  ▀						 ------------
------------		  █ █ █▀▄ ▀█▀ ▀█▀ ▀█▀ █▀▀ █▀█   █▀▄ █ █			 ------------
------------		  █▄█ █▀▄  █   █   █  █▀▀ █ █   █▀▄  █			 ------------
------------		  ▀ ▀ ▀ ▀ ▀▀▀  ▀   ▀  ▀▀▀ ▀ ▀   ▀▀   ▀			 ------------
------------			   █▀█ █   █▀▀ ▀█▀ █ █ █▀█ █▀█				 ------------
------------			   █▀▀ █   ▀▀█  █  ▄▀▄ █ █ █▀█				 ------------
------------			   ▀   ▀▀▀ ▀▀▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀▀▀				 ------------
---------------------------------------------------------------------------------

local tagged_ores = {}

minetest.register_chatcommand('xray_find', {
	params = "<node_string>",
    description = "Find specified node in map within a 75 block range.",
	func=function(message)
		local r = 75

		for _, pos in pairs(tagged_ores) do
			minetest.localplayer:hud_remove(tagged_ores[_].hud)
			tagged_ores[_] = nil
		end
		if not minetest.get_node_def(message) then
			minetest.display_chat_message(minetest.colorize("red", "[X-Ray] Failed to run - invalid node name."))
			return false
		end
		local lpos = minetest.localplayer:get_pos()
		local nodes_ = minetest.find_nodes_in_area(vector.subtract(lpos, r), vector.add(lpos, r), message, true)
		if not nodes_ then
			return false
		end
		for _, positions in pairs(nodes_) do
			for _, pos in pairs(positions) do
				if _ > 1000 then 
					minetest.display_chat_message(minetest.colorize("green", "[X-Ray] Marked first 1000 detected nodes.")) 
					return
				end
				local hud = minetest.localplayer:hud_add({
					hud_elem_type='waypoint',
					name=message,
					scale = {x = 10, y = 10},
					size = {x=10, y=10},
					world_pos = pos,
					number = "0xFF0000"
				})
				tagged_ores[dump(pos)] = {hud=hud, pos=pos}
			end
		end
		minetest.display_chat_message(minetest.colorize("green", "[X-Ray] Marked all detected nodes."))
	end
})

minetest.register_chatcommand('xray_clear', {
	params = "",
    description = "Clear all X-Ray markers.",
	func = function()
		for _, pos in pairs(tagged_ores) do
			minetest.localplayer:hud_remove(tagged_ores[_].hud)
			tagged_ores[_] = nil
		end
		minetest.display_chat_message(minetest.colorize("green", "[X-Ray] Cleared X-Ray markers."))
	end
})
