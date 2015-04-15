-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Define menu.
-- ---------------------------------------------

-- accessoires {{{1
myaccessories = {
    { "archives", "xarchiver" },
    { "file manager", "pcmanfm" },
    { "editor", gui_editor },
}
-- internet {{{1
myinternet = {
    { "browser", browser },
    { "irc client" , chat },
    { "torrent" , terminal .. " -e transmission-cli" }
}
-- games {{{1
mygames = {
    { "NES", "fceux" },
    { "Super NES", "zsnes" },
}
-- graphics {{{1
mygraphics = {
    { "gimp" , "gimp" },
    { "inkscape", "inkscape" },
    { "dia", "dia" },
    { "image viewer" , "feh" }
}
-- office {{{1
myoffice = {
    { "writer" , "libreoffice" },
    { "impress" , "loimpress" }
}
-- system {{{1
mysystem = {
    { "powertop" , terminal .. " -e sudo powertop " },
    { "task manager" , tasks }
}
-- menu {{{1
mymainmenu = awful.menu({ items = {
    { "accessories" , myaccessories },
    { "graphics" , mygraphics },
    { "internet" , myinternet },
    { "games" , mygames },
    { "office" , myoffice },
    { "system" , mysystem }}
})
-- menu icon
mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu })
