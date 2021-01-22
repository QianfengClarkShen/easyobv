sed -i 's/ rd_addr_axil\([0-9][0-9]\)/ rd_addr_axil[\1]/' axil.sv
sed -i 's/ rd_size_axil\([0-9][0-9]\)/ rd_size_axil[\1]/' axil.sv
sed -i 's/ flitcnt_axil\([0-9][0-9]\)/ flitcnt_axil[\1]/' axil.sv
sed -i 's/ rd_addr_axil\([0-9]\)/ rd_addr_axil[\1]/' axil.sv
sed -i 's/ rd_size_axil\([0-9]\)/ rd_size_axil[\1]/' axil.sv
sed -i 's/ flitcnt_axil\([0-9]\)/ flitcnt_axil[\1]/' axil.sv
sed -i '/output logic.*rd_addr_axil\[[1-9]/d' axil.sv
sed -i '/output logic.*rd_size_axil\[[1-9]/d' axil.sv
sed -i '/output logic.*flitcnt_axil\[[1-9]/d' axil.sv
sed -i 's/\(output logic.*\)\[0\],/\1[15:0],/' axil.sv
