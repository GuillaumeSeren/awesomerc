-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    library.lua
-- Licence GPLv3
--
-- Local library file.
-- ---------------------------------------------

-- Display simple notification
function alert(messageTitle, messageContent)
    awful.util.spawn("notify-send -i '"..messageTitle.."' '"..messageContent.."' ")
end
