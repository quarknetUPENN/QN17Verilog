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

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/HEP/Documents/Quarknet 2017/QN17Verilog/testBench.v";
static int ng1[] = {0, 0};
static int ng2[] = {1, 0};
static unsigned int ng3[] = {1U, 0U};
static unsigned int ng4[] = {0U, 0U};



static void Initial_59_0(char *t0)
{
    char t5[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned int t11;
    int t12;

LAB0:    t1 = (t0 + 4104U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(59, ng0);

LAB4:    xsi_set_current_line(61, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2064);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(62, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2224);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(63, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2384);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(64, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2544);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(65, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2704);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(66, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2864);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(67, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3024);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(68, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3184);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(72, ng0);
    t2 = (t0 + 3912);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(74, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2224);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(75, ng0);
    t2 = (t0 + 3912);
    xsi_process_wait(t2, 60000LL);
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(76, ng0);
    t3 = ((char*)((ng1)));
    t4 = (t0 + 2224);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(78, ng0);
    t2 = (t0 + 3912);
    xsi_process_wait(t2, 60000LL);
    *((char **)t1) = &&LAB7;
    goto LAB1;

LAB7:    xsi_set_current_line(79, ng0);
    t3 = ((char*)((ng3)));
    t4 = (t0 + 2384);
    t6 = (t0 + 2384);
    t7 = (t6 + 72U);
    t8 = *((char **)t7);
    t9 = ((char*)((ng1)));
    xsi_vlog_generic_convert_bit_index(t5, t8, 2, t9, 32, 1);
    t10 = (t5 + 4);
    t11 = *((unsigned int *)t10);
    t12 = (!(t11));
    if (t12 == 1)
        goto LAB8;

LAB9:    xsi_set_current_line(80, ng0);
    t2 = (t0 + 3912);
    xsi_process_wait(t2, 40000LL);
    *((char **)t1) = &&LAB10;
    goto LAB1;

LAB8:    xsi_vlogvar_assign_value(t4, t3, 0, *((unsigned int *)t5), 1);
    goto LAB9;

LAB10:    xsi_set_current_line(81, ng0);
    t3 = ((char*)((ng4)));
    t4 = (t0 + 2384);
    t6 = (t0 + 2384);
    t7 = (t6 + 72U);
    t8 = *((char **)t7);
    t9 = ((char*)((ng1)));
    xsi_vlog_generic_convert_bit_index(t5, t8, 2, t9, 32, 1);
    t10 = (t5 + 4);
    t11 = *((unsigned int *)t10);
    t12 = (!(t11));
    if (t12 == 1)
        goto LAB11;

LAB12:    xsi_set_current_line(83, ng0);
    t2 = (t0 + 3912);
    xsi_process_wait(t2, 9990000LL);
    *((char **)t1) = &&LAB13;
    goto LAB1;

LAB11:    xsi_vlogvar_assign_value(t4, t3, 0, *((unsigned int *)t5), 1);
    goto LAB12;

LAB13:    xsi_set_current_line(84, ng0);
    t3 = ((char*)((ng2)));
    t4 = (t0 + 3024);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    xsi_set_current_line(85, ng0);
    t2 = (t0 + 3912);
    xsi_process_wait(t2, 10000000LL);
    *((char **)t1) = &&LAB14;
    goto LAB1;

LAB14:    xsi_set_current_line(86, ng0);
    t3 = ((char*)((ng1)));
    t4 = (t0 + 3024);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 1);
    goto LAB1;

}

static void Initial_94_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    char *t9;
    char *t10;

LAB0:    t1 = (t0 + 4352U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(94, ng0);

LAB4:    xsi_set_current_line(95, ng0);

LAB5:    t2 = ((char*)((ng2)));
    t3 = (t2 + 4);
    t4 = *((unsigned int *)t3);
    t5 = (~(t4));
    t6 = *((unsigned int *)t2);
    t7 = (t6 & t5);
    t8 = (t7 != 0);
    if (t8 > 0)
        goto LAB6;

LAB7:
LAB1:    return;
LAB6:    xsi_set_current_line(95, ng0);

LAB8:    xsi_set_current_line(96, ng0);
    t9 = ((char*)((ng1)));
    t10 = (t0 + 2064);
    xsi_vlogvar_assign_value(t10, t9, 0, 0, 1);
    xsi_set_current_line(97, ng0);
    t2 = (t0 + 4160);
    xsi_process_wait(t2, 5000LL);
    *((char **)t1) = &&LAB9;
    goto LAB1;

LAB9:    xsi_set_current_line(98, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2064);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(99, ng0);
    t2 = (t0 + 4160);
    xsi_process_wait(t2, 5000LL);
    *((char **)t1) = &&LAB10;
    goto LAB1;

LAB10:    goto LAB5;

}

static void Initial_105_2(char *t0)
{
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 4600U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(105, ng0);

LAB4:    xsi_set_current_line(106, ng0);
    t2 = (t0 + 4408);
    xsi_process_wait(t2, 100000000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(107, ng0);
    xsi_vlog_finish(1);
    goto LAB1;

}


extern void work_m_00000000003035996509_3052352512_init()
{
	static char *pe[] = {(void *)Initial_59_0,(void *)Initial_94_1,(void *)Initial_105_2};
	xsi_register_didat("work_m_00000000003035996509_3052352512", "isim/testBench_isim_beh.exe.sim/work/m_00000000003035996509_3052352512.didat");
	xsi_register_executes(pe);
}
