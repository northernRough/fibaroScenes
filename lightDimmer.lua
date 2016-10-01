--[[
%% properties
293 sceneActivation
%% events
%% globals
--]]
 
 -- credit to morpheus75
 
local nodon = 293
local dimmer = 22
 
  local level = tonumber(fibaro:getValue(dimmer, "value"))
  local sa = tonumber(fibaro:getValue(nodon, "sceneActivation"))
fibaro:debug(level)
  
 
if (sa == 20) -- press once up 5
  then
  level = level + 5
  fibaro:call(dimmer, "setValue", level)
  fibaro:debug(level..' upped')
  end
 
if (sa == 40) -- press once down 5
  then
level = level - 5
  fibaro:call(dimmer, "setValue", level)
  fibaro:debug(level..' downed')
  end
 
if (sa == 22) -- press and hold up 10
  then
  level = level + 10
  fibaro:call(dimmer, "setValue", level)
  fibaro:debug(level..' upped')
  end
 
if (sa == 42) -- press and hold down 10
  then
level = level - 10
  fibaro:call(dimmer, "setValue", level)
  fibaro:debug(level..' downed')
  end
 
if (level <1) then
  fibaro:call(dimmer, "turnOff")
 fibaro:debug('off') 
end
