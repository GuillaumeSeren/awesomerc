-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Define layout.
-- ---------------------------------------------

-- Table of layouts to cover with awful.layout.inc {{{1
-- order matters.
layouts =
{
    awful.layout.suit.floating,             -- 1
    awful.layout.suit.tile,                 -- 2
    awful.layout.suit.tile.left,            -- 3
    awful.layout.suit.tile.bottom,          -- 4
    awful.layout.suit.tile.top,             -- 5
    -- Je préfère celui la, car il tile, de tous cotés
    awful.layout.suit.fair,                 -- 6
    awful.layout.suit.fair.horizontal,      -- 7
    awful.layout.suit.spiral,               -- 8
    awful.layout.suit.spiral.dwindle,       -- 9
    awful.layout.suit.max,                  -- 10
    awful.layout.suit.max.fullscreen,       -- 11
    awful.layout.suit.magnifier,            -- 12
    layouts.tilegaps                        -- 13
}
