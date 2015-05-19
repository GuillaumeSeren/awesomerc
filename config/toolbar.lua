-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    rc.lua
-- Licence GPLv3
--
-- Set the toolbar Wibox.
-- ---------------------------------------------

-- Colors {{{1
-- @TODO: Refactor color aside and text container other side.
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
mytextclock = awful.widget.textclock(blue .. "%A %d %B " .. coldef .. orange .. "%H:%M ".. coldef)

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
    local result = "di lu ma me je ve sa\n"
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
    calendar = naughty.notify({
        title = header,
        text = cal_text,
        timeout = 0,
        hover_timeout = 0.5})
end

mytextclock:connect_signal("mouse::enter", function() show(0) end)
mytextclock:connect_signal("mouse::leave", hide)
mytextclock:buttons(util.table.join(
    awful.button({ }, 1, function() show(-1) end),
    awful.button({ }, 3, function() show(1) end)
))

-- /home fs widget {{{1
-- fshicon {{{2
fshicon = wibox.widget.imagebox()
fshicon:set_image(beautiful.widget_fs)

-- fshwidget {{{2
fshwidget = wibox.widget.textbox()
vicious.register(fshwidget, vicious.widgets.fs,
    function (widget, args)
        -- OK zone
        if args["{/home used_p}"] >= 0 and args["{/home used_p}"] < 85 then
            return azure .. args["{/home used_p}"] .. "%" .. coldef
        -- Alert zone
        elseif args["{/home used_p}"] >= 75 and args["{/home used_p}"] <= 85 then
            return orange .. args["{/home used_p}"] .. "%" .. coldef
        -- Warning zone
        elseif args["{/home used_p}"] >= 85 and args["{/home used_p}"] <= 100 then
            naughty.notify({
                title = "Warning",
                text = "Partition /home is nearly full\nDo some cleaning.",
                timeout = 10,
                position = "top_right",
                fg = beautiful.fg_urgent,
                bg = beautiful.bg_urgent
            })
            return red .. args["{/home used_p}"] .. "%" .. coldef
        -- Default case
        else
            return azure .. args["{/home used_p}"] .. "%" .. coldef
        end
    end,
620)

-- @TODO: Clean / Refactor
local infos = nil

-- Function remove_info() {{{3
-- Clean notification popup
function remove_info()
    if infos ~= nil then
        naughty.destroy(infos)
        infos = nil
    end
end

-- Function add_info() {{{3
-- Populate and display a popup.
function add_info()
    remove_info()
    local capi = {
        mouse = mouse,
        screen = screen
    }
    local cal = awful.util.pread("df -h")
    -- @TODO: Add better layout
    infos = naughty.notify({
        text = string.format(
            '<span font_desc="%s">%s</span>',
            "Terminus",
            cal),
        timeout = 0,
        position = "top_right",
        margin = 10,
        height = 170,
        width = 585,
        screen = capi.mouse.screen
    })
end

-- Mouse event listener {{{3
fshwidget:connect_signal('mouse::enter', function () add_info() end)
fshwidget:connect_signal('mouse::leave', function () remove_info() end)

-- CPU profile widget {{{1
cpuWidgetGraph = awful.widget.graph()
cpuWidgetGraph:set_width(50):set_height(20)
cpuWidgetGraph:set_background_color("#000000")
cpuWidgetGraph:set_color({
    type = "linear",
    from = { 0, 0 },
    to = { 50, 0 },
    stops = {
        { 0, "#FF5656" },
        { 0.5, "#88A175" },
        { 1, "#AECF96" }
    }
})
vicious.cache(vicious.widgets.cpu)
vicious.register(cpuWidgetGraph, vicious.widgets.cpu, "$1", 3)

-- CPU widget {{{1
-- @FIXME: Change icon on cpu governator
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
-- @FIXME: Show a average of all cpu power
vicious.register(cpuwidget, vicious.widgets.cpu, purple .. "$1%" .. coldef, 3)
cpuicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(tasks, false) end)))

-- MAIL widget {{{1

-- Return mail icon & status
function mailStatus()
    local mailStatusCmd = io.popen("notmuch count INBOX")
    local mailStatusValue = mailStatusCmd:read()
    mailStatusCmd:close()
    local output = ""
    if tonumber(mailStatusValue) > 0 then
        output = "M "..mailStatusValue
    else
        output = "M 0"
    end
    return blue .. output .. coldef
end
mailWidget = wibox.widget.textbox()
vicious.register(mailWidget, mailStatus, "$1%", 1)

-- Brightness widget {{{1
function getScreenBrightness()
    local screenBrightnessCmd = io.popen("xbacklight | cut -d'.' -f1")
    local screenBrightnessValue = screenBrightnessCmd:read()
    screenBrightnessCmd:close()
    local output = ""
    if (tonumber(screenBrightnessValue) ~= nil and tonumber(screenBrightnessValue) > 0) then
        output = "S "..screenBrightnessValue.."%"
    else
        output = "S 0"
    end
    return orange .. output .. coldef
end

brightnessWidget = wibox.widget.textbox()
vicious.register(brightnessWidget, getScreenBrightness, "$1%", 1)

-- Redshift widget {{{1
function getRedshiftPeriod()
    local redshiftPeriodCmd = io.popen("redshift -p | grep -i 'Période' | cut -d ':' -f2")
    local redshiftPeriodValue = redshiftPeriodCmd:read()
    redshiftPeriodCmd:close()
    local output = ""
    if redshiftPeriodValue == " Jour" then
        output = "☼"
    else
        output = "☾"
    end
    return output
end

function getRedshiftStatus()
    local redshiftStatusCmd = io.popen("redshift -p | grep -i 'Température' | cut -d ':' -f2 | sed 's/\\ //g'")
    local redshiftStatusValue = redshiftStatusCmd:read()
    redshiftStatusCmd:close()
    local symbol = getRedshiftPeriod()
    local output = ""
        output = symbol .. " "..redshiftStatusValue
    return red .. output .. coldef
end

redshiftWidget = wibox.widget.textbox()
vicious.register(redshiftWidget, getRedshiftStatus, "$1%", 1)

-- Temp widget {{{1
tempicon = wibox.widget.imagebox()
tempicon:set_image(beautiful.widget_temp)
tempicon:buttons(awful.util.table.join(
awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e sudo powertop ", false) end)
))
tempwidget = wibox.widget.textbox()
vicious.register(tempwidget, vicious.widgets.thermal, "<span color=\"#f1af5f\">$1°C</span>", 9, "thermal_zone0")

-- Battery 1 widget {{{1

-- Return the array of system bats
function getSystemBats()
    local bats = {}
    local batsCmd = io.popen("ls /sys/class/power_supply | grep 'BAT'")
    for bat in batsCmd:lines() do
        table.insert(bats, bat)
    end
    batsCmd:close()
    return bats
end

-- Return bat number
function getBatNumber(bats)
    local count = 0
    for _ in pairs(bats) do count = count + 1 end
    return count
end

-- Return the number of power sources
function getPowerWallStatus()
    local pwsFlag = 0
    local pwsCmd = io.popen("cat /sys/class/power_supply/AC/online")
    local pws = pwsCmd:read()
    pwsCmd:close()
    if pwsCmd == nil then
        pws = ''
    else
        pwsFlag = pws
    end
    return pwsFlag
end

-- Return Battery state
function batState(sBatId)
    -- Load bat info
    local bat = io.open("/sys/class/power_supply/"..sBatId.."/status", "r")
    -- Read bat status
    local batstate = bat:read("*line")
    local output
    -- Detect chargin / discharging
    if (batstate == 'Discharging' or batstate == 'Charging') then
        output = batstate
    else
        output = "Charged"
    end
    bat:close()
    return output
end

-- Return a global state if multiple bat
function getGlobalBatState(bats)
    local status = ''
    for id, bat in ipairs(bats) do
        batStatus = batState(bat)
        if (batStatus == 'Unknown' or batStatus == 'Charging') then
            status = batStatus
        end
    end
    return status
end

-- Return the charge %
function getBatCharge(bats)
    local chargeRemaining = ''
    for id, bat in ipairs(bats) do
        -- Check if that bat is actually discharging
        local status = batState(bat)
        if (status == 'Discharging' or status == 'Charging' or status == 'Charged') then
            local chargeCmd = io.popen("upower -i /org/freedesktop/UPower/devices/battery_"..bat.." | grep 'percentage:'| sed 's/^\\s\\+percentage:\\s\\+//g'")
            charge = chargeCmd:read()
            chargeCmd:close()
            chargeRemaining = charge
        end
    end
    if chargeRemaining == nil then
        chargeRemaining = ''
    end
    return chargeRemaining
end

-- Return the time lasting for a given bat
function getBatTimer(bats)
    local timeRemaining = ''
    for id, bat in ipairs(bats) do
        -- Check if that bat is actually discharging
        local status = batState(bat)
        if status == 'Discharging' then
            local chargeCmd = io.popen("upower -i /org/freedesktop/UPower/devices/battery_"..bat.." | grep 'time to empty'| sed 's/^\\s\\+time to empty:\\s\\+//g' | sed 's/hours/h/g'")
            charge = chargeCmd:read()
            chargeCmd:close()
            timeRemaining = charge
        end
    end
    if timeRemaining == nil then
        timeRemaining = ''
    end
    return timeRemaining
end

-- Return the time needed to be fully charged
function getBatTimerUntilFull(bats)
    local timeRemainingFull = ''
    for id, bat in ipairs(bats) do
        -- Check if that bat is actually discharging
        local status = batState(bat)
        if status == 'Charging' then
            local chargeCmd = io.popen("upower -i /org/freedesktop/UPower/devices/battery_"..bat.." | grep 'time to full:'| sed 's/^\\s\\+time to full:\\s\\+//g' | sed 's/hours/h/g' | sed 's/minutes/m/g'")
            charge = chargeCmd:read()
            chargeCmd:close()
            timeRemainingFull = charge
        end
    end
    if timeRemainingFull == nil then
        timeRemainingFull = ''
    end
    return timeRemainingFull
end

function getEnergyRate(bats)
    local energyRate = ''
    for id, bat in ipairs(bats) do
        -- Check if that bat is actually discharging
        local status = batState(bat)
        if status == 'Discharging' then
            local energyRateCmd = io.popen("upower -i /org/freedesktop/UPower/devices/battery_"..bat.." | grep 'energy-rate:'| sed 's/^\\s\\+energy-rate:\\s\\+//g' | sed 's/\\(.*\\),.*\\sW/\\1 W/g'")
            energyRate = energyRateCmd:read()
            energyRateCmd:close()
            output = energyRate
        end
    end
    if output == nil then
        output = ''
    end
    return output
end

-- Return the batWidget
function getBatWidget()
    local bats = {}
    -- User can define a target bat,
    local userBat= nil
    -- but usually it will be empty (auto-detect)
    if userBat == nil then
        bats = getSystemBats()
    else
        -- Add this to array bats
        table.insert(bats, userBat)
    end
    -- Count bat
    local batNumber = getBatNumber(bats)
    -- Are we plugged in on the wall ?
    local pwsStatus = tonumber(getPowerWallStatus())
    -- Output setup
    local output
    -- Check if everything is charged / charging / discharging
    local globalBatState = getGlobalBatState(bats)
    -- 3 modes: DC / Charging / Discharging
    -- NO POWER SOURCE
    if (pwsStatus == 0) then
        local remainingTime = getBatTimer(bats)
        local remainingCharge = getBatCharge(bats)
        local energyRate = getEnergyRate(bats)
        output= "- "..energyRate.." "..remainingTime
    -- CHARGING
    elseif (pwsStatus > 0 and globalBatState == 'Charging') then
        local remainingCharge = getBatCharge(bats)
        local remainingTimeFull = getBatTimerUntilFull(bats)
        output = "+ "..remainingCharge.." "..remainingTimeFull
    -- Charged
    elseif (pwsStatus > 0 and globalBatState == 'Charged') then
        local remainingCharge = getBatCharge(bats)
        output = "DC "..remainingCharge
    -- UNKNOWN
    else
        output = "DC"
    end
    -- output =
    return output
end

-- Bat 0
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batt)
batwidget = wibox.widget.textbox()
vicious.register( batwidget, getBatWidget, "$1", 1)

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

-- Return the network active interface.
function netInterfaceActive()
    local netActiveInterface = io.popen("ip -o link show | awk '{print $2,$9}' | grep 'UP' | cut -d':' -f1 | head -n 1")
    local interface = netActiveInterface:read()
    local output = interface
    netActiveInterface:close()
    return output
end

-- Return the decorated network name.
function netInterfaceActiveDecorated()
    local interface = netInterfaceActive()
    -- If no interface is UP now will be nil
    if (interface == "" or interface == nil) then
        interface = "???"
    end
    local output = green .. interface .. coldef
    return output
end

-- Return the data netWidget UP
function netInterfaceActiveDecoratedUp(widget, args)
    local interface = netInterfaceActive()
    -- Default interface
    if (interface == "" or interface == nil) then
        interface = "wlan0"
    end
    local output = red .. "${".. interface .." up_kb}" .. coldef
    return output
end

-- Return the data netWidget DOWN
-- @TODO: Would be qreat to hide
function netInterfaceActiveDecoratedDown(widget, args)
    local interface = netInterfaceActive()
    -- Default interface
    if (interface == "" or interface == nil) then
        interface = "wlan0"
    end
    local output = green .. "${".. interface .." down_kb}" .. coldef
    return output
end

netActiveInfo = wibox.widget.textbox()
vicious.register(netActiveInfo, netInterfaceActiveDecorated, "$1%", 1)

-- @FIXME: Auto refresh / hide this widget on update
-- @FIXME: still not perfect, it didn't auto reload.
netdownicon = wibox.widget.imagebox()
netdownicon:set_image(beautiful.widget_netdown)
netdownicon.align = "middle"
netdowninfo = wibox.widget.textbox()
vicious.register(netdowninfo, vicious.widgets.net, netInterfaceActiveDecoratedDown(netdowninfo, args), 1)

netupicon = wibox.widget.imagebox()
netupicon:set_image(beautiful.widget_netup)
netupicon.align = "middle"
netupinfo = wibox.widget.textbox()
vicious.register(netupinfo, vicious.widgets.net, netInterfaceActiveDecoratedUp(netupinfo, args), 1)

-- RfKill widget {{{1
function getRfkillWidget(widget, args)
    -- Here the rfkillWidget is not reachable
    local rfkillWidget = require("bundle.awesome-rfkill")
    local widget = rfkillWidget.getRfkillBlockedState()
    return red .. widget ..coldef
end

rfkillWidget = wibox.widget.textbox()
vicious.register(rfkillWidget, getRfkillWidget, "$1%", 1)

-- Mouse event listener
rfkillWidget:connect_signal('mouse::enter', function () rfkillTooltipAdd() end)
rfkillWidget:connect_signal('mouse::leave', function () rfkillTooltipRemove() end)

-- Memory widget {{{1
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, yellow .. "$2M" .. coldef, 1)

-- Pomodoro widget : {{{1

pomodoroWorkNumber = 0
pomodoroPauseNumber = 0

-- Store actual status
pomodoroStatus = "work"

function getPomodoroIcon()
    if pomodoroStatus == "work" then
        icon = " ✎ "
    else
        icon = " ☕ "
    end
    return orange .. icon .. pomodoroWorkNumber .."/" .. coldef
end

pomodoroicon = wibox.widget.textbox()
vicious.register(pomodoroicon, getPomodoroIcon, "$1%", 1)

pomodorocount = wibox.widget.textbox()
vicious.register(netActiveInfo, netInterfaceActiveDecorated, "$1%", 1)

-- @TODO: Add clean pomodoro implementation here
-- pomodorowidget = wibox.widget.textbox()
-- init the pomodoro object with the current customizations
pomodoro.format = function (t) return "" .. orange .. t .. coldef end
pomodorowidget = pomodoro.init()
-- pomodoro.widget
-- Count every Pomodoro
pomodoro.on_work_pomodoro_finish_callbacks = {
    function()
        -- Increment done pomodoro:
        pomodoroWorkNumber = pomodoroWorkNumber + 1
        pomodoroStatus = "pause"
    end
}

pomodoro.on_pause_pomodoro_finish_callbacks = {
    function()
        pomodoroPauseNumber = pomodoroPauseNumber + 1
        pomodoroStatus = "work"
    end
}


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
    awful.button({ }        , 1, awful.tag.viewonly),
    awful.button({ modkey } , 1, awful.client.movetotag),
    awful.button({ }        , 3, awful.tag.viewtoggle),
    awful.button({ modkey } , 3, awful.client.toggletag),
    awful.button({ }        , 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }        , 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
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
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

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
    right_layout:add(spacer)
    right_layout:add(rfkillWidget)
    right_layout:add(spacer)
    right_layout:add(netActiveInfo)
    right_layout:add(netdownicon)
    right_layout:add(netdowninfo)
    right_layout:add(spacer)
    right_layout:add(netupicon)
    right_layout:add(netupinfo)
    right_layout:add(spacer)
    right_layout:add(pomodoroicon)
    right_layout:add(pomodoro.widget)
    right_layout:add(spacer)
    right_layout:add(mailWidget)
    right_layout:add(spacer)
    right_layout:add(brightnessWidget)
    right_layout:add(spacer)
    right_layout:add(redshiftWidget)
    right_layout:add(spacer)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(spacer)
    right_layout:add(cpuWidgetGraph)
    right_layout:add(spacer)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(spacer)
    right_layout:add(fshicon)
    right_layout:add(fshwidget)
    right_layout:add(spacer)
    right_layout:add(tempicon)
    right_layout:add(tempwidget)
    right_layout:add(spacer)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(spacer)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    -- right_layout:add(spacer)
    -- right_layout:add(batsecondwidget)
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
