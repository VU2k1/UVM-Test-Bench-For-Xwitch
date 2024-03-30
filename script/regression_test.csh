# Set up Questa SIM
#source /CMC/scripts/mentor.questasim.2019.2.csh
source /CMC/scripts/mentor.questasim.2020.1_1.csh

setenv QUESTA_HOME $CMC_MNT_QSIM_HOME
setenv UVM_HOME $QUESTA_HOME/verilog_src/uvm-1.2

# Phase independent
set rootdir = `dirname $0`
set rootdir = `cd $rootdir && pwd`
set script_name = $0:t
#echo script $script_name
set phase_no = `echo $script_name:r | sed -e  s/run_//`
#echo phase $phase_no

set workdir = "$rootdir/../verification/regression_test"
if (! -d $workdir ) then
  echo "ERROR: $workdir doesn't exist!"
  exit 0
else
  echo "Working directory: $workdir"
endif

set testcase_list = `cat $workdir/../phase9_testcases/phase9_xsw_test_pkg.sv | grep "^[ ]*class" | sed -e 's/ *extends *[A-Za-z0-9_]*//' -e 's/class *//g' -e 's/;//g'`

cd $workdir
rm -r xsw_coverage_html

@ testcase_no = 0
foreach testcase ($testcase_list)
    @ testcase_no++
    echo "Running $testcase in Xswitch Testbench"
    setenv test_specified $testcase
    vsim -c -do ../../script/phase9.do
end

vcover merge -64 xsw_cov.ucdb *.ucdb
vcover report -details xsw_cov.ucdb -output xsw_fc.rpt   #functional coverage
vcover report -details -html xsw_cov.ucdb -output xsw_fc_html

mkdir temp_cc

@ testcase_no = 0
foreach testcase ($testcase_list)
    @ testcase_no++
    echo "Running $testcase in Xswitch Testbench"
    setenv test_specified $testcase
    vsim -c -do ../../script/phase9_cc.do
end

vcover merge -64 temp_cc/xsw_cov_cc.ucdb temp_cc/*.ucdb
vcover report -details temp_cc/xsw_cov_cc.ucdb -output xsw_cc.rpt   #code coverage
vcover report xsw_cov.ucdb
rm -r temp_cc
vdel -all -lib work



