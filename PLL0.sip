set_global_assignment -entity "PLL0" -library "lib_PLL0" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL0" -library "lib_PLL0" -name IP_TOOL_VERSION "16.0"
set_global_assignment -entity "PLL0" -library "lib_PLL0" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL0" -name SPD_FILE [file join $::quartus(sip_path) "PLL0.spd"]

set_global_assignment -library "lib_PLL0" -name MISC_FILE [file join $::quartus(sip_path) "PLL0_sim/PLL0.vo"]
