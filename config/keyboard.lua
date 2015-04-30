-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    keyboard.lua
-- Licence GPLv3
--
-- Define shortcuts.
-- ---------------------------------------------

-- Key bindings {{{1
globalkeys = awful.util.table.join(
    -- ScreenKey @FIXME {{{2
    -- idea from :
    -- https://github.com/AndrewRadev/awesome-config/blob/master/rc.lua
    awful.key({ altkey }, "Escape", function ()
            --awful.util.spawn("pkill screenkey",false),
            awful.util.spawn("screenkey",false)
    end),
    -- Capture a screenshot @FIXME {{{2
    -- @FIXME: Find a tool
    awful.key({ altkey }, "p", function()
        awful.util.spawn("screenshot",false)
    end),
    -- Pomodoro Start ! {{{2
    awful.key({ modkey, "Shift" }, "p", function()
        pomodoro:start()
    end),
    -- Screen Brightness down {{{2
    awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.util.spawn("xbacklight -dec 10")
    end),
    -- Screen Brightness up {{{2
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.util.spawn("xbacklight -inc 10")
    end),
    -- Sound ajustement down {{{2
    awful.key({ }, "XF86AudioLowerVolume", function ()
        awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%")
    end),
    -- Sound ajustement up {{{2
    awful.key({ }, "XF86AudioRaiseVolume", function ()
        --awful.util.spawn("amixer -q sset Master 5%+ unmute") end),
        awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%")
    end),
    -- Sound mute/unmute {{{2
    awful.key({ }, "XF86AudioMute", function ()
        awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    end),
    -- Sound Mic Mute {{{2
    awful.key({ }, "XF86AudioMicMute", function ()
        awful.util.spawn("pactl set-source-mute 2 toggle")
    end),
    -- Revelation, exposé like (NOT WORKING) {{{2
    -- awful.key({ modkey,           }, "j", function ()
    --     awful.client.focus.byidx( 1)
    --     if client.focus then client.focus:raise() end
    -- end),
    -- awful.key({ modkey }, "j", function () hints.focus() end),
    awful.key({ modkey,           }, "j",
    function ()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
    -- awful.key({ }, "XF86LaunchA", revelation),
        -- awful.client.focus.byidx( 1)
        -- if client.focus then client.focus:raise() end
        -- awful.util.spawn("pactl set-source-mute 2 toggle")
    -- end),
    -- Show Menu {{{2
    awful.key({ modkey,           }, "w", function ()
        mymainmenu:show({keygrabber=true}) end),
    -- Show/Hide Wibox {{{2
    awful.key({ modkey }, "b", function ()
    mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),
    -- Switch tag next/previous {{{2
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    -- Return last tag (history) {{{2
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    -- Standard program {{{2
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    -- Windows Switcher (alt-tab like) {{{2
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    -- Windows Switcher {{{2
    awful.key({ modkey,           }, "k", function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),

    -- Switch client BROKEN {{{2
    awful.key({ modkey,           }, "j", function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Move clients {{{2
    awful.key({ altkey }, "Next",  function () awful.client.moveresize( 1,  1, -2, -2) end),
    awful.key({ altkey }, "Prior", function () awful.client.moveresize(-1, -1,  2,  2) end),
    awful.key({ altkey }, "Down",  function () awful.client.moveresize(  0,  1,   0,   0) end),
    awful.key({ altkey }, "Up",    function () awful.client.moveresize(  0, -1,   0,   0) end),

    -- Layout manipulation {{{2
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Resize windows
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)          end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)          end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Lock session {{{2
    awful.key({}, "XF86ScreenSaver", function ()
            awful.util.spawn("i3lock -e -c 000000")
        end),
    -- Dropdown terminal {{{2
    awful.key({ modkey,	          }, "z",     function () scratch.drop(terminal) end),
    -- Music control {{{2
    awful.key({ altkey, "Control" }, "Up", function ()
        awful.util.spawn( "mpc toggle", false )
        vicious.force({ mpdwidget } )
    end),
    awful.key({ altkey, "Control" }, "Down", function ()
        awful.util.spawn( "mpc stop", false )
        vicious.force({ mpdwidget } )
    end ),
    awful.key({ altkey, "Control" }, "Left", function ()
        awful.util.spawn( "mpc prev", false )
        vicious.force({ mpdwidget } )
    end ),
    awful.key({ altkey, "Control" }, "Right", function ()
        awful.util.spawn( "mpc next", false )
        vicious.force({ mpdwidget } )
    end ),
    -- Copy to clipboard {{{2
    awful.key({ modkey,        }, "c", function ()
        os.execute("xsel -p -o | xsel -i -b")
    end),
    -- Prompt {{{2
    awful.key({ modkey }, "r", function ()
        mypromptbox[mouse.screen]:run() end),
    -- Run LUA code {{{2
    awful.key({ modkey }, "x", function ()
        awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end)

)

-- layout modification {{{2
clientkeys = awful.util.table.join(
    -- Fullscreen {{{2
    awful.key({ modkey }, "f", function (c)
        c.fullscreen = not c.fullscreen
    end),
    -- Kill a windows {{{2
    awful.key({ modkey, "Shift" }, "c", function (c)
        c:kill()
    end),
    -- Floating the windows {{{2
    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle
    ),
    -- Move client to last client position {{{2
    awful.key({ modkey, "Control" }, "Return", function (c)
        c:swap(awful.client.getmaster())
    end),
    -- Move a client to a screen. {{{2
    -- Default is next screen, cycling.
    awful.key({ modkey,           }, "o",
        awful.client.movetoscreen
    ),
    -- Ontop switcher {{{2
    awful.key({ modkey,           }, "t", function (c)
        c.ontop = not c.ontop
    end),
    -- Minimize the window {{{2
    awful.key({ modkey,           }, "n",
    function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end),
    -- invert layout of client {{{2
    awful.key({ modkey,           }, "m",
    function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end)
)
-- Compute the maximum number of digit we need, limited to 9 {{{2
keynumber = 0
for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags. {{{2
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
    function ()
        screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewonly(tags[screen][i])
        end
    end),
    awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
        screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewtoggle(tags[screen][i])
        end
    end),
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
        if client.focus and tags[client.focus.screen][i] then
            awful.client.movetotag(tags[client.focus.screen][i])
        end
    end),
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
        if client.focus and tags[client.focus.screen][i] then
            awful.client.toggletag(tags[client.focus.screen][i])
        end
    end))
end

clientbuttons = awful.util.table.join(
-- Mouse Select focus {{{2
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
-- Mouse move windows {{{2
awful.button({ modkey }, 1, awful.mouse.client.move),
-- Mouse resize windows {{{2
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys {{{1
root.keys(globalkeys)
