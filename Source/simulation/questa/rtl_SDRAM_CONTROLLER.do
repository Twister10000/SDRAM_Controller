puts "================================================================================"
puts " executing rtl.do script V 1.0 BK 2019 "
puts "================================================================================"
if [file exists w2.do] {
 puts "w2 do wave.do backup found"
}
# Aktuelles wave window speichern:
write format wave -window .main_pane.wave.interior.cs.body.pw.wf {./waveTst.do}
# Groesse des gespeicherten Files ermitteln:
set fsize [file size waveTst.do]
scan $fsize %d IntSize
# und ausgeben:
puts "Size of Wave.do:"
puts $IntSize

# Minimale Groesse 590 Bytes setzen
puts "Min Size of Wave.do:"
set min 590
puts $min
scan $min %d IntMin
# testen, ob ein wave file existiert
if {![file exists wave.do]} {
 puts "no wave.do found"
 # leeres File erzeugen:
 write format wave -window .main_pane.wave.interior.cs.body.pw.wf {./wave.do}
 # Beim ersten starten von Questasim, ist das aktuelle Wave Window leer und darf nicht
 # gespeichert werden, da sonst die wave Datei der letzen Session überschrieben wird.
 # Falls aktuelles Window leer war enthält Testfile nur 587Byte --> wave Window nur
 # speichern, falls Testfile grösser ist.

} elseif {$IntSize >= $IntMin} {
 # save wave Window :
 write format wave -window .main_pane.wave.interior.cs.body.pw.wf {./wave.do}
 puts "================== wave.do saved ===================="
}

if {[file exists rtl_work]} {
vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work


vcom -reportprogress 300 -work work ../../SDRAM_PLL.vhd
vcom -reportprogress 300 -work work ../../sdram_cmd_pkg.vhd
vcom -reportprogress 300 -work work ../../SDRAM_Controller_TOP.vhd
vcom -reportprogress 300 -work work TB_SDRAM_Controller_TOP.vht
quit -sim
vsim -t 1ps -voptargs="+acc" -gui -msgmode both -displaymsgmode both work.SDRAM_Controller_TOP_vhd_tst
do wave.do
run 201us

#create backup
write format wave -window .main_pane.wave.interior.cs.body.pw.wf {./w2.do}
puts "w2.do wave backup created"