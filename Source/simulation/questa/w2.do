onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sdram_controller_top_vhd_tst/CLK
add wave -noupdate -group CMD /sdram_controller_top_vhd_tst/i1/cmd
add wave -noupdate -group CMD /sdram_controller_top_vhd_tst/i1/next_cmd
add wave -noupdate -expand -group FSM -color Cyan /sdram_controller_top_vhd_tst/i1/current_sdram_state
add wave -noupdate -expand -group FSM -color Cyan /sdram_controller_top_vhd_tst/i1/next_sdram_state
add wave -noupdate -expand -group Counter -color {Medium Orchid} -radix decimal /sdram_controller_top_vhd_tst/i1/wait_cnt
add wave -noupdate -expand -group Counter -color {Medium Orchid} /sdram_controller_top_vhd_tst/i1/refresh_cnt
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_cs_n
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_ras_n
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_cas_n
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_we_n
add wave -noupdate /sdram_controller_top_vhd_tst/sdram_a
add wave -noupdate /sdram_controller_top_vhd_tst/sdram_ba
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {200025000 ps} 0} {{Cursor 2} {200515000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {200925087 ps} {201003943 ps}
