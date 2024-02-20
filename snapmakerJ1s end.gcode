G92 E0

G0 Z{max_layer_z + 0.5} F6000
; retract the filament to make it easier to replace
;G0 E-40 F200 ; I probably have clogging issues because of that retraction 
G28

    {if is_extruder_used[0]}M104 T0 S0{endif}
    {if is_extruder_used[1]}M104 T1 S0{endif}
M140 S0
M107
M220 S100 ;Set the global feedrate percentage.
M84 ;Disable steppers

;
; DON'T REMOVE these lines if you're using the smfix (https://github.com/macdylan/SMFix)
; min_x = [first_layer_print_min_0]
; min_y = [first_layer_print_min_1]
; max_x = [first_layer_print_max_0]
; max_y = [first_layer_print_max_1]
; max_z = [max_layer_z]
; total_layer_number = [layer_num]
;