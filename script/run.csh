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

# Incomplete list of development phases
switch ($phase_no)
    case 'phase1':
        set phase_name = top
        breaksw
    case 'phase2':
        set phase_name = configuration 
        breaksw
    case 'phase3':
        set phase_name = environment
        breaksw
    case 'phase4':
        set phase_name = sequencer
        breaksw
    case 'phase5':
        set phase_name = driver
        breaksw
    case 'phase6':
        set phase_name = monitor
        breaksw
    case 'phase7':
        set phase_name = scoreboard
        breaksw
    case 'phase8':
        set phase_name = coverage
        breaksw
    case 'phase9':
        set phase_name = testcases 
        breaksw
    default:
        echo Unknown phase number: $phase_no
        breaksw
    endsw
endif

set workdir = "$rootdir/../verification/${phase_no}_$phase_name"
if (! -d $workdir ) then
  echo "ERROR: $workdir doesn't exist!"
  exit 0
else
  echo "Working directory: $workdir"
endif

# Separate execution between phase 9 and other phases
if ($phase_no == 'phase9') then
    # Phase 9 specific
    if ($#argv == 0 || $#argv > 2 ) then
        echo "ERROR: Too many or too few arguments"
        echo "USAGE: $script_name -l | -t <testcase>"
        exit 0
    endif

    set testcase_list = `cat $workdir/phase9_xsw_test_pkg.sv | grep "^[ ]*class" | sed -e 's/ *extends *[A-Za-z0-9_]*//' -e 's/class *//g' -e 's/;//g'`

    switch ($argv[1])
    case "-l":
        # show the list of testcases to the user using '-l' argument
        if ($#argv > 1) then
            echo "ERROR: Too many arguments"
            exit 0
        else 
            echo "List of test cases:"
            @ testcase_no = 0
            foreach testcase ($testcase_list)
            @ testcase_no++
            echo "  $testcase_no : $testcase"
            end
        endif
        exit 0
        breaksw
    case "-t":
        # run the testcase specified by the user using '-t <test_case>' arguments
        if ($#argv != 2) then 
            echo "ERROR: Too few arguments"
            exit 0
        else 
            set test_specified = "$argv[2]"
            set test_exist = `echo $testcase_list | grep "$test_specified"`
            if ("$test_exist" != "") then
                cd $workdir
                cd ../../report/{$phase_no}_report
                rm -r xsw_cover_html
                echo "Running testcase $test_specified in $workdir"
                setenv test_specified $test_specified
                vsim -c -do ../../script/$phase_no.do
                vcover report ../../report/{$phase_no}_report/$test_specified.ucdb
                vcover report -details ../../report/{$phase_no}_report/$test_specified.ucdb -output ../../report/{$phase_no}_report/xsw_cover_report.rpt
                vcover report -details -html ../../report/{$phase_no}_report/$test_specified.ucdb -output ../../report/{$phase_no}_report/xsw_cover_html
                vdel -all -lib work
            else then
                echo "ERROR: Testcase $test_specified doesn't exist!"
            endif
            exit 0
        endif
        exit 0
        breaksw
    default:    
        echo "ERROR: invalid arguments"
        exit 0
    endsw
else if ($phase_no == 'phase8') then
    cd $workdir
    cd ../../report/{$phase_no}_report
    rm -r xsw_cover_html
    echo "Running Testbench for XSWITCH with $phase_no"
    vsim -c -do ../../script/$phase_no.do 
    vcover report ../../report/{$phase_no}_report/xsw_cover_report.ucdb
    vcover report -details ../../report/{$phase_no}_report/xsw_cover_report.ucdb -output ../../report/{$phase_no}_report/xsw_cover_report.rpt
    vcover report -details -html ../../report/{$phase_no}_report/xsw_cover_report.ucdb -output ../../report/{$phase_no}_report/xsw_cover_html
    vdel -all -lib work
else then
    cd $workdir
    cd ../../report/{$phase_no}_report
    echo "Running Testbench for XSWITCH with $phase_no"
    vsim -c -do ../../script/$phase_no.do 
    vdel -all -lib work
endif