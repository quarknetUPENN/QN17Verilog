/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    unisims_ver_m_00000000002399568039_2282143210_init();
    unisims_ver_m_00000000000740258969_3897995058_init();
    unisims_ver_m_00000000000740258969_1625843133_init();
    unisims_ver_m_00000000003131622635_0225263307_init();
    unisims_ver_m_00000000002922998384_2016732566_init();
    unisims_ver_m_00000000003266096158_2593380106_init();
    unisims_ver_m_00000000001003841287_4107402263_init();
    unisims_ver_m_00000000003286176031_2607553651_init();
    xilinxcorelib_ver_m_00000000000200492576_0409231278_init();
    xilinxcorelib_ver_m_00000000003031181500_2689461952_init();
    xilinxcorelib_ver_m_00000000001159543956_2081990737_init();
    xilinxcorelib_ver_m_00000000001291582275_0431218563_init();
    work_m_00000000001221935279_0632128884_init();
    work_m_00000000003544011347_4079237611_init();
    work_m_00000000000516752888_0286164271_init();
    work_m_00000000003035996509_3052352512_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000003035996509_3052352512");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
