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
    unisims_ver_m_00000000001003841287_4107402263_init();
    xilinxcorelib_ver_m_00000000000200492576_0409231278_init();
    xilinxcorelib_ver_m_00000000003031181500_2689461952_init();
    xilinxcorelib_ver_m_00000000001159543956_2081990737_init();
    xilinxcorelib_ver_m_00000000001291582275_0431218563_init();
    work_m_00000000001221935279_0632128884_init();
    work_m_00000000003583417889_4079237611_init();
    work_m_00000000001961662792_0286164271_init();
    work_m_00000000003035996509_3052352512_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000003035996509_3052352512");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
