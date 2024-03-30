onbreak {resume}

set QUESTA_HOME $::env(QUESTA_HOME)
set UVM_HOME $::env(UVM_HOME)
set TEST $::env(test_specified)
set tbench_top tbench_top

puts "CME435 XSWITCH: Compiling..."
vlog -f ../../script/phase9_cc.f
puts "CME435 XSWITCH: Running simulation..."
vsim -coverage $tbench_top -L $QUESTA_HOME/uvm-1.2 +UVM_TESTNAME=$TEST
coverage save -onexit ./temp_cc/$TEST.ucdb
run -all
