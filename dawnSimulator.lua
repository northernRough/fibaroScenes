--[[
%% properties
%% globals
SleepState
--]]
fibaro:debug("HC2 start script at " .. os.date());
 
-- LUA - Dawn simulator V1.0.1
--
-- Wake up "naturally", illuminated by a soft light and progressive.
-- Based on open source Robert Penner's original easing equations (Copyright © 2001 Robert Penner) 
-- Copyright © 2013 Jean-christophe Vermandé
 
-- USER SETTINGS :
-- Type of equation used to generate the curve (dimming).
-- Possible values are: linear, inQuad, inExpo, outExpo, inOutQuad, inOutExpo, outInExpo
 
local curve = "inExpo"; -- Type of equation used to generate the curve (dimming).
local debug = false;     -- To log in HC2 debug area
local devices = {375};   -- IDs of devices to be varied (only dimmable device), eg. {1, 16, 10}
local startValue = 0;   -- Begin value
local endValue = 100;   -- End value
local duration = 120;    -- Execution time in seconds of the scene
 
 
-- DO NOT EDIT THE CODE BELOW (except to suit your needs) --
 
 
dawnSimulatorEngine = {
  version = "1.0.1"
};
function dawnSimulatorEngine:init(startValue, endValue, duration, devices, curve, debug)
  self._lastValue = 0 
  self._startValue = startValue or 0;
  self._endValue = endValue or 100;
  self._duration = duration or 1;
  self._devices = devices or {}; 
  self._curve = equations.map[curve or 'linear'];  -- require 'equations' to operate
  self._debug = debug or true;
end
function dawnSimulatorEngine:_update(value)  
  self._lastValue = value; -- keep in memory the last value to compare later
  -- loop in deveices
  local name, id;
  for i=1, #self._devices do
    id = tonumber(self._devices[i]);
    fibaro:call(id, "setValue", value);
    if (self._debug) then
      name = fibaro:getName(id);
      if (name == nil or name == string.char(0)) then
        name = "Unknown"
      end
      fibaro:debug("Device:" .. name .. " setValue: " .. value);
    end
  end
end
function dawnSimulatorEngine:_compute(time)
  return math.ceil(tonumber(self._curve(time, self._startValue, self._endValue, self._duration)));
end
function dawnSimulatorEngine:start()
  local computedValue;
  local doWhile = true;
  local time = 0;
  -- timeline
  while (doWhile == true) do
    computedValue = self:_compute(time);
    -- prevent multiple call with same value
    if (computedValue ~= self._lastValue) then
      -- update device value
      self:_update(computedValue);
    end
    time = time + 1;
    if (time > self._duration) then
      doWhile = false;
      if (self._lastValue < self._endValue) then
        -- force target value
        self:_update(computedValue);
      end
    else
      fibaro:sleep(1000);
    end
    -- do while
  end
end
 
-- Easing function (Penner's Easing Equations)
equations = equations or {
  version = "1.0.1",
  -- Linear
  linear = function(t, b, c, d)
    return c * t / d + b;
  end,
  -- InQuad
  inQuad = function(t, b, c, d)
    t = t / d;
    return c * math.pow(t, 2) + b;
  end,
  -- InOutQuad
  inOutQuad = function(t, b, c, d)
    t = t / d * 2;
    if t < 1 then
      return c / 2 * math.pow(t, 2) + b;
    else
      return -c / 2 * ((t - 1) * (t - 3) - 1) + b;
    end
  end,
  -- InOutExpo
  inOutExpo = function(t, b, c, d)
    if t == 0 then return b end
    if t == d then return b + c end
    t = t / d * 2;
    if t < 1 then
      return c / 2 * math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
    else
      t = t - 1;
      return c / 2 * 1.0005 * (-math.pow(2, -10 * t) + 2) + b;
    end
  end,
  -- OutInExpo
  outInExpo = function(t, b, c, d)
    if t < d / 2 then
      return equations.outExpo(t * 2, b, c / 2, d);
    else
      return equations.inExpo((t * 2) - d, b + c / 2, c / 2, d);
    end
  end,
  -- InExpo
  inExpo = function(t, b, c, d)
    if t == 0 then
      return b;
    else
      return c * math.pow(2, 10 * (t / d - 1)) + b - c * 0.001;
    end
  end,
  -- OutExpo
  outExpo = function(t, b, c, d)
    if t == d then
      return b + c;
    else
      return c * 1.001 * (-math.pow(2, -10 * t / d) + 1) + b;
    end
  end
};
 
-- Equations map
equations.map = {
  ['linear'] = equations.linear,
  ['inQuad'] = equations.inQuad,
  ['inExpo'] = equations.inExpo,
  ['outExpo'] = equations.outExpo,
  ['inOutQuad'] = equations.inOutQuad,
  ['inOutExpo'] = equations.inOutExpo,
  ['outInExpo'] = equations.outInExpo
}

if fibaro:getGlobalValue("PresentState") == "Home"  and  fibaro:getGlobalValue("SleepState") == "WakingUp" 
then
--startEngine(equations.map[curve]);
dawnSimulatorEngine:init(startValue, endValue, duration, devices, curve, debug);
dawnSimulatorEngine:start();
fibaro:sleep(5*60*1000)
fibaro:call(375, "setValue", "0")
fibaro:debug("Dimmer off")
elseif fibaro:getGlobalValue("PresentState") == "Home"  and  fibaro:getGlobalValue("SleepState") == "Awake"
then
--startEngine(equations.map[curve]);
dawnSimulatorEngine:init(startValue, endValue, duration, devices, curve, debug);
dawnSimulatorEngine:start();
fibaro:sleep(5*60*1000)
fibaro:call(375, "setValue", "0")
fibaro:debug("Dimmer off")
end
