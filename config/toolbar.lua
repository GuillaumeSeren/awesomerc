-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Set the toolbar Wibox.
-- ---------------------------------------------

-- Colours {{{1
coldef      = "</span>"
colwhi      = "<span color='#b2b2b2'>"
colbwhi     = "<span color='#ffffff'>"
blue        = "<span color='#7493d2'>"
yellow      = "<span color='#e0da37'>"
purple      = "<span color='#e33a6e'>"
lightpurple = "<span color='#eca4c4'>"
azure       = "<span color='#80d9d8'>"
green       = "<span color='#87af5f'>"
lightgreen  = "<span color='#62b786'>"
red         = "<span color='#e54c62'>"
orange      = "<span color='#ff7100'>"
brown       = "<span color='#db842f'>"
fuchsia     = "<span color='#800080'>"
gold        = "<span color='#e7b400'>"

-- Textclock widget {{{1
clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.widget_clock)
mytextclock = awful.widget.textclock("<span color='#7788af'>%A %d %B</span> " .. blue .. "</span> <span color='#de5e1e'>%H:%M</span> ")

-- Calendar attached to the textclock {{{1
local os = os
local string = string
local table = table
local util = awful.util

char_width = nil
text_color = theme.fg_normal or "#FFFFFF"
today_color = theme.fg_focus or "#00FF00"
calendar_width = 21

local calendar = nil
local offset = 0

local data = nil

local function pop_spaces(s1, s2, maxsize)
    local sps = ""
    for i = 1, maxsize - string.len(s1) - string.len(s2) do
        sps = sps .. " "
    end
    return s1 .. sps .. s2
end

local function create_calendar()
    offset = offset or 0

    local now = os.date("*t")
    local cal_month = now.month + offset
    local cal_year = now.year
    if cal_month > 12 then
        cal_month = (cal_month % 12)
        cal_year = cal_year + 1
    elseif cal_month < 1 then
        cal_month = (cal_month + 12)
        cal_year = cal_year - 1
    end

    local last_day = os.date("%d", os.time({ day = 1, year = cal_year,
    month = cal_month + 1}) - 86400)
    local first_day = os.time({ day = 1, month = cal_month, year = cal_year})
    local first_day_in_week =
    os.date("%w", first_day)
    local result = "do lu ma me gi ve sa\n"
    for i = 1, first_day_in_week do
        result = result .. "   "
    end

    local this_month = false
    for day = 1, last_day do
        local last_in_week = (day + first_day_in_week) % 7 == 0
        local day_str = pop_spaces("", day, 2) .. (last_in_week and "" or " ")
        if cal_month == now.month and cal_year == now.year and day == now.day then
            this_month = true
            result = result ..
            string.format('<span weight="bold" foreground = "%s">%s</span>',
            today_color, day_str)
        else
            result = result .. day_str
        end
        if last_in_week and day ~= last_day then
            result = result .. "\n"
        end
    end

    local header
    if this_month then
        header = os.date("%a, %d %b %Y")
    else
        header = os.date("%B %Y", first_day)
    end
    return header, string.format('<span font="%s" foreground="%s">%s</span>',
    theme.font, text_color, result)
end

local function calculate_char_width()
    return beautiful.get_font_height(theme.font) * 0.555
end

function hide()
    if calendar ~= nil then
        naughty.destroy(calendar)
        calendar = nil
        offset = 0
    end
end

function show(inc_offset)
    inc_offset = inc_offset or 0

    local save_offset = offset
    hide()
    offset = save_offset + inc_offset

    local char_width = char_width or calculate_char_width()
    local header, cal_text = create_calendar()
    calendar = naughty.notify({ title = header,
    text = cal_text,
    timeout = 0, hover_timeout = 0.5,
})
end

mytextclock:connect_signal("mouse::enter", function() show(0) end)
mytextclock:connect_signal("mouse::leave", hide)
mytextclock:buttons(util.table.join( awful.button({ }, 1, function() show(-1) end),
awful.button({ }, 3, function() show(1) end)))

-- /home fs widget {{{1
fshicon = wibox.widget.imagebox()
fshicon:set_image(theme.confdir .. "/widgets/fs.png")
fshwidget = wibox.widget.textbox()
vicious.register(fshwidget, vicious.widgets.fs,
function (widget, args)
    if args["{/home used_p}"] >= 95 and args["{/home used_p}"] < 99 then
        return colwhi .. args["{/home used_p}"] .. "%" .. coldef
    elseif args["{/home used_p}"] >= 99 and args["{/home used_p}"] <= 100 then
        naughty.notify({ title = "Attenzione", text = "Partizione /home esaurita!\nFa' un po' di spazio.",
        timeout = 10,
        position = "top_right",
        fg = beautiful.fg_urgent,
        bg = beautiful.bg_urgent })
        return colwhi .. args["{/home used_p}"] .. "%" .. coldef
    else
        return azure .. args["{/home used_p}"] .. "%" .. coldef
    end
end, 620)

local infos = nil

function remove_info()
    if infos ~= nil then
        naughty.destroy(infos)
        infos = nil
    end
end

function add_info()
    remove_info()
    local capi = {
        mouse = mouse,
        screen = screen
    }
    local cal = awful.util.pread(scriptdir .. "dfs")
    cal = string.gsub(cal, "          ^%s*(.-)%s*$", "%1")
    infos = naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', "Terminus", cal),
          timeout = 0,
        position = "top_right",
        margin = 10,
        height = 170,
        width = 585,
        screen    = capi.mouse.screen
    })
end

fshwidget:connect_signal('mouse::enter', function () add_info() end)
fshwidget:connect_signal('mouse::leave', function () remove_info() end)

-- CPU widget {{{1
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, purple .. "$1%" .. coldef, 3)
cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(tasks, false) end)))

-- Temp widget {{{1
tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
tempicon:buttons(awful.util.table.join(
awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e sudo powertop ", false) end)
))
tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, "<span color=\"#f1af5f\">$1°C</span>", 9, "thermal_zone0")

-- Battery 1 widget {{{1
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)
batwidget = wibox.widget.textbox()
vicious.register( batwidget, vicious.widgets.bat, "$2", 10, "BAT0")
-- Battery 2 widget {{{1
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)
batsecondwidget = wibox.widget.textbox()
vicious.register( batsecondwidget, vicious.widgets.bat, "$2", 10, "BAT1")

-- Return Battery state
function batstate(sBatId)
    -- Load bat info
    local bat = io.open("/sys/class/power_supply/"..sBatId.."/status", "r")
    -- Test if null
    if (bat == nil) then
        return "Cable plugged"
    end
    -- Read bat status
    local batstate = bat:read("*line")
    bat:close()
    -- Detect chargin / discharging
    if (batstate == 'Discharging' or batstate == 'Charging') then
        return batstate
    else
        return "Fully charged"
    end
end

-- @TODO: export this process to a function
vicious.register(batwidget, vicious.widgets.bat, function (widget, args)
    -- plugged
    if (batstate("BAT0") == 'Cable plugged' or batstate("BAT0") == 'Unknown') then return "AC "
        -- critical
    elseif (args[2] <= 5 and batstate("BAT0") == 'Discharging') then
        naughty.notify({
            text = "Charge >= 5%, suspend now !",
            title = "Charge > 5%",
            position = "top_right",
            timeout = 1,
            fg="#000000",
            bg="#ffffff",
            screen = 1,
            ontop = true,
        })
        -- low
    elseif (args[2] <= 10 and batstate("BAT0") == 'Discharging') then
        naughty.notify({
            text = "Charge >= 10%, connect power !",
            title = "Charge >= 10%",
            position = "top_right",
            timeout = 1,
            fg="#ffffff",
            bg="#262729",
            screen = 1,
            ontop = true,
        })
        -- quarter
    elseif (args[2] == 25 and batstate("BAT0") == 'Discharging') then
        naughty.notify({
            text = "Charge = 25%",
            title = "Charge = 25%",
            position = "top_right",
            timeout = 1,
            fg="#000000",
            bg="#ffffff",
            screen = 1,
            ontop = true,
        })
        -- half
    elseif (args[2] == 50 and batstate("BAT0") == 'Discharging') then
        naughty.notify({
            text = "Charge = 50%",
            title = "Charge = 50%",
            position = "top_right",
            timeout = 1,
            fg="#ffffff",
            bg="#262729",
            screen = 1,
            ontop = true,
        })
        -- 75%
    elseif (args[2] == 75 and batstate("BAT0") == 'Discharging') then
        naughty.notify({
            text = "Charge = 75%",
            title = "Charge = 75%",
            position = "top_right",
            timeout = 1,
            fg="#000000",
            bg="#ffffff",
            screen = 1,
            ontop = true,
        })
    end
    return " " .. args[2] .. "%"
end, 1, 'BAT0')

-- batwidget = wibox.widget.textbox()
vicious.register(batsecondwidget, vicious.widgets.bat,
function (widget, args)
    -- plugged
    if (batstate("BAT1") == 'Cable plugged' or batstate("BAT1") == 'Unknown') then return "AC "
        -- critical
    elseif (args[2] <= 5 and batstate("BAT1") == 'Discharging') then
        naughty.notify({
            text = "Charge >= 5%, suspend now !",
            title = "Charge > 5%",
            position = "top_right",
            timeout = 1,
            fg="#000000",
            bg="#ffffff",
            screen = 1,
            ontop = true,
        })
        -- low
    elseif (args[2] <= 10 and batstate("BAT1") == 'Discharging') then
        naughty.notify({
            text = "Charge >= 10%, connect power !",
            title = "Charge >= 10%",
            position = "top_right",
            timeout = 1,
            fg="#ffffff",
            bg="#262729",
            screen = 1,
            ontop = true,
        })
        -- quarter
    elseif (args[2] == 25 and batstate("BAT1") == 'Discharging') then
        naughty.notify({
            text = "Charge = 25%",
            title = "Charge = 25%",
            position = "top_right",
            timeout = 1,
            fg="#000000",
            bg="#ffffff",
            screen = 1,
            ontop = true,
        })
        -- half
    elseif (args[2] == 50 and batstate("BAT1") == 'Discharging') then
        naughty.notify({
            text = "Charge = 50%",
            title = "Charge = 50%",
            position = "top_right",
            timeout = 1,
            fg="#ffffff",
            bg="#262729",
            screen = 1,
            ontop = true,
        })
        -- 75%
    elseif (args[2] == 75 and batstate("BAT1") == 'Discharging') then
        naughty.notify({
            text = "Charge = 75%",
            title = "Charge = 75%",
            position = "top_right",
            timeout = 1,
            fg="#000000",
            bg="#ffffff",
            screen = 1,
            ontop = true,
        })
    end
    return " " .. args[2] .. "% "
end, 1, 'BAT1')

-- Volume widget {{{1
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
volumewidget = wibox.widget.textbox()
function volumeInfo()
    volmin = 0
    volmax = 65536
    local f = io.popen("pacmd dump |grep set-sink-volume | grep analog")
    local g = io.popen("pacmd dump |grep set-sink-mute | grep analog")
    local v = f:read()
    local mute = g:read()
    if mute ~= nil and string.find(mute, "no") then
        volume = math.floor(tonumber(string.sub(v, string.find(v, 'x')-1)) * 100 / volmax).." %"
    else
        volume = "✕"
    end
    f:close()
    g:close()
    return volume
end
vicious.register(volumewidget, volumeInfo, "$1%", 1)

-- Net widget {{{1
-- @TODO: Add auto switch lan/wan
netActiveInfo = wibox.widget.textbox()
function netInterfaceActiveDecorated()
    -- @FIXME: Use netInterfaceActiveName input here
    local netActiveInterface = io.popen("ip -o link show | awk '{print $2,$9}' | grep 'UP' | cut -d':' -f1 | head -n 1")
    local interface = netActiveInterface:read()
    local output = green .. interface .. coldef
    netActiveInterface:close()
    return output
end
local netActiveInterfaceName = io.popen("ip -o link show | awk '{print $2,$9}' | grep 'UP' | cut -d':' -f1 | head -n 1"):read()

vicious.register(netActiveInfo, netInterfaceActiveDecorated, "$1%", 1)
netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netdownicon.align = "middle"
netdowninfo = wibox.widget.textbox()
vicious.register(netdowninfo, vicious.widgets.net, green .. "${"..netActiveInterfaceName .." down_kb}" .. coldef, 1)
-- vicious.register(netdowninfo, vicious.widgets.net, green .. "${".."eth0".." down_kb}" .. coldef, 1)
netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)
netupicon.align = "middle"
netupinfo = wibox.widget.textbox()
vicious.register(netupinfo, vicious.widgets.net, red .. "${" .. netActiveInterfaceName .." up_kb}" .. coldef, 1)

-- Memory widget {{{1
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, yellow .. "$2M" .. coldef, 1)

-- Pomodoro widget : {{{1
-- @TODO: Add clean pomodor implementation here
pomodorowidget = wibox.widget.textbox()

-- Spacer {{{1
spacer = wibox.widget.textbox(" ")

-- Layout {{{1
-- Create a wibox for each screen and add it {{{1
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
awful.button({ }, 1, awful.tag.viewonly),
awful.button({ modkey }, 1, awful.client.movetotag),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, awful.client.toggletag),
awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

-- TaskList {{{1
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        c.minimized = false
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end),
awful.button({ }, 3, function ()
    if instance then
        instance:hide()
        instance = nil
    else
        instance = awful.menu.clients({ width=250 })
    end
end),
awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do

    -- Create a promptbox for each screen {{{1
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen. {{{1
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget {{{1
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget {{{1
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the upper wibox {{{1
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 20 })

    -- Widgets that are aligned to the upper left {{{1
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the upper right {{{1
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(netActiveInfo)
    right_layout:add(netdownicon)
    right_layout:add(netdowninfo)
    right_layout:add(spacer)
    right_layout:add(netupicon)
    right_layout:add(netupinfo)
    right_layout:add(spacer)
    right_layout:add(pomodoro.widget)
    right_layout:add(spacer)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(spacer)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(spacer)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(spacer)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(spacer)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(spacer)
    right_layout:add(batsecondwidget)
    right_layout:add(clockicon)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle) {{{1
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

end
