# CTF-Util
 Minetest CSM that contains a few cool utilities for Capture The Flag by Rubenwardy and LandarVargan


 1. You can block players using .block and .unblock

 2. You can see other people using the utility mod. This can be disabled in settings by changing the "Show custom text next to other CTF Util users" setting to false

 3. There is a built in donate cooldown timer that displays on the right of your screen. Upon donating it counts down to when you can next donate.
  1. You can toggle this with ".toggle_donate_counter"

 4. Automatic welcoming, add a player to the list using ".welcome", and when they join you will say "wb, <name>".
  1. You can customize the message, for example, ".set_welcome_message <name> <message>" will change the welcome message.
  2. To remove a player from the list do ".dont_welcome <name>".
  3. To list all players on your welcome list, do ".list_welcomes"

 5. There is now a built in capture timer, what this does is when somebody captures, it displays how long they have to capture the flag.
  1. You can toggle this with ".toggle_capture_counter"

 6. It now comes with hit particles, do ".toggle_particles" to enable them.

 7. Various other featurs, use ".help" to see them all.

 8. Massive shoutout to @peace12345/Brain_Juice for supplying the chat welcome and capture counter scripts. 

 Please send me ideas for changes/features on discord: FlamingRCCars#5466
 Or Brain_Juice: @peace12345

Version for MineTest 5.6.0 and below: https://github.com/FlamingRCCars/CTF-Util-Legacy-Support
