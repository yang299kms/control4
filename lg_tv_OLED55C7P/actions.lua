--[[=============================================================================
    Lua Action Code

    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.actions = "2016.01.08"
end

-- TODO: Create a function for each action defined in the driver

function LUA_ACTION.TemplateVersion()
	TemplateVersion()
end


function LUA_ACTION.PrintVolumeCurve()
    print("===== Volume Curve =====")
    --for j,k in pairs(tVolumeCurve) do
	--   print(j,k)
    --end
end

function LUA_ACTION.SendWOL()
    print("===== SendWOL =====")
    --local MAC = Properties["Ethernet MAC"]
    --MAC = MAC:gsub(":", "") -- Remove any colons in the entered MAC addresses 
    --MAC = tohex(MAC) -- Convert to HEX 
    --packet = string.rep(string.char(255), 6) .. string.rep(MAC, 16) -- Build 'magic packet'. 
    --hexdump(packet)
    --C4:SendBroadcast(packet,9)
    ON()
    if(not gCon._IsOnline) then 
     C4:NetConnect(NETWORK_BINDING_ID, NETWORK_PORT, "TCP")
    end
end

function LUA_ACTION.SendOFF()
    print("===== SendOFF =====")
    --if (gIsNetworkConnected and (gCon ~= nil and gCon._is then
    if (gCon._IsOnline) then
	   OFF()
    else
	   print("network not connected....connecting")
	   C4:NetConnect(NETWORK_BINDING_ID, NETWORK_PORT, "TCP")
    end
end

function LUA_ACTION.GetMAC()
    local MAC = C4:GetDeviceMAC(NETWORK_BINDING_ID)
    LogDebug("MAC Address = " .. MAC)
    if(MAC ~= nil) then
     UpdateProperty("Ethernet MAC", MAC)
    end
end

function LUA_ACTION.SendInput()
    LogInfo("SendInput")
    PackAndQueueCommand("SELECT_INPUT", "INPUT_SELECT hdmi2", 2, "SECONDS")
end