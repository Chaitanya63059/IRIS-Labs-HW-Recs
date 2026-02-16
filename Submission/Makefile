# Vivado 
XVLOG   = xvlog
XELAB   = xelab
XSIM    = xsim

# Files
SRCS    = data_proc.v data_producer.v tb_data_proc.v
TOP     = tb_data_proc
WORK    = work
SNAPSHOT = tb_data_proc_sim
VCD     = tb_data_proc.vcd

# Targets
.PHONY: all simulate clean

all: simulate

simulate:
	$(XVLOG) -work $(WORK) $(SRCS)
	$(XELAB) -work $(WORK) -debug typical $(TOP) -s $(SNAPSHOT)
	$(XSIM) $(WORK).$(SNAPSHOT) -log simulate.log -vcd $(VCD) -tclbatch run_sim.tcl

clean:
	rm -rf $(WORK) .Xil *.log *.jou *.pb *.vcd
