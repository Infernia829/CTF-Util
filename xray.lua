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
local found_chests = {}
local item_string = "nothing"

local function scan(r, node_string)
	if not minetest.get_node_def(node_string) then
		minetest.display_chat_message(minetest.colorize("red", "[X-Ray] Failed to run - invalid node name."))
		return false
	end
	local lpos = minetest.localplayer:get_pos()
	local nodes_ = minetest.find_nodes_in_area(vector.subtract(lpos, r), vector.add(lpos, r), node_string, true)
	if not nodes_ then
		return false
	end
	return nodes_
end

local function map(value, from_min, from_max, to_min, to_max)
    -- Ensure that value is within the source range
    value = math.min(math.max(value, from_min), from_max)

    -- Calculate the mapping
    local from_range = from_max - from_min
    local to_range = to_max - to_min
    local scaled_value = (value - from_min) / from_range

    return to_min + scaled_value * to_range
end

local function HueToHex(hue)
    local r, g, b = hsl_to_rgb(hue, 1, 0.5)
    local hexColor = string.format("0x%02X%02X%02X", r, g, b)
    return hexColor
end

function hsl_to_rgb(h, s, l)
    h = h % 1  -- Ensure h is in the range [0, 1]
    s = math.min(1, math.max(0, s))  -- Ensure s is in the range [0, 1]
    l = math.min(1, math.max(0, l))  -- Ensure l is in the range [0, 1]

    local function hue2rgb(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1/6 then return p + (q - p) * 6 * t end
        if t < 1/2 then return q end
        if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
        return p
    end

    local r, g, b

    if s == 0 then
        r, g, b = l, l, l  -- Achromatic (gray)
    else
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end

    -- Scale to the range [0, 255] and round to the nearest integer
    r = math.floor(r * 255 + 0.5)
    g = math.floor(g * 255 + 0.5)
    b = math.floor(b * 255 + 0.5)

    return r, g, b
end


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
		item_string = "nothing"
		minetest.display_chat_message(minetest.colorize("green", "[X-Ray] Cleared all X-Ray markers."))
	end
})

minetest.register_chatcommand('xray_chest_scan', {
	params = "<item keyword>",
    description = "Find a specific item within chests by a keyword.",
	func = function(temp_item_string)
		item_string = temp_item_string
		etime = 1
		minetest.display_chat_message(minetest.colorize("green", "[X-Ray] Scanning for "..temp_item_string.."..."))
	end
})

local etime = 0
minetest.register_globalstep(function(dtime)
	etime = etime + dtime
	if etime > 1 then
		etime = 0
	else
		return
	end
	for _, pos in pairs(found_chests) do
		minetest.localplayer:hud_remove(found_chests[_].hud)
		found_chests[_] = nil
	end
	if item_string == "nothing" then return end
	nodes_ = scan(75,'ctf_map:chest')
	for _, positions in pairs(nodes_) do
		for _, pos in pairs(positions) do
			if _ > 1000 then 
				return false
			end
			local meta = minetest.get_meta(pos)
			local inv = meta:to_table().inventory.main
			local count = 0
			local name = ""
            for _, stack in pairs(inv) do
				if string.find(stack:get_name():lower(), item_string:lower()) then
					name = stack:get_description()
					count = count + stack:get_count()
				end
            end
			if count > 0 then
				local hud = minetest.localplayer:hud_add({
					hud_elem_type='waypoint',
					name=name .. " " .. count,
					scale = {x = 10, y = 10},
					size = {x=10, y=10},
					world_pos = pos,
					number = HueToHex(map(count, 1, 99, 0, 1))
				})
				found_chests[dump(pos)] = {hud=hud, pos=pos}
			end
		end
	end
	nodes_ = scan(75,'ctf_map:chest_opened')
	for _, positions in pairs(nodes_) do
		for _, pos in pairs(positions) do
			if _ > 1000 then 
				return false
			end
			local meta = minetest.get_meta(pos)
			local inv = meta:to_table().inventory.main
			local count = 0
			local name = ""
            for _, stack in pairs(inv) do
				if string.find(stack:get_name():lower(), item_string:lower()) then
					name = stack:get_description()
					count = count + stack:get_count()
				end
       		end
			if count > 0 then
				local hud = minetest.localplayer:hud_add({
					hud_elem_type='waypoint',
					name=name .. " " .. count,
					scale = {x = 10, y = 10},
					size = {x=10, y=10},
					world_pos = pos,
					number = HueToHex(map(count, 1, 99, 0, 1))
				})
				found_chests[dump(pos)] = {hud=hud, pos=pos}
			end
		end
	end
end)