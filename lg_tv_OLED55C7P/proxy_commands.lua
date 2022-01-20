--[[=============================================================================
    Commands received from the TV proxy (ReceivedFromProxy)

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_messages = "2015.03.31"
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Power Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
--[[
	Proxy Command: ON
	Parameters:
--]]
function ON()
    local command_delay = tonumber(Properties["Power On Delay Seconds"])
    local delay_units = "SECONDS"
    local command
    gIsNetworkConnected = true
    SetControlMethod()
    LogTrace("Control Method = " .. gControlMethod)
    if (gControlMethod == "IR") then
		-- TODO: create packet/command to send to the device
		command = CMDS_IR["ON"]
		LogTrace("command = " .. command)
		PackAndQueueCommand("ON", command, command_delay, delay_units)
    elseif (gControlMethod == "Network") then
        -- Send WOL to turn on TV
	   local MAC = Properties["Ethernet MAC"]
	   --MAC = MAC:gsub(":", "") -- Remove any colons in the entered MAC addresses 
	   --MAC = tohex(MAC) -- Convert to HEX 
	   --packet = string.rep(string.char(255), 6) .. string.rep(MAC, 16) -- Build 'magic packet'. 
	   --hexdump(packet)
	   C4:SendWOL(MAC)
	   if(not gCon._IsOnline) then 
	    C4:NetConnect(NETWORK_BINDING_ID, NETWORK_PORT, "TCP")
	   end
	   --C4:SendBroadcast(packet,9)
    else
		-- TODO: create packet/command to send to the device
		command = CMDS["ON"]
		LogTrace("command = " .. command)
		PackAndQueueCommand("ON", command, command_delay, delay_units)
		
		GetDeviceVolumeStatus()
		
		-- TODO: If the device will automatically report power status after
		--	the On command is sent, then the line below can be commented out		
		GetDevicePowerStatus()		
    end
end

--[[
	Proxy Command: OFF
	Parameters:
--]]
function OFF()
    local command_delay = tonumber(Properties["Power Off Delay Seconds"])
    local delay_units = "SECONDS"
    local command 
    LogTrace("Control Method = " .. gControlMethod)
    if (gControlMethod == "IR") then
		-- TODO: create packet/command to send to the device
		command = CMDS_IR["OFF"]
		LogTrace("command = " .. command)
		PackAndQueueCommand("OFF", command, command_delay, delay_units)		
    else
		-- TODO: create packet/command to send to the device
	   if(not gCon._IsOnline) then 
	    C4:NetConnect(NETWORK_BINDING_ID, NETWORK_PORT, "TCP")
	   end
		command = CMDS["OFF"]
		LogTrace("command = " .. command)
		PackAndQueueCommand("OFF", command, command_delay, delay_units)	

		-- TODO: If the device will automatically report power status after
		--	the Off command is sent, then the line below can be commented out
		--GetDevicePowerStatus()
    end 
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Input Selection Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
--[[
	Proxy Command: SET_INPUT
	Parameters:
		idBinding: proxybindingid of proxy bound to input connection
		output: mod 1000 value of Output Connection id	
		input: mod 1000 value of Input Connection id
--]]
function SET_INPUT(idBinding, input)
	local command
	LogTrace("Binding = " .. idBinding .. " input = " .. input)
	if (gControlMethod == "IR") then		
		-- TODO: create packet/command to send to the device
		command = tInputCommandMap_IR[tInputConnMapByID[input].Name]	
	else
		-- TODO: create packet/command to send to the device
		--Edit the Input Selection command syntax based upon the protocol specification
		--if the tables referenced below are set up properly them no editing may be necessary 	
		command = tInputCommandMap[tInputConnMapByID[input].Name] 
	end 		

	LogTrace("command = " .. command)
	PackAndQueueCommand("SET_INPUT", command)
end

function SET_DEFAULT_INPUT(idBinding, input)
	LogInfo("Default Input = " .. input .. " Binding = " .. idBinding)
end
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Volume Control Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
--[[
	Proxy Command: MUTE_OFF
	Parameters:
		output: mod 1000 value of Output Connection id	
--]]
function MUTE_OFF()
	local command
	if (gControlMethod == "IR") then		
		-- TODO: create packet/command to send to the device
		command = CMDS_IR["MUTE_OFF"]	
	else
		-- TODO: create packet/command to send to the device
		command = CMDS["MUTE_OFF"]
	end 	
	LogTrace("command = " .. command)
	PackAndQueueCommand("MUTE_OFF", command)
end

--[[
	Proxy Command: MUTE_ON
	Parameters:
		output: mod 1000 value of Output Connection id	
--]]
function MUTE_ON()
	local command
	if (gControlMethod == "IR") then			
		command = CMDS_IR["MUTE_ON"]	
	else
		-- TODO: create packet/command to send to the device
		command = CMDS["MUTE_ON"]
	end 	
	LogTrace("command = " .. command)
	PackAndQueueCommand("MUTE_ON", command)		
end

--[[
	Proxy Command: MUTE_TOGGLE
	Parameters:
		output: mod 1000 value of Output Connection id	
--]]
function MUTE_TOGGLE()
	local command
	if (gControlMethod == "IR") then			
		command = CMDS_IR["MUTE_TOGGLE"]	
	else
		-- TODO: create packet/command to send to the device
		command = CMDS["MUTE_TOGGLE"]
	end 
	LogTrace("command = " .. command)
	PackAndQueueCommand("MUTE_TOGGLE", command)
end

--[[
	Proxy Command: SET_VOLUME_LEVEL
	Parameters:
		output: mod 1000 value of Output Connection id	
		c4VolumeLevel: volume level to be set represented in Control4 scale (0-100)
--]]
function SET_VOLUME_LEVEL(c4VolumeLevel)
	local minDeviceLevel = MIN_DEVICE_LEVEL
	local maxDeviceLevel = MAX_DEVICE_LEVEL
	local deviceVolumeLevel = ConvertVolumeToDevice(c4VolumeLevel, minDeviceLevel, maxDeviceLevel)	
	
	---- TODO: uncomment and edit string padding, if required, based upon the protocol specification
    --deviceVolumeLevel = string.rep("0", 2 - string.len(deviceVolumeLevel)) .. deviceVolumeLevel
	
	LogInfo('deviceVolumeLevel: ' .. deviceVolumeLevel)
  
	-- TODO: create packet/command to send to the device
	local command = CMDS["SET_VOLUME_LEVEL"] .. deviceVolumeLevel
	LogTrace("command = " .. command)
	PackAndQueueCommand("SET_VOLUME_LEVEL", command)
end

--[[
	Helper Function: SET_VOLUME_LEVEL_DEVICE
	Parameters:
		output: mod 1000 value of Output Connection id	
		deviceVolumeLevel: volume level to be set represented in device scale (as sepcified in the device's control protocol)
--]]
function SET_VOLUME_LEVEL_DEVICE(deviceVolumeLevel)
	--Called from ContinueVolumeRamping()
	
	-- TODO: create packet/command to send to the device
	local command = CMDS["SET_VOLUME_LEVEL"] .. deviceVolumeLevel
	
	LogTrace("command = " .. command)
	local command_delay = tonumber(Properties["Volume Ramp Delay Milliseconds"])
	PackAndQueueCommand("SET_VOLUME_LEVEL_DEVICE", command, command_delay)
end

--[[
	Proxy Command: PULSE_VOL_DOWN
	Parameters:
		output: mod 1000 value of Output Connection id	
--]]
function PULSE_VOL_DOWN()
	local command
	if (gControlMethod == "IR") then		
		-- TODO: create packet/command to send to the device
		command = CMDS_IR["PULSE_VOL_DOWN"]	
	else
		-- TODO: create packet/command to send to the device
		command = CMDS["PULSE_VOL_DOWN"]
	end 		
	LogTrace("command = " .. command)
	local command_delay = tonumber(Properties["Volume Ramp Delay Milliseconds"])
	PackAndQueueCommand("PULSE_VOL_DOWN", command, command_delay)
end

--[[
	Proxy Command: PULSE_VOL_UP
	Parameters:
		output: mod 1000 value of Output Connection id	
--]]
function PULSE_VOL_UP()
	local command
	if (gControlMethod == "IR") then	
		-- TODO: create packet/command to send to the device
		command = CMDS_IR["PULSE_VOL_UP"]	
	else
		-- TODO: create packet/command to send to the device
		command = CMDS["PULSE_VOL_UP"]
	end 		
	LogTrace("command = " .. command)
	local command_delay = tonumber(Properties["Volume Ramp Delay Milliseconds"])
	PackAndQueueCommand("PULSE_VOL_UP", command, command_delay)
end


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Tuner Proxy Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

function SET_CHANNEL(idBinding, channel)
	if (gControlMethod == "IR") then	
		-- TODO: create packet/command to send to the device (if a Direct Tuner command is needed, map it to a remote button like "STAR")
		--SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, output, "STAR")
		for i=1,string.len(channel) do
		  local c = string.sub(channel,i,i)
		  if (string.find(c, "%D")) then
			-- TODO: change delimiter command below if it is not a DOT...
			 SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "DOT")
		  else
			 SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, "NUMBER_" .. c)
		  end
		end
	else
		-- TODO: create packet/command to send to the device
		local command = CMDS["SET_CHANNEL"] .. channel
		LogTrace("command = " .. command)
		PackAndQueueCommand("SET_CHANNEL", command)		
	end
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Helper Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

--[[
	Helper Function: SEND_COMMAND_FROM_COMMAND_TABLE
	Parameters:
		idBinding: proxy id	
		output: mod 1000 value of Output Connection id
		command_name: name of command to be sent
--]]
function SEND_COMMAND_FROM_COMMAND_TABLE(idBinding, command_name)
    LogTrace("SEND_COMMAND_FROM_COMMAND_TABLE(), idBinding=" .. idBinding .. ", command_name=" .. command_name)
	
	-- TODO: create packet/command to send to the device
	local command = GetCommandFromCommandTable(idBinding, command_name)
	
	if (command == nil) then
		LogTrace("command is nil")
	else
		LogTrace("command = " .. command)
		PackAndQueueCommand(command_name, command)
	end			
end

--[[
	Helper Function: GetCommandFromCommandTable
	Parameters:
		idBinding: proxy id	
		output: mod 1000 value of Output Connection id
		command_name: name of command to be returned
--]]
function GetCommandFromCommandTable(idBinding, command_name)
	LogTrace("GetCommand()")
	local t = {}
	
	-- TODO: create appropriate commands table structure
	
	if (gControlMethod == "IR") then
		t = CMDS_IR
	else
		t = CMDS
	end	

	if (t[idBinding] ~= nil) then
	   if (t[idBinding][command_name] ~= nil) then
		  return t[idBinding][command_name]
	   end
	end
	
	if (t[command_name] ~= nil) then
		return t[command_name]
	else
		LogWarn('GetCommandFromCommandTable: command not defined - '.. command_name)
		return nil
	end	
	
end

--[[
	Helper Function: GetDeviceVolumeStatus
--]]
function GetDeviceVolumeStatus()
    LOG:Trace("GetDeviceVolumeStatus()")
	
	-- TODO: verify table entry in Volume in QUERY table
	local command = CMDS["GET_VOLUME_STATUS"]
	LOG:Trace("command = " .. command)
	PackAndQueueCommand("GetDeviceVolumeStatus: Volume", command)
	
	-- TODO: verify table entry in Mute in QUERY table
	command = CMDS["GET_MUTE_STATUS"]
	LOG:Trace("command = " .. command)
	PackAndQueueCommand("GetDeviceVolumeStatus: Mute", command)	
end

--[[
	Helper Function: GetDevicePowerStatus
--]]
function GetDevicePowerStatus()
    LOG:Trace("GetDevicePowerStatus()")
	
	-- TODO: verify table entry in Volume in QUERY table
	local command = CMDS["GET_POWER_STATUS"]
	LOG:Trace("command = " .. command)
	PackAndQueueCommand("GetDevicePowerStatus: Volume", command)	
end
	