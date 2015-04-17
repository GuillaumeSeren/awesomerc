-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Define tags.
-- ---------------------------------------------

-- Define a tag table which will hold all screen tags.
tags = {
    names  = { "sys",   "www", "mail",
               "media", "irc", "var",
               "bin",   "img", "dev" },
    layout = { layouts[6], layouts[6], layouts[6],
               layouts[6], layouts[6], layouts[6],
               layouts[6], layouts[6], layouts[6]
}}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
