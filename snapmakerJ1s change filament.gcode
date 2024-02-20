;***** Update: 20230730
{if current_extruder != next_extruder}
; Change T[current_extruder] -> T[next_extruder] (layer [layer_num]
; layer
T{next_extruder}

M107 P[current_extruder] ;fan off T[current_extruder]
; do not lower temperture  for the next fast switching
;M104 T[current_extruder] S{temperature_vitrification[current_extruder]} ;standby T[current_extruder]

{if layer_num == 1 && 
((filament_type[current_extruder] == "PLA" || filament_type[current_extruder] == "TPU")
|| (filament_type[next_extruder] == "PLA" || filament_type[next_extruder] == "TPU"))}
  ; set bed temp: {filament_type[current_extruder]}({bed_temperature[current_extruder]}) -> {filament_type[next_extruder]}({bed_temperature[next_extruder]})
  M140 S{min(bed_temperature[current_extruder], bed_temperature[next_extruder])}
{endif}

M2000 S200 V[travel_speed] A[travel_acceleration] ;quick switch extruders, S:200 mode/V:speed/A:acceleration
M109 T[next_extruder] S{if layer_num < 1}[nozzle_temperature_initial_layer]{else}[nozzle_temperature]{endif} C3 W1 ;wait T[next_extruder]
{if layer_z > first_layer_height && layer_num >= close_fan_the_first_x_layers[next_extruder]}
  M106 P[next_extruder] S{fan_min_speed[next_extruder] * 255.0 / 100.0} ;restore fan speed for T[next_extruder]
{endif}

{endif}