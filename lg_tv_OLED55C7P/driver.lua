--[[=============================================================================
    Basic Template for TV Driver

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]------------
require "common.c4_driver_declarations"
require "common.c4_common"
require "common.c4_init"
require "common.c4_property"
require "common.c4_command"
require "common.c4_notify"
require "common.c4_network_connection"
require "common.c4_serial_connection"
require "common.c4_ir_connection"
require "common.c4_utils"
require "lib.c4_timer"
require "actions"
require "device_specific_commands"
require "device_messages"
require "tv_init"
require "properties"
require "proxy_commands"
require "connections"
require "tv.tv_proxy_class"
require "tv.tv_proxy_commands"
require "tv.tv_proxy_notifies"


-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.driver = "2015.03.31"
end

--[[=============================================================================
    Constants
===============================================================================]]
TV_PROXY_BINDINGID = 5001
MEDIA_PROXY_BINDINGID = 5002

--[[
    Device Volume Range
    TODO: edit "MIN_DEVICE_LEVEL" & "MAX_DEVICE_LEVEL" values based upon the protocol specification for volume range.
    If zones have volume ranges that vary, convert these constants into a table indexed by the mod value of the output connection 
    and then update all references to handle the table structure.
--]]
MIN_DEVICE_LEVEL = 0
MAX_DEVICE_LEVEL = 100	


--[[=============================================================================
    Initialization Code
===============================================================================]]
function ON_DRIVER_EARLY_INIT.main()
	
end

function ON_DRIVER_INIT.main()

	-- TODO: If cloud based driver then uncomment the following line
	--ConnectURL()
end

function ON_DRIVER_LATEINIT.main()
	C4:urlSetTimeout(20)
	DRIVER_NAME = C4:GetDriverConfigInfo("name")
	
	SetLogName(DRIVER_NAME)
end

function ON_DRIVER_EARLY_INIT.tv_driver()

end

function ON_DRIVER_INIT.tv_driver()
    -- TODO: Modify tVolumeRamping to have on entry per Output connection
    --index is mod 1000 value of output connection
    local tVolumeRamping = {["state"] = false, ["mode"] = ""}
	
    -- Create an instance of the TV Proxy class
    -- TODO: Change bProcessesDeviceMessages to false if Device Messages will not be processes
    local  bProcessesDeviceMessages = true
    local bUsePulseCommandsForVolumeRamping = false
    if (Properties["Ramping Method"] == "Pulse Commands") then bUsePulseCommandsForVolumeRamping = true end
    gTVProxy = TVProxy:new(TV_PROXY_BINDINGID,  bProcessesDeviceMessages, tVolumeRamping, bUsePulseCommandsForVolumeRamping)
	
    local minDeviceLevel = MIN_DEVICE_LEVEL
    local maxDeviceLevel = MAX_DEVICE_LEVEL
    tVolumeCurve = getVolumeCurve(minDeviceLevel, maxDeviceLevel)
	
	--[[
	For the "Volume Curve" method, tVolumeCurve is used to store volume level values that will be used to build volume commands during volume ramping. Specifically, they are used in GetNextVolumeCurveValue() which is called from the ContinueVolumeRamping() function.  Property values for "Volume Ramping Steps" and "Volume Ramping Slope" can be adjusted to get a smooth volume ramping from low to high volume.
	--]]
end

function getVolumeCurve(minDeviceLevel, maxDeviceLevel)
    local steps = tonumber(Properties["Volume Ramp Steps"])
    local slope = tonumber(Properties["Volume Ramp Slope"])
    local tCurve = gTVProxy:CreateVolumeCurve(steps, slope, minDeviceLevel, maxDeviceLevel)
    
    return tCurve 
end

function ON_DRIVER_LATEINIT.tv_driver()

end

--[[=============================================================================
    Driver Code
===============================================================================]]
function PackAndQueueCommand(...)
    local command_name = select(1, ...) or ""
    local command = select(2, ...) or ""
    local command_delay = select(3, ...) or tonumber(Properties["Command Delay Milliseconds"])
    local delay_units = select(4, ...) or "MILLISECONDS"
    LogTrace("PackAndQueueCommand(), command_name = " .. command_name .. ", command delay set to " .. command_delay .. " " .. delay_units)
    if (command == "") then
	   LogWarn("PackAndQueueCommand(), command_name = " .. command_name .. ", command string is empty - exiting PackAndQueueCommand()")
	   return
    end
	
	-- TODO: pack command with any any required starting or ending characters
    local cmd, stx, etx
    if (gControlMethod == "Network") then
		-- TODO: define any required starting or ending characters. 
		stx = ""
		--etx = "\r"
		etx = ""
		cmd = stx .. command .. etx
    elseif (gControlMethod == "Serial") then
		-- TODO: define any required starting or ending characters. 
		stx = ""
		etx = "\r"
		cmd = stx .. command .. etx
    elseif (gControlMethod == "IR") then
		cmd = command
    else
		LogWarn("PackAndQueueCommand(): gControlMethod is not valid, ".. gControlMethod)
		return
    end
    gCon:QueueCommand(cmd, command_delay, delay_units, command_name)	
	
end

function NetworkCheck() 
    return false
end