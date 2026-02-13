onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Clock /sdram_controller_top_vhd_tst/CLK
add wave -noupdate -expand -group FSM -color Cyan /sdram_controller_top_vhd_tst/i1/current_sdram_state
add wave -noupdate -expand -group FSM -color Cyan /sdram_controller_top_vhd_tst/i1/next_sdram_state
add wave -noupdate -expand -group Counter -color {Medium Orchid} -radix decimal /sdram_controller_top_vhd_tst/i1/wait_cnt
add wave -noupdate -expand -group Counter -color {Medium Orchid} -radix decimal /sdram_controller_top_vhd_tst/i1/refresh_cnt
add wave -noupdate -expand -group Counter -color {Medium Orchid} /sdram_controller_top_vhd_tst/i1/refresh_init_cnt
add wave -noupdate -expand -group Counter /sdram_controller_top_vhd_tst/i1/refresh_timer
add wave -noupdate -expand -group Counter /sdram_controller_top_vhd_tst/i1/refresh_counter
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_cs_n
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_ras_n
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_cas_n
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_we_n
add wave -noupdate -expand -group SDRAM_PINS /sdram_controller_top_vhd_tst/i1/sdram_cke
add wave -noupdate -expand -group SDRAM_PINS -expand -group SDRAM_ADRESS -color {Dark Slate Blue} /sdram_controller_top_vhd_tst/sdram_a
add wave -noupdate -expand -group SDRAM_PINS -expand -group SDRAM_BANK -color Pink /sdram_controller_top_vhd_tst/sdram_ba
add wave -noupdate -expand -group SDRAM_PINS -expand -group SDRAM_DATA -color Orange /sdram_controller_top_vhd_tst/sdram_dq
add wave -noupdate -expand -group SDRAM_PINS -expand -group SDRAM_DQMX /sdram_controller_top_vhd_tst/i1/sdram_dqml
add wave -noupdate -expand -group SDRAM_PINS -expand -group SDRAM_DQMX /sdram_controller_top_vhd_tst/i1/sdram_dqmh
add wave -noupdate -expand -group TRI_STATE /sdram_controller_top_vhd_tst/i1/dq_out_reg
add wave -noupdate -expand -group TRI_STATE /sdram_controller_top_vhd_tst/i1/dq_in_reg
add wave -noupdate -expand -group TRI_STATE /sdram_controller_top_vhd_tst/i1/dq_oe_reg
add wave -noupdate -expand -group USER-PIN -radix hexadecimal -childformat {{/sdram_controller_top_vhd_tst/addr(24) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(23) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(22) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(21) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(20) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(19) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(18) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(17) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(16) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(15) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(14) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(13) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(12) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(11) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(10) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(9) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(8) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(7) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(6) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(5) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(4) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(3) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(2) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(1) -radix unsigned} {/sdram_controller_top_vhd_tst/addr(0) -radix unsigned}} -subitemconfig {/sdram_controller_top_vhd_tst/addr(24) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(23) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(22) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(21) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(20) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(19) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(18) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(17) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(16) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(15) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(14) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(13) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(12) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(11) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(10) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(9) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(8) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(7) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(6) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(5) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(4) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(3) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(2) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(1) {-height 15 -radix unsigned} /sdram_controller_top_vhd_tst/addr(0) {-height 15 -radix unsigned}} /sdram_controller_top_vhd_tst/addr
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/q
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/data
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/req
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/we
add wave -noupdate -expand -group USER-PIN /sdram_controller_top_vhd_tst/i1/valid
add wave -noupdate -expand -group Register -color Violet -radix hexadecimal -childformat {{/sdram_controller_top_vhd_tst/i1/addr_reg(24) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(23) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(22) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(21) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(20) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(19) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(18) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(17) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(16) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(15) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(14) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(13) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(12) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(11) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(10) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(9) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(8) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(7) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(6) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(5) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(4) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(3) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(2) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(1) -radix hexadecimal} {/sdram_controller_top_vhd_tst/i1/addr_reg(0) -radix hexadecimal}} -subitemconfig {/sdram_controller_top_vhd_tst/i1/addr_reg(24) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(23) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(22) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(21) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(20) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(19) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(18) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(17) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(16) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(15) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(14) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(13) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(12) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(11) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(10) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(9) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(8) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(7) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(6) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(5) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(4) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(3) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(2) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(1) {-color Violet -height 15 -radix hexadecimal} /sdram_controller_top_vhd_tst/i1/addr_reg(0) {-color Violet -height 15 -radix hexadecimal}} /sdram_controller_top_vhd_tst/i1/addr_reg
add wave -noupdate -expand -group Register -color Violet /sdram_controller_top_vhd_tst/i1/q_reg
add wave -noupdate -expand -group Register -color Violet /sdram_controller_top_vhd_tst/i1/we_reg
add wave -noupdate -expand -group Register -color Violet /sdram_controller_top_vhd_tst/i1/write_data
add wave -noupdate -expand -group Register -color Violet /sdram_controller_top_vhd_tst/i1/read_data
add wave -noupdate /sdram_controller_top_vhd_tst/i1/ready
add wave -noupdate /sdram_controller_top_vhd_tst/i1/ack
add wave -noupdate /sdram_controller_top_vhd_tst/i1/word_index
add wave -noupdate /sdram_controller_top_vhd_tst/i1/refresh_needed
add wave -noupdate -radix decimal /sdram_controller_top_vhd_tst/i1/INIT_WAIT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {100428185 ps} 0} {{Cursor 4} {100338750 ps} 1}
quietly wave cursor active 1
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
WaveRestoreZoom {37330565 ps} {37512866 ps}
