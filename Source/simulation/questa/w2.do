onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Clock /sdram_controller_top_vhd_tst/CLK
add wave -noupdate -expand -group FSM -color Cyan /sdram_controller_top_vhd_tst/i1/current_sdram_state
add wave -noupdate -expand -group FSM -color Cyan /sdram_controller_top_vhd_tst/i1/next_sdram_state
add wave -noupdate -expand -group Counter -color {Medium Orchid} -radix decimal /sdram_controller_top_vhd_tst/i1/wait_cnt
add wave -noupdate -expand -group Counter -color {Medium Orchid} -radix decimal /sdram_controller_top_vhd_tst/i1/refresh_cnt
add wave -noupdate -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_cs_n
add wave -noupdate -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_ras_n
add wave -noupdate -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_cas_n
add wave -noupdate -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_we_n
add wave -noupdate -group SDRAM_PINS -group SDRAM_ADRESS -color {Dark Slate Blue} /sdram_controller_top_vhd_tst/sdram_a
add wave -noupdate -group SDRAM_PINS -group SDRAM_BANK -color Pink /sdram_controller_top_vhd_tst/sdram_ba
add wave -noupdate -group SDRAM_PINS -group SDRAM_DATA -color Orange /sdram_controller_top_vhd_tst/sdram_dq
add wave -noupdate /sdram_controller_top_vhd_tst/i1/refresh_needed
add wave -noupdate -expand -group USER-PIN -radix unsigned -childformat {{/sdram_controller_top_vhd_tst/addr(24) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(23) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(22) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(21) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(20) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(19) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(18) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(17) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(16) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(15) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(14) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(13) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(12) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(11) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(10) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(9) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(8) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(7) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(6) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(5) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(4) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(3) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(2) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(1) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(0) -radix unsigned}} -subitemconfig {/sdram_controller_top_vhd_tst/addr(24) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(23) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(22) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(21) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(20) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(19) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(18) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(17) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(16) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(15) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(14) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(13) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(12) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(11) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(10) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(9) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(8) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(7) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(6) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(5) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(4) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(3) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(2) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(1) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(0) {-height 15 -radix unsigned}} /sdram_controller_top_vhd_tst/addr
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/q
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/data
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/req
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/we
add wave -noupdate -expand -group Register -color Violet -radix hexadecimal /sdram_controller_top_vhd_tst/i1/addr_reg
add wave -noupdate -expand -group Register -color Violet /sdram_controller_top_vhd_tst/i1/data_reg
add wave -noupdate -expand -group Register -color Violet /sdram_controller_top_vhd_tst/i1/q_reg
add wave -noupdate -expand -group Register -color Violet /sdram_controller_top_vhd_tst/i1/we_reg
add wave -noupdate /sdram_controller_top_vhd_tst/i1/ready
add wave -noupdate /sdram_controller_top_vhd_tst/i1/ack
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {200645000 ps} 1} {{Cursor 2} {200654912 ps} 0}
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
WaveRestoreZoom {200730726 ps} {201014173 ps}
