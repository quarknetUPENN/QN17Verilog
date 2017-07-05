
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name doublebuffer -dir "C:/Users/HEP/Documents/Quarknet 2017/QN17Verilog/planAhead_run_2" -part xc3s100etq144-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/HEP/Documents/Quarknet 2017/QN17Verilog/main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/HEP/Documents/Quarknet 2017/QN17Verilog} {ipcore_dir} }
add_files [list {ipcore_dir/fif64x16.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fif64x256.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/fifo128x256.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "constraints.ucf" [current_fileset -constrset]
add_files [list {constraints.ucf}] -fileset [get_property constrset [current_run]]
link_design
