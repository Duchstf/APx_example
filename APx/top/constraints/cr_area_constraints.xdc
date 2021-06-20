
create_pblock CR0
add_cells_to_pblock [get_pblocks CR0] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[0].*}]
add_cells_to_pblock [get_pblocks CR0] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[1].*}]
add_cells_to_pblock [get_pblocks CR0] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[2].*}]
add_cells_to_pblock [get_pblocks CR0] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[3].*}]
add_cells_to_pblock [get_pblocks CR0] [get_cells {U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[0].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[1].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[2].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[3].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[0].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[1].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[2].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[3].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[0].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[1].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[2].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[3].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR0] -add {CLOCKREGION_X0Y1:CLOCKREGION_X0Y1}
set_property PARENT sector_0 [get_pblocks CR0]

create_pblock CR1
add_cells_to_pblock [get_pblocks CR1] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[4].*}]
add_cells_to_pblock [get_pblocks CR1] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[5].*}]
add_cells_to_pblock [get_pblocks CR1] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[6].*}]
add_cells_to_pblock [get_pblocks CR1] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[7].*}]
add_cells_to_pblock [get_pblocks CR1] [get_cells {U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[4].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[5].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[6].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[7].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[4].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[5].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[6].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[7].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[4].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[5].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[6].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[7].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR1] -add {CLOCKREGION_X0Y2:CLOCKREGION_X0Y2}
set_property PARENT sector_0 [get_pblocks CR1]

create_pblock CR2
add_cells_to_pblock [get_pblocks CR2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[8].*}]
add_cells_to_pblock [get_pblocks CR2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[9].*}]
add_cells_to_pblock [get_pblocks CR2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[10].*}]
add_cells_to_pblock [get_pblocks CR2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[11].*}]
add_cells_to_pblock [get_pblocks CR2] [get_cells {U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[10].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[11].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[8].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/U_MgtCtrl/gen_mgt[9].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[10].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[11].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[8].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[9].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[10].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[11].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[8].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[0].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[9].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR2] -add {CLOCKREGION_X0Y3:CLOCKREGION_X0Y3}
set_property PARENT sector_0 [get_pblocks CR2]

create_pblock CR3
add_cells_to_pblock [get_pblocks CR3] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[12].*}]
add_cells_to_pblock [get_pblocks CR3] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[13].*}]
add_cells_to_pblock [get_pblocks CR3] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[14].*}]
add_cells_to_pblock [get_pblocks CR3] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[15].*}]
add_cells_to_pblock [get_pblocks CR3] [get_cells {U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[12].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[13].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[14].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[15].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[12].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[13].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[14].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[15].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[12].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[13].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[14].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[15].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR3] -add {CLOCKREGION_X0Y5:CLOCKREGION_X0Y5}
set_property PARENT sector_1 [get_pblocks CR3]

create_pblock CR4
add_cells_to_pblock [get_pblocks CR4] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[16].*}]
add_cells_to_pblock [get_pblocks CR4] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[17].*}]
add_cells_to_pblock [get_pblocks CR4] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[18].*}]
add_cells_to_pblock [get_pblocks CR4] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[19].*}]
add_cells_to_pblock [get_pblocks CR4] [get_cells {U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[16].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[17].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[18].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[19].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[16].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[17].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[18].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[19].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[16].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[17].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[18].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[19].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR4] -add {CLOCKREGION_X0Y6:CLOCKREGION_X0Y6}
set_property PARENT sector_1 [get_pblocks CR4]

create_pblock CR5
add_cells_to_pblock [get_pblocks CR5] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[20].*}]
add_cells_to_pblock [get_pblocks CR5] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[21].*}]
add_cells_to_pblock [get_pblocks CR5] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[22].*}]
add_cells_to_pblock [get_pblocks CR5] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[23].*}]
add_cells_to_pblock [get_pblocks CR5] [get_cells {U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[20].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[21].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[22].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[23].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[20].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[21].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[22].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[23].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[20].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[21].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[22].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[23].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR5] -add {CLOCKREGION_X0Y8:CLOCKREGION_X0Y8}
set_property PARENT sector_1 [get_pblocks CR5]

create_pblock CR6
add_cells_to_pblock [get_pblocks CR6] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[24].*}]
add_cells_to_pblock [get_pblocks CR6] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[25].*}]
add_cells_to_pblock [get_pblocks CR6] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[26].*}]
add_cells_to_pblock [get_pblocks CR6] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[27].*}]
add_cells_to_pblock [get_pblocks CR6] [get_cells {U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[24].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[25].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[26].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/U_MgtCtrl/gen_mgt[27].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[24].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[25].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[26].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[27].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[24].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[25].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[26].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[1].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[27].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR6] -add {CLOCKREGION_X0Y9:CLOCKREGION_X0Y9}
set_property PARENT sector_1 [get_pblocks CR6]

create_pblock CR6_2
add_cells_to_pblock [get_pblocks CR6_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[28].*}]
add_cells_to_pblock [get_pblocks CR6_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[29].*}]
add_cells_to_pblock [get_pblocks CR6_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[30].*}]
add_cells_to_pblock [get_pblocks CR6_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[31].*}]
add_cells_to_pblock [get_pblocks CR6_2] [get_cells {U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[28].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[29].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[30].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[31].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[28].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[29].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[30].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[31].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[28].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[29].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[30].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[31].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR6_2] -add {CLOCKREGION_X0Y10:CLOCKREGION_X0Y10}
set_property PARENT sector_2 [get_pblocks CR6_2]

create_pblock CR7_2
add_cells_to_pblock [get_pblocks CR7_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[32].*}]
add_cells_to_pblock [get_pblocks CR7_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[33].*}]
add_cells_to_pblock [get_pblocks CR7_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[34].*}]
add_cells_to_pblock [get_pblocks CR7_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[35].*}]
add_cells_to_pblock [get_pblocks CR7_2] [get_cells {U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[32].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[33].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[34].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[35].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[32].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[33].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[34].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[35].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[32].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[33].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[34].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[35].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR7_2] -add {CLOCKREGION_X0Y11:CLOCKREGION_X0Y11}
set_property PARENT sector_2 [get_pblocks CR7_2]

create_pblock CR8_2
add_cells_to_pblock [get_pblocks CR8_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[36].*}]
add_cells_to_pblock [get_pblocks CR8_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[37].*}]
add_cells_to_pblock [get_pblocks CR8_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[38].*}]
add_cells_to_pblock [get_pblocks CR8_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[39].*}]
add_cells_to_pblock [get_pblocks CR8_2] [get_cells {U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[36].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[37].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[38].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[39].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[36].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[37].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[38].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[39].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[36].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[37].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[38].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[39].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR8_2] -add {CLOCKREGION_X0Y12:CLOCKREGION_X0Y12}
set_property PARENT sector_2 [get_pblocks CR8_2]

create_pblock CR9_2
add_cells_to_pblock [get_pblocks CR9_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[40].*}]
add_cells_to_pblock [get_pblocks CR9_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[41].*}]
add_cells_to_pblock [get_pblocks CR9_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[42].*}]
add_cells_to_pblock [get_pblocks CR9_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[43].*}]
add_cells_to_pblock [get_pblocks CR9_2] [get_cells {U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[40].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[41].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[42].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[43].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[40].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[41].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[42].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[43].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[40].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[41].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[42].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[43].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR9_2] -add {CLOCKREGION_X0Y13:CLOCKREGION_X0Y13}
set_property PARENT sector_2 [get_pblocks CR9_2]

create_pblock CR10_2
add_cells_to_pblock [get_pblocks CR10_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[44].*}]
add_cells_to_pblock [get_pblocks CR10_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[45].*}]
add_cells_to_pblock [get_pblocks CR10_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[46].*}]
add_cells_to_pblock [get_pblocks CR10_2] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[47].*}]
add_cells_to_pblock [get_pblocks CR10_2] [get_cells {U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[44].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[45].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[46].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/U_MgtCtrl/gen_mgt[47].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[44].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[45].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[46].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[47].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[44].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[45].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[46].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[2].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[47].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR10_2] -add {CLOCKREGION_X0Y14:CLOCKREGION_X0Y14}
set_property PARENT sector_2 [get_pblocks CR10_2]

create_pblock CR11
add_cells_to_pblock [get_pblocks CR11] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[48].*}]
add_cells_to_pblock [get_pblocks CR11] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[49].*}]
add_cells_to_pblock [get_pblocks CR11] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[50].*}]
add_cells_to_pblock [get_pblocks CR11] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[51].*}]
add_cells_to_pblock [get_pblocks CR11] [get_cells {U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/U_MgtCtrl/gen_mgt[48].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/U_MgtCtrl/gen_mgt[49].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/U_MgtCtrl/gen_mgt[50].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/U_MgtCtrl/gen_mgt[51].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[48].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[49].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[50].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[51].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[48].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[49].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[50].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[51].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR11] -add {CLOCKREGION_X5Y2:CLOCKREGION_X5Y2}
set_property PARENT sector_3 [get_pblocks CR11]

create_pblock CR12
add_cells_to_pblock [get_pblocks CR12] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[52].*}]
add_cells_to_pblock [get_pblocks CR12] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[53].*}]
add_cells_to_pblock [get_pblocks CR12] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[54].*}]
add_cells_to_pblock [get_pblocks CR12] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[55].*}]
add_cells_to_pblock [get_pblocks CR12] [get_cells {U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/U_MgtCtrl/gen_mgt[52].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/U_MgtCtrl/gen_mgt[53].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/U_MgtCtrl/gen_mgt[54].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/U_MgtCtrl/gen_mgt[55].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[52].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[53].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[54].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[55].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[52].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[53].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[54].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[3].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[55].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR12] -add {CLOCKREGION_X5Y3:CLOCKREGION_X5Y3}
set_property PARENT sector_3 [get_pblocks CR12]

create_pblock CR13
add_cells_to_pblock [get_pblocks CR13] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[56].*}]
add_cells_to_pblock [get_pblocks CR13] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[57].*}]
add_cells_to_pblock [get_pblocks CR13] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[58].*}]
add_cells_to_pblock [get_pblocks CR13] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[59].*}]
add_cells_to_pblock [get_pblocks CR13] [get_cells {U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[56].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[57].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[58].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[59].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[56].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[57].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[58].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[59].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[56].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[57].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[58].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[59].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR13] -add {CLOCKREGION_X5Y5:CLOCKREGION_X5Y5}
set_property PARENT sector_4 [get_pblocks CR13]

create_pblock CR14
add_cells_to_pblock [get_pblocks CR14] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[60].*}]
add_cells_to_pblock [get_pblocks CR14] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[61].*}]
add_cells_to_pblock [get_pblocks CR14] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[62].*}]
add_cells_to_pblock [get_pblocks CR14] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[63].*}]
add_cells_to_pblock [get_pblocks CR14] [get_cells {U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[60].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[61].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[62].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[63].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[60].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[61].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[62].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[63].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[60].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[61].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[62].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[63].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR14] -add {CLOCKREGION_X5Y6:CLOCKREGION_X5Y6}
set_property PARENT sector_4 [get_pblocks CR14]

create_pblock CR15
add_cells_to_pblock [get_pblocks CR15] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[64].*}]
add_cells_to_pblock [get_pblocks CR15] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[65].*}]
add_cells_to_pblock [get_pblocks CR15] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[66].*}]
add_cells_to_pblock [get_pblocks CR15] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[67].*}]
add_cells_to_pblock [get_pblocks CR15] [get_cells {U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[64].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[65].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[66].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[67].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[64].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[65].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[66].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[67].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[64].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[65].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[66].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[67].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR15] -add {CLOCKREGION_X5Y7:CLOCKREGION_X5Y7}
set_property PARENT sector_4 [get_pblocks CR15]

create_pblock CR16
add_cells_to_pblock [get_pblocks CR16] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[68].*}]
add_cells_to_pblock [get_pblocks CR16] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[69].*}]
add_cells_to_pblock [get_pblocks CR16] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[70].*}]
add_cells_to_pblock [get_pblocks CR16] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[71].*}]
add_cells_to_pblock [get_pblocks CR16] [get_cells {U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[68].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[69].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[70].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[71].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[68].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[69].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[70].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[71].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[68].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[69].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[70].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[71].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR16] -add {CLOCKREGION_X5Y8:CLOCKREGION_X5Y8}
set_property PARENT sector_4 [get_pblocks CR16]

create_pblock CR17
add_cells_to_pblock [get_pblocks CR17] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[72].*}]
add_cells_to_pblock [get_pblocks CR17] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[73].*}]
add_cells_to_pblock [get_pblocks CR17] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[74].*}]
add_cells_to_pblock [get_pblocks CR17] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[75].*}]
add_cells_to_pblock [get_pblocks CR17] [get_cells {U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[72].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[73].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[74].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/U_MgtCtrl/gen_mgt[75].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[72].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[73].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[74].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[75].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[72].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[73].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[74].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[4].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[75].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR17] -add {CLOCKREGION_X5Y9:CLOCKREGION_X5Y9}
set_property PARENT sector_4 [get_pblocks CR17]

create_pblock CR18
add_cells_to_pblock [get_pblocks CR18] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[76].*}]
add_cells_to_pblock [get_pblocks CR18] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[77].*}]
add_cells_to_pblock [get_pblocks CR18] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[78].*}]
add_cells_to_pblock [get_pblocks CR18] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[79].*}]
add_cells_to_pblock [get_pblocks CR18] [get_cells {U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[76].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[77].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[78].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[79].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[76].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[77].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[78].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[79].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[76].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[77].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[78].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[79].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR18] -add {CLOCKREGION_X5Y10:CLOCKREGION_X5Y10}
set_property PARENT sector_5 [get_pblocks CR18]

create_pblock CR19
add_cells_to_pblock [get_pblocks CR19] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[82].*}]
add_cells_to_pblock [get_pblocks CR19] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[83].*}]
add_cells_to_pblock [get_pblocks CR19] [get_cells {U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[82].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[83].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[80].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[81].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[82].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[83].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[82].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[83].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR19] -add {CLOCKREGION_X5Y11:CLOCKREGION_X5Y11}
set_property PARENT sector_5 [get_pblocks CR19]

create_pblock CR20
add_cells_to_pblock [get_pblocks CR20] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[84].*}]
add_cells_to_pblock [get_pblocks CR20] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[85].*}]
add_cells_to_pblock [get_pblocks CR20] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[86].*}]
add_cells_to_pblock [get_pblocks CR20] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[87].*}]
add_cells_to_pblock [get_pblocks CR20] [get_cells {U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[84].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[85].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[86].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[87].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[84].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[85].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[86].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[87].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[84].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[85].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[86].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[87].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR20] -add {CLOCKREGION_X5Y12:CLOCKREGION_X5Y12}
set_property PARENT sector_5 [get_pblocks CR20]

create_pblock CR21
add_cells_to_pblock [get_pblocks CR21] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[88].*}]
add_cells_to_pblock [get_pblocks CR21] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[89].*}]
add_cells_to_pblock [get_pblocks CR21] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[90].*}]
add_cells_to_pblock [get_pblocks CR21] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[91].*}]
add_cells_to_pblock [get_pblocks CR21] [get_cells {U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[88].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[89].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[90].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[91].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[88].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[89].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[90].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[91].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[88].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[89].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[90].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[91].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR21] -add {CLOCKREGION_X5Y13:CLOCKREGION_X5Y13}
set_property PARENT sector_5 [get_pblocks CR21]

create_pblock CR22
add_cells_to_pblock [get_pblocks CR22] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[92].*}]
add_cells_to_pblock [get_pblocks CR22] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[93].*}]
add_cells_to_pblock [get_pblocks CR22] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[94].*}]
add_cells_to_pblock [get_pblocks CR22] [get_cells -quiet {*/*/*/genLinkStreamBuf72b[95].*}]
add_cells_to_pblock [get_pblocks CR22] [get_cells {U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[92].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[93].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[94].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/U_MgtCtrl/gen_mgt[95].gen_mgt_en.U_MgtWrapper U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[92].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[93].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[94].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfRxCtrl/genIridisSfRx[95].genIridisSfRxEn.U_IridisSfRx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[92].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[93].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[94].genIridisSfTxEn.U_IridisSfTx U_ApxL1TTop/gen_sector[5].U_ApxL1TSector/u_IridisSfTxCtrl/genIridisSfTx[95].genIridisSfTxEn.U_IridisSfTx}]
resize_pblock [get_pblocks CR22] -add {CLOCKREGION_X5Y14:CLOCKREGION_X5Y14}
set_property PARENT sector_5 [get_pblocks CR22]
