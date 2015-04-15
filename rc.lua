-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Global Awesome WM config file.
-- ---------------------------------------------

-- Config folder {{{1
-- @TODO: Home can be used to detect the computer
home = os.getenv("HOME")
confdir = home .. "/.config/awesome"
CONFIG_FOLDER = confdir .. "/config/"

-- Config Files {{{1
-- For a better readability and maintenance every configuration parts are in
-- your Awesome's folder in a config 'folder'
dofile( CONFIG_FOLDER .. "base.lua"      ) --  General base setup.
dofile( CONFIG_FOLDER .. "require.lua"   ) --  Required libraries.
dofile( CONFIG_FOLDER .. "library.lua"   ) --  Local libraries.
dofile( CONFIG_FOLDER .. "autostart.lua" ) --  Things to do at startup
dofile( CONFIG_FOLDER .. "errors.lua"    ) --  Handle errors
dofile( CONFIG_FOLDER .. "layouts.lua"   ) --  Load available Layouts
dofile( CONFIG_FOLDER .. "tags.lua"      ) --  Load available Tags
dofile( CONFIG_FOLDER .. "menu.lua"      ) --  Load menu
dofile( CONFIG_FOLDER .. "toolbar.lua"   ) --  Load top toolbar
dofile( CONFIG_FOLDER .. "mouse.lua"     ) --  Load mouse bindings
dofile( CONFIG_FOLDER .. "keyboard.lua"  ) --  Load keyboard bindings
dofile( CONFIG_FOLDER .. "rules.lua"     ) --  Load rules
dofile( CONFIG_FOLDER .. "signals.lua"   ) --  Load signals
