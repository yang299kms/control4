--[[=============================================================================
    Get, Handle and Dispatch message functions

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_messages = "2015.03.31"
end

--[[=============================================================================
    GetMessage()
  
    Description:
    Used to retrieve a message from the communication buffer. Each driver is
    responsible for parsing that communication from the buffer.
  
    Parameters:
    None
  
    Returns:
    A single message from the communication buffer
===============================================================================]]
function GetMessage()
	local message, pos
	
	--TODO: Implement a string using Lua captures and patterns which 
	--		will be used by string.match to parse out a single message
	--      from the receive buffer(gReceiveBuffer).
	--		The example shown here will return all characters from the beginning of 
	--		the gReceiveBuffer up until but not including the first carriage return.
	local pattern = "^(.-)[\r\n]()"
	--LogDebug(" gRecvBuf = " .. gReceiveBuffer)
	if (gReceiveBuffer:len() > 0) then
		message, pos = string.match(gReceiveBuffer, pattern)
		--print("msg = " .. message)
		--print("pos = " .. pos)
		if (message == nil) then
		     LOG:Info("Do not have a complete message")
			return ""
		end
		gReceiveBuffer = gReceiveBuffer:sub(pos)		
	end

	return message
	
end

--[[=============================================================================
    HandleMessage(message)]

    Description
    This is where we parse the messages returned from the GetMessage()
    function into a command and data. The call to 'DispatchMessage' will use the
    'name' variable as a key to determine which handler routine, function, should
    be called in the DEV_MSG table. The 'value' variable will then be passed as
    a string parameter to that routine.

    Parameters
    message(string) - Message string containing the function and value to be sent to
                      DispatchMessage

    Returns
    Nothing
===============================================================================]]
function HandleMessage(message)
	if (type(message) == "table") then
		LogTrace("HandleMessage. Message is ==>")
		LogTrace(message)
		LogTrace("<==")
	else
		LogTrace("HandleMessage. Message is ==>%s<==", message)
	end

	--TODO: Implement a string using Lua captures and patterns which 
	--		will be used by string.match to parse the message
	--      into a name / value pair.
	--		The example shown here will return all alpha characters 
	--		up to the first non-alpha character and store them in the "name" variable
	--		the remaining characters will be returned and stored in the "value" variable.
	--local pattern =  "(%a+)(.+)()"

	--local name, value, pos = string.match(message, pattern)
	--name = name or message
	--value = value or ""	

	--DispatchMessage(name, value)
end

--[[=============================================================================
    DispatchMessage(MsgKey, MsgData)

    Description
    Parse routine that will call the routines to handle the information returned
    by the connected system.

    Parameters
    MsgKey(string)  - The function to be called from within DispatchMessage
    MsgData(string) - The parameters to be passed to the function found in MsgKey

    Returns
    Nothing
===============================================================================]]
function DispatchMessage(MsgKey, MsgData)
	if (DEV_MSG[MsgKey] ~= nil and (type(DEV_MSG[MsgKey]) == "function")) then
		LogInfo("DEV_MSG." .. tostring(MsgKey) .. ":  " .. tostring(MsgData))
		local status, err = pcall(DEV_MSG[MsgKey], MsgData)
		if (not status) then
			LogError("LUA_ERROR: " .. err)
		end
	else
		LogTrace("HandleMessage: Unhanded command = " .. MsgKey)
	end
end

--[[
TODO: Create DEV_MSG functions for all messages to call Notifies.
	  Sample functions are included below for all applicable notifications.
--]]

function DEV_MSG.INPUT(value)
	LogTrace("DEV_MSG.INPUT(), value = " .. value)
	local input = tInputConnMapByName[tInputResponseMap[value]].ID 	--mod 1000 value of Input Connection ID
    local bindingID = tInputConnMapByID[input].BindingID 		
	LogInfo("INPUT_CHANGED, input = " .. tInputResponseMap[value])
	
	--need to handle audio and video legs of the input...audio needs to be sent first...
	gTVProxy:dev_InputChanged(bindingID, input + 3000)		--audio
	gTVProxy:dev_InputChanged(bindingID, input + 1000)		--video
	
	-- NOTE: there is TV proxy bug that affects Current Input in Composer Programming   
	-- if connection has audio then it is considered audio, if not then it is considered video	
	-- for video only connections (i.e. HDMI), you will need to implement logic to only send the video leg.
end

function DEV_MSG.POWER(value)
	LogTrace("DEV_MSG.POWER(), value = " .. value)

	-- TODO: 01 & 00 values will need to be edited based upon the device protocol values 
	--indicating if the device is on or off
	if (value == "01") then
		gTVProxy:dev_PowerOn()
	elseif (value== "00") then
		gTVProxy:dev_PowerOff()
	else
		LogWarn("DEV_MSG.POWER(): value not valid - " .. value)
	end		
end

function DEV_MSG.VOLUME(value)
	LogTrace("DEV_MSG.VOLUME(), value = " .. value)
	
	-- TODO: derive and set  "output" from value or create separate DEV_MSG functions for each Output Connection
	local output = "" --mod 1000 value of Output Connection ID
	
	local deviceLevel = value
	local minDeviceLevel = MIN_DEVICE_LEVEL
	local maxDeviceLevel = MAX_DEVICE_LEVEL
	--C4 volume level uses a percentage scale: 0 - 100
	local c4Level = ConvertVolumeToC4(deviceLevel, minDeviceLevel, maxDeviceLevel)		
	
	gTVProxy:dev_VolumeLevelChanged(output, c4Level, deviceLevel)		
end

function DEV_MSG.MUTE(value)
	LogTrace("DEV_MSG.MUTE(), value = " .. value)
	
	-- TODO: derive and set  "output" from value or create separate DEV_MSG functions for each Output Connection
	local output    --mod 1000 value of Output Connection ID
	
	local state   	--Mute state represented as "True" or "False"
	-- TODO: values "01" & "00" will need to be modified based upon the device protocol specification
	if (value == "01") then 
		state = "True"
	elseif (value == "00") then
		state = "False"
	else
		LogWarn("DEV_MSG.MUTE(), value not valid, exiting...")
		return
	end
	gTVProxy:dev_MuteChanged(output, state)
end		

function DEV_MSG.BASS(value)
	LogTrace("DEV_MSG.BASS(), value = " .. value)
	
	-- TODO: derive and set  "output" from value or create separate DEV_MSG functions for each Output Connection
	local output  --mod 1000 value of Output Connection ID
	
	-- TODO: set "level", Bass level is represented as a percentage value
	local level  
	
	gTVProxy:dev_BassLevelChanged(output, level)
end	

function DEV_MSG.TREBLE(value)
	LogTrace("DEV_MSG.TREBLE(), value = " .. value)
	
	-- TODO: derive and set  "output" from value or create separate DEV_MSG functions for each Output Connection
	local output  --mod 1000 value of Output Connection ID
	
	-- TODO: set "level", Treble level is represented as a percentage value
	local level   
	
	gTVProxy:dev_TrebleLevelChanged(output, level)
end	

function DEV_MSG.BALANCE(value)
	LogTrace("DEV_MSG.BALANCE(), value = " .. value)
	
	-- TODO: derive and set  "output" from value or create separate DEV_MSG functions for each Output Connection
	local output  --mod 1000 value of Output Connection ID
	
	-- TODO: set "level", Bass level is represented as a percentage value
	local level  
	
	gTVProxy:dev_BalanceLevelChanged(output, level)
end	

function DEV_MSG.LOUDNESS(value)
	LogTrace("DEV_MSG.LOUDNESS(), value = " .. value)
	
	-- TODO: derive and set  "output" from value or create separate DEV_MSG functions for each Output Connection
	local output  --mod 1000 value of Output Connection ID
	
	-- TODO: set "state", Loudness state is represented as "True" or "False" (literal string, not boolean)
	local state  
	gTVProxy:dev_LoudnessChanged(output, state)
end

--Channel Status
function DEV_MSG.CHANNEL(value)
	LogTrace("DEV_MSG.CHANNEL(), value = " .. value)
	local channel = tonumber_loc(value)	
	gTVProxy:dev_ChannelStatus(channel)
end
	
