--[[=============================================================================
    TV Proxy Class Code

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.properties = "2015.03.31"
end

TVProxy = inheritsFrom(nil)

function TVProxy:construct(tvBindingID, bProcessesDeviceMessages, tVolumeRampingTracking, bUsePulseCommandsForVolumeRamping)
	-- member variables
	self._TVBindingID = tvBindingID
	self._PowerState = ""							--Valid Values: "ON", "OFF", "POWER_ON_SEQUENCE", "POWER_OFF_SEQUENCE"
	self._VolumeIsRamping = false
	self._VolumeRamping = tVolumeRampingTracking	--{["state"] = false, ["mode"] = "",} ||	"state" is boolean, "mode" values: "VOLUME_UP" & "VOLUME_DOWN"
	self._UsePulseCommandsForVolumeRamping = bUsePulseCommandsForVolumeRamping or false
	self._LastVolumeStatusValue = 0	
	self._MenuNavigationInProgress = false
     self._MenuNavigationMode = ""
	self._MenuNavigationProxyID = ""
	self._CurrentlySelectedInput = ""
	self._ProcessesDeviceMessages = bProcessesDeviceMessages
	self._ControlMethod = ""						--Valid Values: "NETWORK", "SERIAL", "IR" 
end

------------------------------------------------------------------------
-- TV Proxy Commands (PRX_CMD)
------------------------------------------------------------------------
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Power Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function TVProxy:prx_ON(tParams)
	if (self._PowerState ~= nil) then
		if (self._PowerState == 'ON') or (self._PowerState == 'POWER_ON_SEQUENCE') then 
			LogInfo("Power State is '" .. self._PowerState .. "', exiting ON")
			return 
		end	
	end	
	if (self._ProcessesDeviceMessages == false) then
		self._PowerState = 'ON'
	else	
		self._PowerState = 'POWER_ON_SEQUENCE'
	end	
    if (gControlMethod == "IR") then			
		NOTIFY.ON()			
    end	
	ON()
end

function TVProxy:prx_OFF(tParams)
    if (self._ProcessesDeviceMessages == false) then
	   self._PowerState = 'OFF'
    else	
	   self._PowerState = 'POWER_OFF_SEQUENCE'
    end	
    if (gControlMethod == "IR") then			
	   NOTIFY.OFF()			
    end 	
    OFF()
  
    self._CurrentlySelectedInput = -1
    C4:SendToProxy(self._TVBindingID, 'INPUT_CHANGED', {INPUT = -1})
    C4:SendToProxy(self._TVBindingID, 'INPUT_CHANGED', {INPUT = -1})
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Input Selection Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function TVProxy:prx_SET_INPUT(idBinding, tParams)
	local input = tonumber(tParams["INPUT"] % 1000)
	self._CurrentlySelectedInput = input
	if (gControlMethod == "IR") then			
		NOTIFY.INPUT_CHANGED(self._TVBindingID, input)				
	end 		

	SET_INPUT(idBinding, input)
end

function TVProxy:prx_TV_VIDEO(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "TV_VIDEO")
end

function TVProxy:prx_INPUT_TOGGLE(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "INPUT_TOGGLE")
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Volume Control Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function TVProxy:prx_MUTE_OFF(tParams)
	if (gControlMethod == "IR") then	
		local output = 0
		NOTIFY.MUTE_CHANGED(self._TVBindingID, output, "False")
	end 		
	MUTE_OFF()
end

function TVProxy:prx_MUTE_ON(tParams)
	if (gControlMethod == "IR") then		
		local output = 0
		NOTIFY.MUTE_CHANGED(self._TVBindingID, output, "True")
	end 		
	MUTE_ON()
end

function TVProxy:prx_MUTE_TOGGLE(tParams)
	MUTE_TOGGLE()
end

function TVProxy:prx_SET_VOLUME_LEVEL(tParams)
	local c4VolumeLevel = tonumber(tParams['LEVEL'])
	SET_VOLUME_LEVEL(c4VolumeLevel)
end

function TVProxy:prx_PULSE_VOL_DOWN(tParams)
	PULSE_VOL_DOWN()
end

function TVProxy:prx_PULSE_VOL_UP(tParams)
	PULSE_VOL_UP()
end

function TVProxy:prx_START_VOL_DOWN(tParams)
	self:ChangeVolume("START_VOL_DOWN")
end

function TVProxy:prx_START_VOL_UP(tParams)
	self:ChangeVolume("START_VOL_UP")
end

function TVProxy:prx_STOP_VOL_DOWN(tParams)
	self:ChangeVolume("STOP_VOL_DOWN")
end

function TVProxy:prx_STOP_VOL_UP(tParams)
	self:ChangeVolume("STOP_VOL_UP")
end

---------------------- Volume Helper Functions ----------------------
function TVProxy:ChangeVolume(command_name)
	if (command_name == "STOP_VOL_UP") or (command_name == "STOP_VOL_DOWN") then
		self._VolumeIsRamping = false
		self._VolumeRamping.state = false
		self._VolumeRamping.mode = ""
	elseif (command_name == "START_VOL_UP") then 
		self._VolumeIsRamping = true
		self._VolumeRamping.state = true
		self._VolumeRamping.mode = "VOLUME_UP" 
		PULSE_VOL_UP()	
	elseif (command_name == "START_VOL_DOWN") then 	
		self._VolumeIsRamping = true
		self._VolumeRamping.state = true
		self._VolumeRamping.mode = "VOLUME_DOWN"	
		PULSE_VOL_DOWN()		
	else
		LogWarn(command_name .. " not handled in ChangeVolume()")
	end
end

function TVProxy:ContinueVolumeRamping()
	local command
	if (gControlMethod == "IR") then   
		if (self._VolumeRamping.mode == "VOLUME_UP") then
			PULSE_VOL_UP()	
		elseif (self._VolumeRamping.mode == "VOLUME_DOWN") then
			PULSE_VOL_DOWN()	
		else
			LogWarn("ContinueVolumeRamping() ramping mode is not valid.")
		end	
	else
	     if (self._UsePulseCommandsForVolumeRamping) then
		    if (self._VolumeRamping.mode == "VOLUME_UP") then
			 PULSE_VOL_UP()	
		    elseif (self._VolumeRamping.mode == "VOLUME_DOWN") then
			 PULSE_VOL_DOWN()	
		    else
			 LogWarn("ContinueVolumeRamping() ramping mode is not valid.")
		    end	
		else
		    local volume = self._LastVolumeStatusValue
		    local deviceVolumeLevel = self:GetNextVolumeCurveValue(volume)
		    if (deviceVolumeLevel ~= nil) then
			    self._LastVolumeStatusValue = deviceVolumeLevel
			    SET_VOLUME_LEVEL_DEVICE(deviceVolumeLevel)                                 
		    else
			    LogWarn("ContinueVolumeRamping() next value is nil")
			    return
		    end
	     end
	end 
end

function TVProxy:GetNextVolumeCurveValue(volume)
	local i, point
	volume=tonumber(volume)
	if (self._VolumeRamping.mode == "VOLUME_UP") then
		for i=1,table.maxn(tVolumeCurve) do
			point=tonumber(tVolumeCurve[i])
			if point > volume then		
				return tVolumeCurve[i]
			end
		end
	elseif (self._VolumeRamping.mode == "VOLUME_DOWN") then
		for i=table.maxn(tVolumeCurve),1,-1 do
			point=tonumber(tVolumeCurve[i])
			if point < volume then
				return tVolumeCurve[i]
			end
		end
	else
		LogWarn("Volume Ramping Mode not set for "  .. tOutputConnMap[output])
		return nil
	end 
end

function TVProxy:CreateVolumeCurve(steps, slope, minDeviceLevel, maxDeviceLevel)
    local curveV = {}
    curveV.__index = curveV

    function curveV:new(min, max, base)
	 local len = max-min
	 local logBase = math.log(base)
	 local baseM1 = base-1

	 local instance = {
	   min = min,
	   max = max,
	   len = len,
	   base = base,
	   logBase = logBase,
	   baseM1 = baseM1,
	   toNormal = function(x)
		return (x-min)/len
	   end,
	   fromNormal = function(x)
		return min+x*len
	   end,
	   value = function(x)
		return math.log(x*baseM1+1)/logBase
	   end,
	   invert = function(x)
		return (math.exp(x*logBase)-1)/baseM1
	   end
	 }
	 return setmetatable(instance, self)
    end

    function curveV:list(from, to, steps)
	 local fromI = self.invert(self.toNormal(from))
	 local toI = self.invert(self.toNormal(to))

	 for i = 1, steps do
	   --print(i, self.fromNormal(self.value(fromI+(i-1)*(toI-fromI)/(steps-1))))
	    print(i, math.floor(self.fromNormal(self.value(fromI+(i-1)*(toI-fromI)/(steps-1)))))
	 end
    end
    
    function curveV:create_curve(from, to, steps)
	 local fromI = self.invert(self.toNormal(from))
	 local toI = self.invert(self.toNormal(to))
	 
      local tCurve = {}
	 for i = 1, steps do
	   --print(i, self.fromNormal(self.value(fromI+(i-1)*(toI-fromI)/(steps-1))))
	   --print(i, math.floor(self.fromNormal(self.value(fromI+(i-1)*(toI-fromI)/(steps-1)))))
	    
	    local x = math.floor(self.fromNormal(self.value(fromI+(i-1)*(toI-fromI)/(steps-1))))
	    
	    if (has_value(tCurve, x) == false) then
		  table.insert(tCurve, x)
		  print(i, x)
	    end
	 end
	 
	 return tCurve
    end
    
    

    -- min, max, base of log (must be > 1), try some for the best results
    local a = curveV:new(minDeviceLevel, maxDeviceLevel, slope)

    -- from, to, steps
    --a:list(minDeviceLevel, maxDeviceLevel, steps)
    
    local t = a:create_curve(minDeviceLevel, maxDeviceLevel, steps)
    
    return t

end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function ConvertVolumeToC4(volume, minDeviceLevel, maxDeviceLevel)
	--to be used when converting a volume level from a device to a 
	--percentage value that can be used by C4 proxies
	--"volume" is the volume value from the device
	--"minDeviceLevel" & "maxDeviceLevel" are the minimum and maximum volume levels
	--as specified in the device protocol documentation
	return ProcessVolumeLevel(volume, minDeviceLevel, maxDeviceLevel, 0, 100)
end

function ConvertVolumeToDevice(volume, minDeviceLevel, maxDeviceLevel)
	--to be used when converting a volume level from a C4 proxy to a 
	--value that can be used by the device 
	--"volume" is the volume value from the C4 proxy
	--"minDeviceLevel" & "maxDeviceLevel" are the minimum and maximum volume levels
	--as specified in the device protocol documentation
	return ProcessVolumeLevel(volume, 0, 100, minDeviceLevel, maxDeviceLevel)
end

function ProcessVolumeLevel(volLevel, minVolLevel, maxVolLevel, minDeviceLevel, maxDeviceLevel)
	  local level = (volLevel-minVolLevel)/(maxVolLevel-minVolLevel)
	  --LogInfo("level = " .. level)
	  local vl=(level*(maxDeviceLevel-minDeviceLevel))+minDeviceLevel
	  --LogInfo("vl = " .. vl)
	  vl= tonumber_loc(("%.".."0".."f"):format(vl))
	  --LogInfo("vl new = " .. vl)
	  LogInfo("ProcessVolumeLevel(level in=" .. volLevel .. ", level out=" .. vl .. ")")
	  return vl
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Tuner Proxy Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function TVProxy:prx_PULSE_CH_UP(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PULSE_CH_UP")
end

function TVProxy:prx_START_CH_UP(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PULSE_CH_UP")
end

function TVProxy:prx_PULSE_CH_DOWN(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PULSE_CH_DOWN")
end

function TVProxy:prx_START_CH_DOWN(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PULSE_CH_DOWN")
end

function TVProxy:prx_PRESET_UP(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PRESET_UP")
end

function TVProxy:prx_PRESET_DOWN(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PRESET_DOWN")
end

function TVProxy:prx_SET_CHANNEL(idBinding, tParams)
    local channel= tParams['CHANNEL']
	SET_CHANNEL(idBinding, channel)
end


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Menu Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function TVProxy:prx_INFO(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "INFO")
end

function TVProxy:prx_GUIDE(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "GUIDE")
end

function TVProxy:prx_MENU(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "MENU")
end

function TVProxy:prx_CANCEL(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "CANCEL")
end

function TVProxy:prx_UP(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "UP")
end

function TVProxy:prx_DOWN(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "DOWN")
end

function TVProxy:prx_LEFT(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "LEFT")
end

function TVProxy:prx_RIGHT(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "RIGHT")
end

function TVProxy:prx_START_DOWN(idBinding, tParams)
	self:NavigateMenu(idBinding, "START_DOWN")
end

function TVProxy:prx_START_UP(idBinding, tParams)
	self:NavigateMenu(idBinding, "START_UP")
end

function TVProxy:prx_START_LEFT(idBinding, tParams)
	self:NavigateMenu(idBinding, "START_LEFT")
end

function TVProxy:prx_START_RIGHT(idBinding, tParams)
	self:NavigateMenu(idBinding, "START_RIGHT")
end

function TVProxy:prx_STOP_DOWN(idBinding, tParams)
	self:NavigateMenu(idBinding, "STOP_DOWN")
end

function TVProxy:prx_STOP_UP(idBinding, tParams)
	self:NavigateMenu(idBinding, "STOP_UP")
end

function TVProxy:prx_STOP_LEFT(idBinding, tParams)
	self:NavigateMenu(idBinding, "STOP_LEFT")
end

function TVProxy:prx_STOP_RIGHT(idBinding, tParams)
	self:NavigateMenu(idBinding, "STOP_RIGHT")
end

function TVProxy:prx_ENTER(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "ENTER")
end

function TVProxy:prx_RECALL(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "RECALL")
end

function TVProxy:prx_OPEN_CLOSE(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "OPEN_CLOSE")
end

function TVProxy:prx_PROGRAM_A(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PROGRAM_A")
end

function TVProxy:prx_PROGRAM_B(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PROGRAM_B")
end

function TVProxy:prx_PROGRAM_C(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PROGRAM_C")
end

function TVProxy:prx_PROGRAM_D(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PROGRAM_D")
end

function TVProxy:prx_CLOSED_CAPTIONED(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "CLOSED_CAPTIONED")
end

---------------------- Menu Navigation Helper Functions ----------------------
function TVProxy:NavigateMenu(idBinding, command_name)
	if (command_name == "STOP_UP") 
				or (command_name == "STOP_DOWN") 
				or (command_name == "STOP_LEFT") 
				or (command_name == "STOP_RIGHT") then
		self._MenuNavigationInProgress = false
		self._MenuNavigationMode = ""
		self._MenuNavigationProxyID = ""
		return
	elseif (command_name == "START_UP") then 
		self._MenuNavigationMode = "UP"
	elseif (command_name == "START_DOWN") then 	
		self._MenuNavigationMode = "DOWN"	
	elseif (command_name == "START_LEFT") then 
		self._MenuNavigationMode = "LEFT"	
     elseif (command_name == "START_RIGHT") then 
		self._MenuNavigationMode = "RIGHT"
	else
		LogWarn(command_name .. " not handled in NavigateMenu()")
	end
	
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, self._MenuNavigationMode)
	self._MenuNavigationInProgress = true
	self._MenuNavigationProxyID = idBinding
	
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Digit Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function TVProxy:prx_NUMBER_0(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_0")
end

function TVProxy:prx_NUMBER_1(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_1")
end

function TVProxy:prx_NUMBER_2(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_2")
end

function TVProxy:prx_NUMBER_3(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_3")
end

function TVProxy:prx_NUMBER_4(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_4")
end

function TVProxy:prx_NUMBER_5(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_5")
end

function TVProxy:prx_NUMBER_6(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_6")
end

function TVProxy:prx_NUMBER_7(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_7")
end

function TVProxy:prx_NUMBER_8(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_8")
end

function TVProxy:prx_NUMBER_9(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_9")
end

function TVProxy:prx_STAR(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "STAR")
end

function TVProxy:prx_POUND(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "POUND")
end

function TVProxy:prx_HYPHEN(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "HYPHEN")
end


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Transport Navigation Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function TVProxy:prx_PLAY(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PLAY")
end
	
function TVProxy:prx_PAUSE(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "PAUSE")
end

function TVProxy:prx_STOP(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "STOP")
end

function TVProxy:prx_SKIP_REV(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "SKIP_REV")
end

function TVProxy:prx_SKIP_FWD(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "SKIP_FWD")
end

function TVProxy:prx_SCAN_REV(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "SCAN_REV")
end

function TVProxy:prx_SCAN_FWD(idBinding, tParams)
	SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "SCAN_FWD")
end

------------------------------------------------------------------------
-- TV Proxy Notifies
------------------------------------------------------------------------

function TVProxy:dev_InputChanged(bindingID, input)
	NOTIFY.INPUT_CHANGED(bindingID, input)
end

function TVProxy:dev_PowerOn()
	self._PowerState = "ON"
	NOTIFY.ON()	
end

function TVProxy:dev_PowerOff()
	self._PowerState = "OFF"
	NOTIFY.OFF()
end

function TVProxy:dev_VolumeLevelChanged(output, c4Level, deviceLevel)
	NOTIFY.VOLUME_LEVEL_CHANGED(self._TVBindingID, output, c4Level)	
	
	if (self._VolumeIsRamping) then
		--do nothing
		--during volume ramping, LastVolumeStatusValue is set in ContinueVolumeRamping()
	else
		self._LastVolumeStatusValue = deviceLevel
	end	
end

function TVProxy:dev_MuteChanged(output, state)
	NOTIFY.MUTE_CHANGED(self._TVBindingID, output, state)
end		

function TVProxy:dev_BassLevelChanged(output, level)
	NOTIFY.BASS_LEVEL_CHANGED(self._TVBindingID, output, level)
end	

function TVProxy:dev_TrebleLevelChanged(output, level)
	NOTIFY.TREBLE_LEVEL_CHANGED(self._TVBindingID, output, level)
end	

function TVProxy:dev_BalanceLevelChanged(output, level)
	NOTIFY.BALANCE_LEVEL_CHANGED(self._TVBindingID, output, level)
end	

function TVProxy:dev_LoudnessChanged(output, state)
	NOTIFY.LOUDNESS_CHANGED(self._TVBindingID, output, state)
end

function TVProxy:dev_ChannelStatus(channel)
	NOTIFY.CHANNEL_CHANGED(self._TVBindingID, channel)
end