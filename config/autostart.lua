-- ---------------------------------------------
-- Awesome WM configuration
-- @author Guillaume Seren
-- source  https://github.com/GuillaumeSeren/awesomerc
-- file    autostart.lua
-- Licence GPLv3
--
-- AutoStart config file.
-- ---------------------------------------------
-- Autostart lib {{{1
require("lfs")
-- function processwalker() {{{2
-- Run program once
local function processwalker()
    local function yieldprocess()
        for dir in lfs.dir("/proc") do
            -- All directories in /proc containing a number, represent a process
            if tonumber(dir) ~= nil then
                local f, err = io.open("/proc/"..dir.."/cmdline")
                if f then
                    local cmdline = f:read("*all")
                    f:close()
                    if cmdline ~= "" then
                        coroutine.yield(cmdline)
                    end
                end
            end
        end
    end
    return coroutine.wrap(yieldprocess)
end

-- function run-once() {{{2
local function run_once(process, cmd)
   assert(type(process) == "string")
   local regex_killer = {
      ["+"]  = "%+", ["-"] = "%-",
      ["*"]  = "%*", ["?"]  = "%?" }

   for p in processwalker() do
      if p:find(process:gsub("[-+?*]", regex_killer)) then
     return
      end
   end
   return awful.util.spawn(cmd or process)
end
-- Commands to run automatically at startup
-- AutoStart commands {{{1
-- RedShift:
run_once("redshift", "nice -n19 redshift -l 48.856614:2.3522219000000177 -t 5700:3500")
-- Cache le curseur après 1 sec d'idle et ne le réactive qu'après un mouvement
-- d'au moins 20px
-- http://doc.ubuntu-fr.org/unclutter
run_once("unclutter", "unclutter -idle 1 -jitter 20")
