@echo off
set xv_path=E:\\Faculta\\AN2_SEM2\\AC_LAB\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 88824a7a64424a07bd57579a9b675a28 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot test_bench_behav xil_defaultlib.test_bench -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
