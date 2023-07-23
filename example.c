//
// Created by 14063 on 2022/7/13.
//
#include "udf.h"

DEFINE_DPM_EROSION(DNV, tp, t, f, normal, alpha, Vmag, mdot)
{
	Message0("%f,%f,%f,%f,%f,%f,%f,\n", tp, t, f, normal, alpha, Vmag, mdot);
	real erosion;
	real F_alpha;
	F_alpha = 9.370 * alpha - 42.295 * pow(alpha, 2) + 110.864 * pow(alpha, 3) - 175.804 * pow(alpha, 4) + 170.137 * pow(alpha, 5) - 98.398 * pow(alpha, 6) + 31.211 * pow(alpha, 7) - 4.170 * pow(alpha, 8);

	erosion = (2.0e-9) * F_alpha * (pow(Vmag, 2.6)) * mdot; /*mm per year*/

	F_STORAGE_R_XV(f, t, SV_DPMS_EROSION, EROSION_UDF) = erosion;
}