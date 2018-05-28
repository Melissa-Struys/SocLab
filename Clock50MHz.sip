set_global_assignment -entity "Clock50MHz" -library "lib_Clock50MHz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "Clock50MHz" -library "lib_Clock50MHz" -name IP_TOOL_VERSION "16.1"
set_global_assignment -entity "Clock50MHz" -library "lib_Clock50MHz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_Clock50MHz" -name SPD_FILE [file join $::quartus(sip_path) "Clock50MHz.spd"]

set_global_assignment -library "lib_Clock50MHz" -name MISC_FILE [file join $::quartus(sip_path) "Clock50MHz_sim/Clock50MHz.vo"]
