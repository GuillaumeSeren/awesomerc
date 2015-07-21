-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Rules to configure clients.
-- Get the window name with xprop
-- Then define position, tag, etc
-- ---------------------------------------------

-- Rules
awful.rules.rules = {
    -- All clients will match this rule. {{{1
    -- You can obtain the WM_CLASS from the xprop shell.
    { rule = { }, properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = true,
        keys = clientkeys,
        -- add the following two:
        maximized_vertical   = false,
        maximized_horizontal = false,
        buttons = clientbuttons,
        size_hints_honor = false
        -- Désactive la possibilité de maximisation
        -- des fenêtres
        --maximized_vertical   = false,
        --maximized_horizontal = false,
        --buttons = clientbuttons
    }},
    -- All tags {{{1
    -- Allow to view video as fullscreen.
    { rule = { class = "MPlayer" }, properties = {
        floating = true } },
    -- Allow the flash (youtube) windows to fullscreen,
    { rule = { instance = "plugin-container" }, properties = {
        floating = true } },
    -- @FIXME: screenkey is not floating.
    { rule = { instance = "Screenkey" }, properties = {
        floating = true } },
    { rule = { class = "pinentry" }, properties = {
        floating = true } },
    -- Tag 1 «sys» {{{1
    -- Taq 2 «www» {{{1
    --Set Iceweasel on is tag : tag 2 of screen 1
    -- 21/07/2015: The class name is now Navigator Iceweasel
    { rule = { class = "Navigator" }, properties = {
        tag = tags[1][2],
        floating = true} },
    -- Tag 3 «mail» {{{1
    --Set Icedove on is tag : tag 2 of screen 1
    { rule = { class = "Icedove" }, properties = {
        tag = tags[1][3] } },
    -- MAIL
    { rule = { class = "URxvt", name = "Sup 0.21.0 :: Inbox" }, properties = {
        tag = tags[1][3] } },
    -- IRC
    { rule = { class = "URxvt", name = "WeeChat 1.0.1" }, properties = {
        tag = tags[1][5] } },
    { rule = { class = "URxvt", name = "WeeChat 1.1.1" }, properties = {
        tag = tags[1][5] } },
    -- Tag 4 «play» {{{1
    -- Tag 5 «irc» {{{1
    --Set Skype on is tag : tag 4 of screen 1
    { rule = { class = "Skype" }, properties = {
        tag = tags[1][5] } },
    --Set Teamspeack on is tag : tag 6 of screen 1
    { rule = { class = "Ts3client_linux_x86" }, properties = {
        tag = tags[1][5] } },
    -- Tag 6 «var» {{{1
    --Set PcmanFm on is tag : tag 6 of screen 1
    { rule = { class = "Pcmanfm" }, properties = {
        tag = tags[1][6] } },
    --Set Filezilla on is tag : tag 6 of screen 1
    { rule = { class = "Filezilla" }, properties = {
        tag = tags[1][6] } },
    -- Tag 7 «bin» {{{1
    --Set Cockatrice on the graph tag tag 7 of screen 1
    { rule = { class = "Cockatrice" }, properties = {
        floating = true,
        tag = tags[1][7] } },
    -- Tag 8 «img» {{{1
    --Set gimp on the graph tag tag 8 of screen 1
    { rule = { class = "Gimp" }, properties = {
        floating = true,
        tag = tags[1][8] } },
    --Set blender on the graph tag tag 8 of screen 1
    { rule = { class = "Blender" }, properties = {
        floating = true,
        tag = tags[1][8] } },
    --Set inkscape on the graph tag tag 8 of screen 1
    { rule = { class = "Inkscape" }, properties = {
        floating = true,
        tag = tags[1][8] } },
    -- Tag 9 «dev» {{{1
    --Set Chromium on is tag : tag 9 of screen 1
    { rule = { class = "Chromium" }, properties = {
        tag = tags[1][9] } }
}
