-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
   hl.exec_cmd("awww-daemon")
   hl.exec_cmd("wl-paste --type text --watch cliphist store")
   hl.exec_cmd("wl-paste --type image --watch cliphist store")
   hl.exec_cmd("hypridle")
   hl.exec_cmd("vicinae server")
   hl.exec_cmd("quickshell")
 end)
