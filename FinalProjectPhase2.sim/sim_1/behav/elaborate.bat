@echo off
set xv_path=C:\\Programs_Ramos\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto 349aa729a9254243865b95f042b5205b -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot Top_tb_behav xil_defaultlib.Top_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
