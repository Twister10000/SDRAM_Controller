# SDRAM Controller (VHDL)

Ein modularer und effizienter **SDRAM-Controller**, entwickelt als Semester-Ferienprojekt. Dieses Modul ermöglicht es einer FPGA-Logik, Daten in einem externen SDRAM-Baustein (z. B. AS4C16M16SA) zu speichern und abzurufen.

## 📌 Features
* **VHDL-basiert:** Portabel und kompatibel mit Xilinx, Intel/Altera und Lattice FPGAs.
* **FSM-Design:** Robuste State-Machine zur Steuerung der SDRAM-Kommandos.
* **Operationen:**
    * Automatische Initialisierung (Precharge, Refresh, Mode Register Set).
    * Single Read & Write Operationen.
    * Integriertes Auto-Refresh Management.
* **Timing:** Einstellbare Parameter für $t_{RP}$, $t_{RCD}$, $t_{CAS}$ etc.

## 🏗 Architektur
Der Controller fungiert als Brücke zwischen der internen FPGA-Logik (User Interface) und dem externen SDRAM-Chip.



### Schnittstellenbeschreibung
* **User Interface:** Einfaches Interface mit `addr`, `data_in`, `data_out` und Steuersignalen wie `busy`.
* **SDRAM Interface:** Direkte Verbindung zu den Hardware-Pins des SDRAM-Chips.

---

## 🚀 Verwendung

### Integration
Kopiere die Datei `sdram_controller.vhd` in dein Projekt. Hier ist ein Beispiel für die Instanziierung:

```vhdl
entity sdram_controller is
    port (
        -- System
        clk           : in    std_logic;
        reset         : in    std_logic;
        
        -- User Interface
        addr_in       : in    std_logic_vector(23 downto 0);
        data_i        : in    std_logic_vector(15 downto 0);
        data_o        : out   std_logic_vector(15 downto 0);
        wr_en         : in    std_logic;
        rd_en         : in    std_logic;
        busy          : out   std_logic;

        -- SDRAM Pins
        sdram_clk     : out   std_logic;
        sdram_ras_n   : out   std_logic;
        sdram_cas_n   : out   std_logic;
        sdram_we_n    : out   std_logic;
        sdram_dq      : inout std_logic_vector(15 downto 0);
        -- ... weitere Pins
    );
end entity;