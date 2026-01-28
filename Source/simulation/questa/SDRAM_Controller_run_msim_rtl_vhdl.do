transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/Users/mikaj/Documents/GitHub/SDRAM_Controller/Source/db {C:/Users/mikaj/Documents/GitHub/SDRAM_Controller/Source/db/sdram_pll_altpll.v}
vcom -2008 -work work {C:/Users/mikaj/Documents/GitHub/SDRAM_Controller/Source/SDRAM_PLL.vhd}
vcom -2008 -work work {C:/Users/mikaj/Documents/GitHub/SDRAM_Controller/Source/sdram_cmd_pkg.vhd}
vcom -2008 -work work {C:/Users/mikaj/Documents/GitHub/SDRAM_Controller/Source/SDRAM_Controller_TOP.vhd}

