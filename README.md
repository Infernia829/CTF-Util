# CTF-Util
##### _Minetest CSM that contains a few cool utilities for Capture The Flag by Rubenwardy_


 - You can block players using .block and .unblock

 - You can use .xray_find <node name> to find a specific node in your surroundings, and .xray_clear to hide the display.

 - You can see other people using the utility mod. This can be disabled in settings by changing the "Show custom text next to other CTF Util users" setting to false

 - There is a built in donate cooldown timer that displays on the right of your screen. Upon donating it counts down to when you can next donate.
   - You can toggle this with ".toggle_donate_counter"

 - Automatic welcoming, add a player to the list using ".welcome", and when they join you will say "wb, <name>".
   - You can customize the message, for example, ".set_welcome_message <name> <message>" will change the welcome message.
   - To remove a player from the list do ".dont_welcome <name>".
   - To list all players on your welcome list, do ".list_welcomes"

 - There is now a built in capture timer, what this does is when somebody captures, it displays how long they have to capture the flag.
   - You can toggle this with ".toggle_capture_counter"

 - It now comes with hit particles, do ".toggle_particles" to enable them.

 - Various other featurs, use ".help" to see them all.

 - Massive shoutout to @peace12345/Brain_Juice for supplying the chat welcome and capture counter scripts. 

 **Please send me ideas for changes/features on discord: *@.flamingrccars***
 **Or Brain_Juice: *@peace12345***

Version for MineTest 5.6.0 and below: https://github.com/FlamingRCCars/CTF-Util-Legacy-Support ( outdated )
