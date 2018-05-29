set_global_assignment -entity "klokje" -library "lib_klokje" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "klokje" -library "lib_klokje" -name IP_TOOL_VERSION "16.1"
set_global_assignment -entity "klokje" -library "lib_klokje" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_klokje" -name SPD_FILE [file join $::quartus(sip_path) "klokje.spd"]

set_global_assignment -library "lib_klokje" -name MISC_FILE [file join $::quartus(sip_path) "klokje_sim/klokje.vo"]
