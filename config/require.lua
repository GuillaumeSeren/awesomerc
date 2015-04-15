-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    require.lua
-- Licence GPLv3
--
-- Load all dependency file.
-- ---------------------------------------------

-- System Libraries {{{1
gears           = require("gears")
awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
wibox           = require("wibox")
beautiful       = require("beautiful")
naughty         = require("naughty")
vicious         = require("vicious")

-- Bootstrap syslib {{{1
-- Load beautiful on selected theme
beautiful.init( ACTIVE_THEME .. "/theme.lua")
-- Themes define colours, icons, and wallpapers
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- User Libraries {{{1
-- Alt-tab like plugin {{{2
cyclefocus = require('bundle.awesome-cyclefocus')

-- Pomodoro {{{2
pomodoro = require("bundle.awesome-pomodoro")
-- init the pomodoro object with the current customizations
pomodoro.format = function (t) return t end
pomodoro.init()

-- hints {{{2
require("bundle.hints")

-- Revelation {{{2
-- Need beautiful
local revelation=require("bundle.awesome-revelation")
revelation.init()
