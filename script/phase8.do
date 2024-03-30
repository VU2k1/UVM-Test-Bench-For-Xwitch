onbreak {resume}

set QUESTA_HOME $::env(QUESTA_HOME)

set tbench_top tbench_top

puts "CME435 XSWITCH: Compiling..."
vlog -f ../../script/phase8.f
puts "CME435 XSWITCH: Running simulation..."
vsim $tbench_top -L $QUESTA_HOME/uvm-1.2 
coverage save -onexit ../../report/phase8_report/xsw_cover_report.ucdb
run -all