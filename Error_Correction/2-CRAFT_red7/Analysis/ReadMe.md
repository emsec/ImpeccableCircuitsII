To evaluate the design, we made use of VerFI(ver 2 Beta) for diagnosis (https://github.com/emsec/VerFI/tree/master/VerFI_for_diagnosis/BitSliced). This analysis contains the following files:

- Library.txt: this file includes the specification of cells used in NANG45 ASIC library

- design.v: this file is the net-list of the RTL code, which has been synthesized by Design Compiler using NANG45 ASIC standard cell library. Note that the ungrouped net-list should be generated.

- cells.rpt: it is one of the reports generated by the synthesizer (Design Compiler). It lists all cells available in the design and their hierarchy.

- sim_univariate.txt: it defines all simulation settings. In particular, it sets the tool to inject every possible two-bit toggle fault into the design at the 5th clock cycle. Module "Output_MUX" is excluded.

- sim_multivariate.txt: it sets the tool to inject single-bit toggle fault into the design at the 5th clock cycle and another single-bit toggle fault at the 6th clock cycle exhaustively (two-bit fault in the full encryption). Module "Output_MUX" is excluded.

The result of the simulation can be seen in the "SimulationResult_univariate" and "SimulationResult_multivariate" folders. 