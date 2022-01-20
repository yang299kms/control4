--[[=============================================================================
    Functions for managing the status of the drivers bindings and connection state
 
    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "common.c4_network_connection"
require "common.c4_serial_connection"
require "common.c4_ir_connection"
require "common.c4_url_connection"

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.connections = "2015.03.31"
end

-- constants
COM_USE_ACK = false
COM_COMMAND_DELAY_MILLISECONDS = 250
COM_COMMAND_RESPONSE_TIMEOUT_SECONDS = 4

NETWORK_PORT = 9761
IR_BINDING_ID = 2
SERIAL_BINDING_ID = 1
NETWORK_BINDING_ID = 6001

--[[=============================================================================
    OnSerialConnectionChanged(idBinding, class, bIsBound)
  
    Description:
    Function called when a serial binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed (SERIAL_BINDING_ID).
    class(string)  - Class of binding that has changed.
                     A single binding can have multiple classes(i.e. COMPONENT,
                     STEREO, RS_232, etc).
                     This indicates which has been bound or unbound.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnSerialConnectionChanged(idBinding, class, bIsBound)
	
end

--[[=============================================================================
    OnIRConnectionChanged(idBinding, class, bIsBound)
  
    Description:
    Function called when an IR binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed (SERIAL_BINDING_ID).
    class(string)  - Class of binding that has changed.
                     A single binding can have multiple classes(i.e. COMPONENT,
                     STEREO, RS_232, etc).
                     This indicates which has been bound or unbound.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnIRConnectionChanged(idBinding, class, bIsBound)
	
end

--[[=============================================================================
    OnNetworkConnectionChanged(idBinding, bIsBound)
  
    Description:
    Function called when a network binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnNetworkConnectionChanged(idBinding, bIsBound)
	
end

--[[=============================================================================
    OnNetworkStatusChanged(idBinding, nPort, sStatus)
  
    Description:
    Called when the network connection status changes. Sets the updated status of the specified binding
  
    Parameters:
    idBinding(int)  - ID of the binding whose status has changed
    nPort(int)      - The communication port of the specified bindings connection
    sStatus(string) - "ONLINE" if the connection status is to be set to Online,
                      any other value will set the status to Offline
  
    Returns:
    None
===============================================================================]]
function OnNetworkStatusChanged(idBinding, nPort, sStatus)
    --if (idBinding == 6001) then 
	--   if (sStatus == "ONLINE") then
	--	  LogDebug("6001 -- ONLINE -- Setting control method to Network")
	--	  gIsNetworkConnected = true
	--	  SetControlMethod()
	--	  --local cmd = 'POWER off'
	--	  --C4:SendToNetwork (6001, NETWORK_PORT, cmd)
	--   else
	--	  gIsNetworkConnected = false
	--	  SetOnlineStatus(false)
	--   end
    --end

end

--[[=============================================================================
    OnURLConnectionChanged(url)
  
    Description:
    Function called when the c4_url_connection is created.
  
    Parameters:
    url - url used by the url connection.
  
    Returns:
    None
===============================================================================]]
function OnURLConnectionChanged(url)
	
end

--[[=============================================================================
    DoEvents()
  
    Description:
    Called from OnSendTimeExpired in the DeviceConnectionBase.
  
    Parameters:
    None
  
    Returns:
    None
===============================================================================]]
function DoEvents()
	if (gTVProxy._VolumeIsRamping == true) then
		if (gTVProxy._VolumeRamping.state == true) then gTVProxy:ContinueVolumeRamping() end
	end
	
	if (gTVProxy._MenuNavigationInProgress == true) then
	   SEND_COMMAND_FROM_COMMAND_TABLE(gTVProxy._MenuNavigationProxyID, gTVProxy._MenuNavigationMode)
	end		
end

--[[=============================================================================
    SendKeepAlivePollingCommand()
  
    Description:
    Sends a driver specific polling command to the connected system
  
    Parameters:
    None
  
    Returns:
    None
===============================================================================]]
function SendKeepAlivePollingCommand()
    LogTrace("SendKeepAlivePollingCommand()")
	
	--TODO: set keep alive command for the network connected system if required.
    local command = "KEEP_ALIVE"  --"DIMQSTN"
    LogTrace("command = " .. command)
    PackAndQueueCommand("SendKeepAlivePollingCommand", command)		
end
