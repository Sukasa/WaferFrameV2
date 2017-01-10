Config = require("Config")

Tail = string.rep(string.char(0xff), 104)
Brightness = 31
On = 1
CurrentMode = nil
ModeState = nil

LEDs = {}

function ChangeMode(Mode)
  local Delay
  CurrentMode = nil
  ModeState = nil
  Delay, CurrentMode, ModeState = dofile("Mode"..Mode..".lua")
  for k = 0, 204, 4 do
    LEDs[k + 1] = 224
    LEDs[k + 2] = 0
    LEDs[k + 3] = 0
    LEDs[k + 4] = 0
  end
  tmr.interval(0, Delay)
end

function Tick()
  CurrentMode(ModeState)
  spi.send(1, 0, 0, 0, 0, LEDs, Tail)
end

function Advance()
  for i = 204, 1, -1 do
    LEDs[i + 4] = LEDs[i]
  end
end

function SetLED(LED, R, G, B)
  if LED <= 0 or LED >= 53 then return end
  LED = (LED - 1) * 4
  LEDs[LED + 1] = 224 + (Brightness * On)
  LEDs[LED + 2] = math.floor(G)
  LEDs[LED + 3] = math.floor(B)
  LEDs[LED + 4] = math.floor(R)
end

function GetLED(LED)
  if LED <= 0 or LED >= 53 then return 0, 0, 0 end
  LED = (LED - 1) * 4
  return LEDs[LED + 4], LEDs[LED + 2], LEDs[LED + 3]
end

wifi.sta.eventMonReg(wifi.STA_GOTIP,
  function()
    wifi.sta.eventMonReg(wifi.STA_GOTIP, "unreg")
    wifi.sta.eventMonStop();
    
    MQTT:connect(Config.Server)
  end
)

node.setcpufreq(node.CPU160MHZ)

wifi.setmode(wifi.STATION)
-- v v You will need to change this line if running a newer version of NodeMCU v v
wifi.sta.config(Config.WifiSSID, Config.WifiPW)
wifi.sta.eventMonStart();

MQTT = mqtt.Client(Config.ClientName)

MQTT:on("message",
  function(conn, topic, data)
    print(topic, data)
    if topic == Config.OnOffTopic then
      if data == "1" then
        On = 1
      elseif data == "0" then
        On = 0
      end
      for k = 1, 205, 4 do
        LEDs[k] = 224 + (Brightness * On)
      end
    elseif topic == Config.BrightTopic then
      Brightness = math.max(math.min(tonumber(data), 31), 0)
      for k = 1, 205, 4 do
        LEDs[k] = 224 + (Brightness * On)
      end
    elseif topic == Config.ModeTopic then
      ChangeMode(data)
    end
  end
)

MQTT:on("connect", function(con)
  MQTT:subscribe({[Config.OnOffTopic] = 1, [Config.ModeTopic] = 1, [Config.BrightTopic] = 1})
end)

tmr.alarm(0, 10000, tmr.ALARM_AUTO, Tick)
ChangeMode("Rainbow")
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_HIGH, 8, 0)