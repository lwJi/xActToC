/* test.c */
/* (c) Liwei Ji 05/07/2022 */
/* Produced with Mathematica */

#include "nmesh.h"
#include "C3GH.h"

#define Power(x,y) (pow((double) (x),(double) (y)))
#define Log(x) log((double) (x))
#define pow2(x) ((x)*(x))
#define pow2inv(x) (1.0/((x)*(x)))
#define Cal(x,y,z) ((x)?(y):(z))
#define Sqrt(x) sqrt(x)
#define Abs(x) fabs(x)


/* use globals from C3GH */
extern tC3GH C3GH[1];


void test(tVarList *vlu, tVarList *vlr)
{
tMesh *mesh = u->mesh;

int Msqr = GetvLax(Par("ADM_ConstraintNorm"), "Msqr ");

formylnodes(mesh)
{
tNode *node = MyLnode;
int ijk;

forpoints(node, ijk)
{
int iMDD = Ind("ADM_gxx");

double *rU1 = Vard(node, Vind(vlr,0));
double *rU2 = Vard(node, Vind(vlr,1));
double *rU3 = Vard(node, Vind(vlr,2));
double *uU1 = Vard(node, Vind(vlu,0));
double *uU2 = Vard(node, Vind(vlu,1));
double *uU3 = Vard(node, Vind(vlu,2));
double *MDD11 = Vard(node, iMDDxx);
double *MDD12 = Vard(node, iMDDxx+1);
double *MDD13 = Vard(node, iMDDxx+2);
double *MDD22 = Vard(node, iMDDxx+3);
double *MDD23 = Vard(node, iMDDxx+4);
double *MDD33 = Vard(node, iMDDxx+5);
double
vU1
=
MDD11[ijk]*uU1[ijk] + MDD12[ijk]*uU2[ijk] + MDD13[ijk]*uU3[ijk]
;

double
vU2
=
MDD12[ijk]*uU1[ijk] + MDD22[ijk]*uU2[ijk] + MDD23[ijk]*uU3[ijk]
;

double
vU3
=
MDD13[ijk]*uU1[ijk] + MDD23[ijk]*uU2[ijk] + MDD33[ijk]*uU3[ijk]
;


if(Msqr)
{
rU1[ijk]
=
vU1*MDD11[ijk] + vU2*MDD12[ijk] + vU3*MDD13[ijk]
;

rU2[ijk]
=
vU1*MDD12[ijk] + vU2*MDD22[ijk] + vU3*MDD23[ijk]
;

rU3[ijk]
=
vU1*MDD13[ijk] + vU2*MDD23[ijk] + vU3*MDD33[ijk]
;

}
else
{
rU1[ijk]
=
vU1
;

rU2[ijk]
=
vU2
;

rU3[ijk]
=
vU3
;

}

} /* end of points */
} /* end of nodes */
}
