@echo off
set xv_path=C:\\Programs_Ramos\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim Top_tb_behav -key {Behavioral:sim_1:Functional:Top_tb} -tclbatch Top_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
