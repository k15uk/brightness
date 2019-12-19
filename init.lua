local wibox = require( "wibox" )
local awful = require( "awful" )
local beautiful = require( "beautiful" )
local gears = require( "gears" )
local dev = ''
local interval = 10
local tmpfile = "/tmp/bright"
brightness = {}

local function getBrightness ()
  local handle = io.popen( "xrandr --verbose | grep -i brightness | cut -f2 -d ' '" )
  local value = handle:read( "*l" )
  handle:close()
  return tonumber( value )
end

local widget = wibox.widget {
  {
    max_value = 1 ,
    forced_width = 90 ,
    background_color = beautiful.bg_minimize ,
    color = beautiful.bg_focus ,
    widget = wibox.widget.progressbar ,
  } ,
  {
    widget = wibox.widget.textbox() ,
  },
  layout = wibox.layout.stack
}

function brightness:update(value)
  widget.children[ 1 ]:set_value( value )
  widget.children[ 2 ]:set_text( "bright :" .. math.floor( value * 100 ).. "%" )
  awful.spawn.with_shell( "xrandr --output " .. dev .. "  --brightness " .. value )
end

function brightness:offset ( offset )
  local value = getBrightness() + offset
  if value > 1 then
    value = 1
  elseif value <= 0.00 then
    value = 0.00
  end
  brightness:update(value)
end

local h = 1
function brightness:timer ( arg )
	local timer
  timer = gears.timer({timeout = 1 })
	timer:start()
	timer:connect_signal("timeout" ,function()

    local file = io.open(tmpfile)
    local h = tonumber(os.date("%H"))
    local m = tonumber(os.date("%M"))
    local t = {}

    if file ~= nil then
      local data = file:read("*all")
      file:close()
      local i=1
      for s in string.gmatch(data, "([^:]+)") do
        t[i] = tonumber(s)
        i = i + 1
      end

    end

    if file == nil or t[1] ~= h or ( t[1] == h and t[2] + interval <= m ) then
      awful.spawn.with_shell('date +%H:%M > ' .. tmpfile )
      timer:stop()
      timer.timeout = ( interval * 60 )
      brightness:offset( tonumber( arg[h] ) )
      h = h + 1
      if h > 24 then
        h = 1
      end
    end
    timer:start()
	end)
end

function brightness:create ( arg_dev, arg_interval )
  widget.children[ 1 ]:buttons( awful.util.table.join (
      awful.button( { } , 1 , function() brightness:offset( -0.05 ) end )
    , awful.button( { } , 2 , function() brightness:offset( 1 ) end )
    , awful.button( { } , 3 , function() brightness:offset( 0.05 ) end )
    , awful.button( { } , 4 , function() brightness:offset( 0.01 ) end )
    , awful.button( { } , 5 , function() brightness:offset( -0.01 ) end )
    )
  )
	dev = arg_dev
  interval = arg_interval
  brightness:update(getBrightness())
  return widget
end

return brightness
