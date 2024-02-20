; Model: Snapmaker J1 ({nozzle_diameter[0]}/{nozzle_diameter[1]})
; Refactored version from origin https://github.com/macdylan/3dp-configs
; Printer : [printer_preset]
; Profile : [print_preset]
; Plate   : [plate_name]
; --- initial_extruder: [initial_extruder]
; --- has_wipe_tower: [has_wipe_tower]
; --- total_toolchanges: [total_toolchanges]
; --- T0: {is_extruder_used[0]}
; --- T1: {is_extruder_used[1]}

T[initial_extruder]

M205 V5 ;Junction Deviation (mm) - copied from luban gcode
M204 S500 ;Set the preferred starting acceleration (in units/s/s) for moves of different types. Legacy M204 S<accel> is deprecated. Use separate paremeters M204 P<accel> T<accel> instead.

{if plate_name =~/.*IDEXDupl.*/ || plate_name =~/.*IDEXCopy.*/ }
  M605 S2 X162 R0 ;IDEX Duplication
{elsif plate_name =~/.*IDEXMirr.*/}
  M605 S3 ;IDEX Mirror
{elsif plate_name =~/.*IDEXBack.*/}
  M605 S4 ;IDEX Backup
{endif}

; start bed & nozzle heating and do not wait it
M140 S{first_layer_bed_temperature[initial_extruder]} ;no wait
{if is_extruder_used[0]} M104 T0 S{nozzle_temperature_initial_layer[0]} {endif}
{if is_extruder_used[1]} M104 T1 S{nozzle_temperature_initial_layer[1]} {endif}

G28

; position heads for cleaning
{if is_extruder_used[0]}
  T0
  G0 X5 Y0 F6000
{endif}
{if is_extruder_used[1]}
  T1
  G0 X325 Y0 F6000
{endif}

G0 Z40.0 F10000 ; set bed to middle position with fast feedrade

; wait for reaching temp
{if is_extruder_used[0]} M109 T0 S{nozzle_temperature_initial_layer[0]} {endif}
{if is_extruder_used[1]} M109 T1 S{nozzle_temperature_initial_layer[1]} {endif}

; blink to indicate that manual cleaning should be finished and now moving will start
{if 1==1}; LED
  M355 S1 P0
  G4 P200
  M355 S1 P255
  G4 P50
  M355 S1 P0
  G4 P200
  M355 S1 P255
{endif}

; extrude small amout of filament to ensure that no clogging (if clogging exist extruder will produce clicking sound)
{if is_extruder_used[0]} 
  T0
  M83 ;override G90 and put the E axis into relative mode independent of the other axes.
  ;M106 S64 ;fan on
  G0 X-8 F5000 ;travel to extrude position
  G1 E5 ;extrude a little for checking that there is no clogging
  G0 X-12 ;park to silicon rubber
  ;M107 ;fan off
{endif}
{if is_extruder_used[1]}
  T1
  M83 ;override G90 and put the E axis into relative mode independent of the other axes.
  ;M106 S64 ;fan on
  G0 X334 F5000 ;travel to extrude position
  G1 E5 ;extrude a little for checking that there is no clogging
  G0 X338 ;park to silicon rubber
  ;M107 ;fan off
{endif}

; cleaning finished - move the bed
G0 Z0.8 F9000

M190 S{first_layer_bed_temperature[initial_extruder]} ; wait bed reaches temperature

; blink to indicate that heating completed and now purging will start
{if 1==1}; LED
  M355 S1 P0
  G4 P200
  M355 S1 P255
  G4 P50
  M355 S1 P0
  G4 P200
  M355 S1 P255
  G4 P50
  M355 S1 P0
  G4 P200
  M355 S1 P255
  G4 P50
  M355 S1 P0
  G4 P200
  M355 S1 P255
{endif}

; draw purge line
{if is_extruder_used[0] and initial_extruder == 0 }
  T0
  G0 X-1 Y0 F5000 ;move to edge position 
  G1 E5 F150 ;make filament bulb 
  G1 X3 Z0.3 F5000 ;move away from bulb
  G1 Y15 E2 ;1 line 
  G1 X0 Y4 E1 ;2 line
  G1 Y40 E2.2 ;3 line
  G1 X-0.5 ; move a little left
  G1 Y35 E0.3 ;last 4 line - backward
  G1 Y30 F5000 ;move without extruding and wipe oozing/stringing by crossing 3 line on start
{endif}
{if is_extruder_used[1] and initial_extruder == 1}
  T1
  G0 X326.5 Y0 F5000 ;move to edge position 
  G1 E5 F150 ;make filament bulb 
  G1 X322 Z0.3 F5000 ;move away from bulb
  G1 Y15 E2 ;1 line 
  G1 X326 Y4 E1 ;2 line
  G1 Y40 E2.2 ;3 line
  G1 X326.5 ; move a little right
  G1 Y35 E0.3 ;last 4 line - backward
  G1 Y30 F5000 ;move without extruding and wipe oozing/stringing by crossing 3 line on start
{endif}
;G1 E-0.2 F200 ;final retract to prevent oozing
G92 E0 ; Set the current position of E axes
; ready [plate_name]