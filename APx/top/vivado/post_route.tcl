# Simple ILA example #########################################################################

############################
## Open the implemented design
############################
open_run impl_1

##########################
## Write reports
##########################
report_utilization -hierarchical  -file ./report_utilization_hierarchical.txt
report_utilization -slr -file ./report_utilization_slr.txt
report_timing_summary -max_paths 100 -check_timing_verbose -input_pins -routable_nets -file ./report_timing_summary.txt
