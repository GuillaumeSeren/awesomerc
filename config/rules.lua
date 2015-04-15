-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Rules to configure clients.
-- ---------------------------------------------

-- Rules
awful.rules.rules = {
    -- All clients will match this rule.
    -- You can obtain the WM_CLASS from the xprop shell.
    { rule = { },
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = true,
        keys = clientkeys,
        buttons = clientbuttons,
        size_hints_honor = false
        -- Desactive la possibilité de maximisation
        -- des fenetres
        --maximized_vertical   = false,
        --maximized_horizontal = false,
        --buttons = clientbuttons
    }},
    { rule = { class = "MPlayer" },
    properties = { floating = true } },
    --Permet d'activer le floating sur la fenetre flash,
    --pour lire les vidéo youtube en plein ecran.
    --On peut recuperer les informations necessaire avec xprop
    { rule = { instance = "plugin-container" },
    properties = { floating = true } },
    { rule = { instance = "screenkey" },
    properties = { floating = true } },
    { rule = { class = "pinentry" },
    properties = { floating = true } },
    --Set Iceweasel on is tag : tag 2 of screen 1
    { rule = { class = "Iceweasel" },
    properties = { tag = tags[1][2] } },
    --Set Icedove on is tag : tag 2 of screen 1
    { rule = { class = "Icedove" },
    properties = { tag = tags[1][3] } },
    --Set Iceowl on is tag : tag 3 of screen 1
    --{ rule = { class = "Calendar" },
    --properties = { tag = tags[1][3] } },
    --Set Skype on is tag : tag 4 of screen 1
    { rule = { class = "Skype" },
    properties = { tag = tags[1][4] } },
    --Set PcmanFm on is tag : tag 6 of screen 1
    { rule = { class = "Pcmanfm" },
    properties = { tag = tags[1][6] } },
    --Set Filezilla on is tag : tag 6 of screen 1
    { rule = { class = "Filezilla" },
    properties = { tag = tags[1][6] } },
    --Set Teamspeack on is tag : tag 6 of screen 1
    { rule = { class = "Ts3client_linux_x86" },
    properties = { tag = tags[1][4] } },
    --Set Chromium on is tag : tag 9 of screen 1
    { rule = { class = "Chromium" },
    properties = { tag = tags[1][9] } },
    --Set gimp on the graph tag tag 8 of screen 1
    { rule = { class = "Gimp" },
    properties = { floating = true,
    tag = tags[1][8] } },
    --Set inkscape on the graph tag tag 8 of screen 1
    { rule = { class = "Inkscape" },
    properties = { floating = true,
    tag = tags[1][8] } }
}
