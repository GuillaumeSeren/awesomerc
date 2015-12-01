-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Global Awesome WM config file.
-- ---------------------------------------------

-- Task-List {{{1
-- @TODO: Add lazy refresh on modules ideally callbacks events.
-- @TODO: Do not use SUDO because it spam the journal (rfkill).
-- @TODO: Change template use a more simple (custom) and on-the-fly tweakable.
-- @TODO: Try powerline display for the bar.
-- @TODO: Export basic lua to a lib
-- @TODO: Toolbar, Add keyboard layout.
-- @TODO: Add better overall design maybe try powerline.
-- @TODO: Auto update netWidget, try to detect the active interface.
-- @TODO: Add screenWidget to display light / size and other infos.
-- @TODO: Add option to cpuWidget to change profile, notification.
-- @TODO: Add mpdWidget.
-- @TODO: Add better notification system.
-- @TODO: Change date format.
-- @TODO: Change wallpaper on time interval + popup.
-- @TODO: Display all over information widget (net, cpu, bat).
-- @TODO: Change cpuWidget icon on status change.
-- @TODO: Add cheat-sheet of shortcut.


-- Config folder {{{1
-- @TODO: Home can be used to detect the computer
HOME_FOLDER    = os.getenv("HOME")
AWESOME_FOLDER = HOME_FOLDER .. "/.config/awesome"
CONFIG_FOLDER  = AWESOME_FOLDER .. "/config/"

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
