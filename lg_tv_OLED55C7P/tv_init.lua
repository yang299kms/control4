--[[=============================================================================
    TV Protocol Initialization Functions

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_messages = "2015.03.31"
end


PROTOCOL_DECLARATIONS = {}

function ON_DRIVER_EARLY_INIT.tv_init()

end

function ON_DRIVER_INIT.tv_init()
	--LogTrace("ON_DRIVER_INIT.ProtocolDeclarations()")
	for k,v in pairs(PROTOCOL_DECLARATIONS) do
		if (PROTOCOL_DECLARATIONS[k] ~= nil and type(PROTOCOL_DECLARATIONS[k]) == "function") then
			PROTOCOL_DECLARATIONS[k]()
		end
	end	
end

function ON_DRIVER_LATEINIT.tv_init()

end
	
function PROTOCOL_DECLARATIONS.CommandsTableInit_IR()
	LogTrace("PROTOCOL_DECLARATIONS.CommandsTableInit_IR()")

	CMDS_IR = {
		--index:  Proxy Command Name
		--value:  IR Code ID	 
		--Power
		["ON"]             = "",
		["OFF"]            = "",
		
		--Input Toggle
		["INPUT_TOGGLE"]="",
		["TV_VIDEO"]=		"",
		
		--Menu
		["INFO"] = "",	--Display
		["GUIDE"] = "",
		["MENU"] = "",
		["CANCEL"] = "",
		["UP"] = "",
		["DOWN"] = "",
		["LEFT"] = "",
		["RIGHT"] = "",
		["ENTER"] = "",	
		["RECALL"]         = "",
		["PREV"]           = "",
		
		--Digits
		["NUMBER_0"]       = "", 	
		["NUMBER_1"]       = "",		
		["NUMBER_2"]       = "",	
		["NUMBER_3"]       = "",	
		["NUMBER_4"]       = "",	
		["NUMBER_5"]       = "",	
		["NUMBER_6"]       = "",	
		["NUMBER_7"]       = "",	
		["NUMBER_8"]       = "",	
		["NUMBER_9"]       = "",
		["STAR"]           = "",
		["DOT"]            = "",
		
		--Volume
		["MUTE_ON"]        = "",
		["MUTE_OFF"]       = "",
		["MUTE_TOGGLE"]    = "",		
		["PULSE_VOL_DOWN"] = "",
		["PULSE_VOL_UP"]   = "",		
		["SET_VOLUME_LEVEL"] = "",		

		--Tuning
		["SET_CHANNEL"]="",
		["PULSE_CH_UP"]="",
		["START_CH_UP"]="",		
		["SKIP_FWD"]="",		--used for PULSE_CH_UP in some Navigators	
		["SCAN_FWD"]="",		--used for PULSE_CH_UP in some Navigators
		["PULSE_CH_DOWN"]="",	
		["START_CH_DOWN"]="",	
		["SKIP_REV"]="",		--used for PULSE_CH_DOWN in some Navigators
		["SCAN_REV"]="",		--used for PULSE_CH_DOWN in some Navigators						
	}			
	
	CMDS_IR[TV_PROXY_BINDINGID] = {}	
	
	CMDS_IR[MEDIA_PROXY_BINDINGID] = {
		--these entries are only required if 
		--specific command strings are required for the Media Player
	--[[	
		--Transport
		["PLAY"]="",
		["STOP"]="",
		["PAUSE"]="",
		["SKIP_FWD"]="",		
		["SCAN_FWD"]="",		
		["SKIP_REV"]="",		
		["SCAN_REV"]="",			
		
		--Menu
		["INFO"] = "",	--Display
		["GUIDE"] = "",
		["MENU"] = "",
		["CANCEL"] = "",
		["UP"] = "",
		["DOWN"] = "",
		["LEFT"] = "",
		["RIGHT"] = "",
		["ENTER"] = "",	
		["RECALL"]         = "",
		["PREV"]           = "",		
		
		--Keypad
		["STAR"]="TAC",
		["NUMBER_0"]="", 	
		["NUMBER_1"]="",	
		["NUMBER_2"]="",	
		["NUMBER_3"]="",	
		["NUMBER_4"]="",	
		["NUMBER_5"]="",	
		["NUMBER_6"]="",	
		["NUMBER_7"]="",	
		["NUMBER_8"]="",	
		["NUMBER_9"]="",
	--]]	
	}		
end

function PROTOCOL_DECLARATIONS.CommandsTableInit_Serial()
	LogTrace("PROTOCOL_DECLARATIONS.CommandsTableInit_Serial()")

	CMDS = {
		--index:  Proxy Command Name
		--value:  Protocol Command Data
		
		--Power
		["ON"]             = "",
		["OFF"]            = "POWER off",
		
		--Input Toggle
		["INPUT_TOGGLE"]="KEY_ACTION deviceinput",
		["TV_VIDEO"]=		"",
		
		--Menu
		["INFO"] = "KEY_ACTION programinfo",	--Display
		["GUIDE"] = "KEY_ACTION userguide",
		["MENU"] = "KEY_ACTION settingmenu",
		["CANCEL"] = "KEY_ACTION exit",
		["UP"] = "KEY_ACTION arrowup",
		["DOWN"] = "KEY_ACTION arrowdown",
		["LEFT"] = "KEY_ACTION arrowleft",
		["RIGHT"] = "KEY_ACTION arrowright",
		["ENTER"] = "KEY_ACTION ok",	
		["RECALL"]         = "",
		["PREV"]           = "KEY_ACTION returnback",
		
		--Digits
		["NUMBER_0"]       = "KEY_ACTION number0", 	
		["NUMBER_1"]       = "KEY_ACTION number1",		
		["NUMBER_2"]       = "KEY_ACTION number2",	
		["NUMBER_3"]       = "KEY_ACTION number3",	
		["NUMBER_4"]       = "KEY_ACTION number4",	
		["NUMBER_5"]       = "KEY_ACTION number5",	
		["NUMBER_6"]       = "KEY_ACTION number6",	
		["NUMBER_7"]       = "KEY_ACTION number7",	
		["NUMBER_8"]       = "KEY_ACTION number8",	
		["NUMBER_9"]       = "KEY_ACTION number9",
		["STAR"]           = "",
		["DOT"]            = "",
		
		--Volume
		["MUTE_ON"]        = "VOLUME_MUTE on",
		["MUTE_OFF"]       = "VOLUME_MUTE off",
		["MUTE_TOGGLE"]    = "KEY_ACTION volumemute",	
		["PULSE_VOL_DOWN"] = "KEY_ACTION volumedown",
		["PULSE_VOL_UP"]   = "KEY_ACTION volumeup",		
		["SET_VOLUME_LEVEL"] = "VOLUME_CONTROL ",		

		--Tuning
		["SET_CHANNEL"]="",
		["PULSE_CH_UP"]="KEY_ACTION channelup",
		["START_CH_UP"]="",		
		["SKIP_FWD"]="",		--used for PULSE_CH_UP in some Navigators	
		["SCAN_FWD"]="",		--used for PULSE_CH_UP in some Navigators
		["PULSE_CH_DOWN"]="KEY_ACTION channeldown",	
		["START_CH_DOWN"]="",	
		["SKIP_REV"]="",		--used for PULSE_CH_DOWN in some Navigators
		["SCAN_REV"]="",		--used for PULSE_CH_DOWN in some Navigators	
		
		--Status Query
		["GET_VOLUME_STATUS"]="",
		["GET_MUTE_STATUS"]="",
		["GET_POWER_STATUS"]="",
		
	}
	
	CMDS[TV_PROXY_BINDINGID] = {}
	
	CMDS[MEDIA_PROXY_BINDINGID] = {
		--these entries are only required if 
		--specific command strings are required for the Media Player
	--[[	
		--Transport
		["PLAY"]="",
		["STOP"]="",
		["PAUSE"]="",
		["SKIP_FWD"]="",		
		["SCAN_FWD"]="",		
		["SKIP_REV"]="",		
		["SCAN_REV"]="",			
		
		--Menu
		["INFO"] = "",	--Display
		["GUIDE"] = "",
		["MENU"] = "",
		["CANCEL"] = "",
		["UP"] = "",
		["DOWN"] = "",
		["LEFT"] = "",
		["RIGHT"] = "",
		["ENTER"] = "",	
		["RECALL"]         = "",
		["PREV"]           = "",		
		
		--Keypad
		["STAR"]="TAC",
		["NUMBER_0"]="", 	
		["NUMBER_1"]="",	
		["NUMBER_2"]="",	
		["NUMBER_3"]="",	
		["NUMBER_4"]="",	
		["NUMBER_5"]="",	
		["NUMBER_6"]="",	
		["NUMBER_7"]="",	
		["NUMBER_8"]="",	
		["NUMBER_9"]="",
	--]]	
	}	
	
end

function PROTOCOL_DECLARATIONS.InputOutputTableInit()
	LogTrace("PROTOCOL_DECLARATIONS.InputOutputTableInit()")
	----------------------------------------- [*COMMAND/RESPONSE HELPER TABLES*] -----------------------------------------
	tInputCommandMap = {
		--index:  Connection Name
		--value:  Protocol Command Data	
		--["ADAPTER PORT"] = "33", 
		["HDMI 1"] = "INPUT_SELECT hdmi1",
		["HDMI 2"] = "INPUT_SELECT hdmi2",
		["HDMI 3"] = "INPUT_SELECT hdmi3",
		["DTV"] = "INPUT_SELECT dtv",
		["ATV"] = "INPUT_SELECT atv",
		["CADTV"] = "INPUT_SELECT cadtv",
		["CATV"] = "INPUT_SELECT catv",
		["AVAV1"] = "INPUT_SELECT avav1",
		["COMPONENT 1"] = "INPUT_SELECT component1",
	}
	
	tInputResponseMap = ReverseTable(tInputCommandMap)	-- Reverses the tInputCommandMap table	
	
	tInputCommandMap_IR = { 
		--index:  Connection Name
		--value:  IR Code ID
		--["ADAPTER PORT"] = "51362",
		[""] = "",	
	}

	----------------------------------------- [*I/O HELPER TABLES*] -----------------------------------------
	tOutputConnMap = {
		--index:  mod 1000 value of Output Connection id
		--value:  Output Connection Name
		[0] = "Main Output",
	}

	tInputConnMapByID = {
		--index:  mod 1000 value of Input Connection id
		--[0] = {Name = "INPUT HDMI 1",BindingID = TV_PROXY_BINDINGID,},
		--The first two entries below are for the antenna connections which are bound to the tuner proxy; the in values will need to be updated base on the connection ID.
		[0] = {Name = "",BindingID = TV_PROXY_BINDINGID,},
		[22] = {Name = "HDMI 2", BindingID = TV_PROXY_BINDINGID,},
	}
	
	tInputConnMapByName = {
		--index:  Input Connection Name
		--ID: mod 1000 value of Input Connection id
		--["INPUT HDMI 1"] = {ID = 0,BindingID = TV_PROXY_BINDINGID,},
		[""] = {ID = 0,BindingID = TV_PROXY_BINDINGID,},
	}

end	

function PROTOCOL_DECLARATIONS.PowerCommandsTableInit_Serial()
	LogTrace("PROTOCOL_DECLARATIONS.PowerCommandsTableInit_Serial()")
	
end

function ReverseTable(a)
	local b = {}
	for k,v in pairs(a) do b[v] = k end
	return b
end

