SUBROUTINE UserVSCont ( HSS_Spd, GBRatio, NumBl, ZTime, DT, GenEff, DelGenTrq, DirRoot, GenTrq, ElecPwr )

   ! This torque control routine was written by Eric Anderson of UC Davis. The torque control scheme 
   ! is based on the controller described in the NREL 5MW specifications, with the addition of a 
   ! derating scheme described in Eric's dissertation. Derating is achieved by using subroutine 
   ! ControlParameters() to scale relevant control parameters. WARNING: This routine does not include the 
   ! logic required to run linearizations.

USE								precision
USE  							Output
USE								EAControl 	! contains variables: TimeDRStart, TimeDREnd, DerateFactor, TEmShutdown, maxOverspeed, EmergencyShutdown, GenSpeedF, PC_RefSpd, PC_MinPit, VS_Rgn2_K, and VS_RtPwr. See EAControl module in FAST_Mods.f90 for variable descriptions.