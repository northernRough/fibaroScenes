--[[
%% properties
%% globals
60 sceneActivation
TimeOfDay
--]]

-- credit syntez

local startSource = fibaro:getSourceTrigger();

local LRDim = fibaro:getValue(60, 'value')

fibaro:debug('value = ' .. LRDim)

    if (

      ( tonumber(fibaro:getValue(60, "sceneActivation")) == 16 )

      or startSource["type"] == "other" )

      then

     if (fibaro:getGlobalValue("TimeOfDay") == "Night" ) then

      if (LRDim == '0') then

             fibaro:call(60, "setValue", "25")

         else

             fibaro:call(60, 'turnOff')

      end


      else

        if (LRDim == '0') then

             fibaro:call(60, "setValue", "85")

           else

             fibaro:call(60, 'turnOff')

        end

     end

    end
