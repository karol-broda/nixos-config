sbar = require("sketchybar")

sbar.begin_config()
require("bar")
require("default")
require("items")
sbar.end_config()

-- without this, no callback functions execute in the lua module
sbar.event_loop()
