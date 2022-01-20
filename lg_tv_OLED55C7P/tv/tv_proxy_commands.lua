--[[=============================================================================
    ReceivedFromProxy Code for the TV Proxy

    Copyright 2015 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.properties = "2015.03.31"
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Power Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function PRX_CMD.ON(idBinding, tParams)
	gTVProxy:prx_ON(tParams)
end

function PRX_CMD.OFF(idBinding, tParams)
	gTVProxy:prx_OFF(tParams)
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Input Selection Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function PRX_CMD.SET_INPUT(idBinding, tParams)
	gTVProxy:prx_SET_INPUT(idBinding, tParams)
end

function PRX_CMD.TV_VIDEO(idBinding, tParams)
	gTVProxy:prx_TV_VIDEO(idBinding, tParams)
end

function PRX_CMD.INPUT_TOGGLE(idBinding, tParams)
	gTVProxy:prx_INPUT_TOGGLE(idBinding, tParams)
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Volume Control Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function PRX_CMD.MUTE_OFF(idBinding, tParams)
	gTVProxy:prx_MUTE_OFF(tParams)
end

function PRX_CMD.MUTE_ON(idBinding, tParams)
	gTVProxy:prx_MUTE_ON(tParams)	
end

function PRX_CMD.MUTE_TOGGLE(idBinding, tParams)
	gTVProxy:prx_MUTE_TOGGLE(tParams)
end

function PRX_CMD.SET_VOLUME_LEVEL(idBinding, tParams)
	gTVProxy:prx_SET_VOLUME_LEVEL(tParams)
end

function PRX_CMD.PULSE_VOL_DOWN(idBinding, tParams)
	gTVProxy:prx_PULSE_VOL_DOWN(tParams)
end

function PRX_CMD.PULSE_VOL_UP(idBinding, tParams)
	gTVProxy:prx_PULSE_VOL_UP(tParams)
end

function PRX_CMD.START_VOL_DOWN(idBinding, tParams)
	gTVProxy:prx_START_VOL_DOWN(tParams)
end

function PRX_CMD.START_VOL_UP(idBinding, tParams)
	gTVProxy:prx_START_VOL_UP(tParams)
end

function PRX_CMD.STOP_VOL_DOWN(idBinding, tParams)
	gTVProxy:prx_STOP_VOL_DOWN(tParams)
end

function PRX_CMD.STOP_VOL_UP(idBinding, tParams)
	gTVProxy:prx_STOP_VOL_UP(tParams)
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Menu Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function PRX_CMD.INFO(idBinding, tParams)
	gTVProxy:prx_INFO(idBinding, tParams)
end

function PRX_CMD.GUIDE(idBinding, tParams)
	gTVProxy:prx_GUIDE(idBinding, tParams)
end

function PRX_CMD.MENU(idBinding, tParams)
	gTVProxy:prx_MENU(idBinding, tParams)
end

function PRX_CMD.CANCEL(idBinding, tParams)
	gTVProxy:prx_CANCEL(idBinding, tParams)
end

function PRX_CMD.UP(idBinding, tParams)
	gTVProxy:prx_UP(idBinding, tParams)
end

function PRX_CMD.DOWN(idBinding, tParams)
	gTVProxy:prx_DOWN(idBinding, tParams)
end

function PRX_CMD.LEFT(idBinding, tParams)
	gTVProxy:prx_LEFT(idBinding, tParams)
end

function PRX_CMD.RIGHT(idBinding, tParams)
	gTVProxy:prx_RIGHT(idBinding, tParams)
end

function PRX_CMD.START_DOWN(idBinding, tParams)
	gTVProxy:prx_START_DOWN(idBinding, tParams)
end

function PRX_CMD.START_UP(idBinding, tParams)
	gTVProxy:prx_START_UP(idBinding, tParams)
end

function PRX_CMD.START_LEFT(idBinding, tParams)
	gTVProxy:prx_START_LEFT(idBinding, tParams)
end

function PRX_CMD.START_RIGHT(idBinding, tParams)
	gTVProxy:prx_START_RIGHT(idBinding, tParams)
end

function PRX_CMD.STOP_DOWN(idBinding, tParams)
	gTVProxy:prx_STOP_DOWN(idBinding, tParams)
end

function PRX_CMD.STOP_UP(idBinding, tParams)
	gTVProxy:prx_STOP_UP(idBinding, tParams)
end

function PRX_CMD.STOP_LEFT(idBinding, tParams)
	gTVProxy:prx_STOP_LEFT(idBinding, tParams)
end

function PRX_CMD.STOP_RIGHT(idBinding, tParams)
	gTVProxy:prx_STOP_RIGHT(idBinding, tParams)
end

function PRX_CMD.ENTER(idBinding, tParams)
	gTVProxy:prx_ENTER(idBinding, tParams)
end

function PRX_CMD.RECALL(idBinding, tParams)
	gTVProxy:prx_RECALL(idBinding, tParams)
end

function PRX_CMD.OPEN_CLOSE(idBinding, tParams)
	gTVProxy:prx_OPEN_CLOSE(idBinding, tParams)
end

function PRX_CMD.PROGRAM_A(idBinding, tParams)
	gTVProxy:prx_PROGRAM_A(idBinding, tParams)
end

function PRX_CMD.PROGRAM_B(idBinding, tParams)
	gTVProxy:prx_PROGRAM_B(idBinding, tParams)
end

function PRX_CMD.PROGRAM_C(idBinding, tParams)
	gTVProxy:prx_PROGRAM_C(idBinding, tParams)
end

function PRX_CMD.PROGRAM_D(idBinding, tParams)
	gTVProxy:prx_PROGRAM_D(idBinding, tParams)
end

function PRX_CMD.CLOSED_CAPTIONED(idBinding, tParams)
	gTVProxy:prx_CLOSED_CAPTIONED(idBinding, tParams)
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Digit Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function PRX_CMD.NUMBER_0(idBinding, tParams)
	gTVProxy:prx_NUMBER_0(idBinding, tParams)
end

function PRX_CMD.NUMBER_1(idBinding, tParams)
	gTVProxy:prx_NUMBER_1(idBinding, tParams)
end

function PRX_CMD.NUMBER_2(idBinding, tParams)
	gTVProxy:prx_NUMBER_2(idBinding, tParams)
end

function PRX_CMD.NUMBER_3(idBinding, tParams)
	gTVProxy:prx_NUMBER_3(idBinding, tParams)
end

function PRX_CMD.NUMBER_4(idBinding, tParams)
	gTVProxy:prx_NUMBER_4(idBinding, tParams)
end

function PRX_CMD.NUMBER_5(idBinding, tParams)
	gTVProxy:prx_NUMBER_5(idBinding, tParams)
end

function PRX_CMD.NUMBER_6(idBinding, tParams)
	gTVProxy:prx_NUMBER_6(idBinding, tParams)
end

function PRX_CMD.NUMBER_7(idBinding, tParams)
	gTVProxy:prx_NUMBER_7(idBinding, tParams)
end

function PRX_CMD.NUMBER_8(idBinding, tParams)
	gTVProxy:prx_NUMBER_8(idBinding, tParams)
end

function PRX_CMD.NUMBER_9(idBinding, tParams)
	gTVProxy:prx_NUMBER_9(idBinding, tParams)
end

function PRX_CMD.STAR(idBinding, tParams)
	gTVProxy:prx_STAR(idBinding, tParams)
end

function PRX_CMD.POUND(idBinding, tParams)
	gTVProxy:prx_POUND(idBinding, tParams)
end

function PRX_CMD.HYPHEN(idBinding, tParams)
	gTVProxy:prx_HYPHEN(idBinding, tParams)
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Tuner Proxy Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function PRX_CMD.PULSE_CH_UP(idBinding, tParams)
	gTVProxy:prx_PULSE_CH_UP(idBinding, tParams)
end

function PRX_CMD.START_CH_UP(idBinding, tParams)
	gTVProxy:prx_START_CH_UP(idBinding, tParams)
end

function PRX_CMD.PULSE_CH_DOWN(idBinding, tParams)
	gTVProxy:prx_PULSE_CH_DOWN(idBinding, tParams)
end

function PRX_CMD.START_CH_DOWN(idBinding, tParams)
	gTVProxy:prx_START_CH_DOWN(idBinding, tParams)
end

function PRX_CMD.SET_CHANNEL(idBinding, tParams)
	gTVProxy:prx_SET_CHANNEL(idBinding, tParams)
end

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- Transport Navigation Functions
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
function PRX_CMD.PLAY(idBinding, tParams)
	gTVProxy:prx_PLAY(idBinding, tParams)
end
	
function PRX_CMD.PAUSE(idBinding, tParams)
	gTVProxy:prx_PAUSE(idBinding, tParams)
end

function PRX_CMD.STOP(idBinding, tParams)
	gTVProxy:prx_STOP(idBinding, tParams)
end

function PRX_CMD.SKIP_REV(idBinding, tParams)
	gTVProxy:prx_SKIP_REV(idBinding, tParams)
end

function PRX_CMD.SKIP_FWD(idBinding, tParams)
	gTVProxy:prx_SKIP_FWD(idBinding, tParams)
end

function PRX_CMD.SCAN_REV(idBinding, tParams)
	gTVProxy:prx_SCAN_REV(idBinding, tParams)
end

function PRX_CMD.SCAN_FWD(idBinding, tParams)
	gTVProxy:prx_SCAN_FWD(idBinding, tParams)
end
