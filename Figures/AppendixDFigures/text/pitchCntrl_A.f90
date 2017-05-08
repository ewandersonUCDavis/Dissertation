SUBROUTINE PitchCntrl ( BlPitch, ElecPwr, HSS_Spd, GBRatio, TwrAccel, NumBl, &
						ZTime, DT, DirRoot, BlPitchCom_out )

   ! This pitch control routine was written by Eric Anderson of UC Davis. It is based  
   ! on the baseline NREL 5MW pitch control scheme outlined in the NREL 5MW 
   ! specifications with the addition the derating scheme outlined in Eric's  
   ! dissertaion. Derating isachieved by using subroutine ControlParameters() to scale  
   ! relevant control parameters.
USE								precision
USE								EAControl 	! contains variables: TimeDRStart, TimeDREnd, DerateFactor, TEmShutdown, maxOverspeed, EmergencyShutdown, GenSpeedF, PC_RefSpd, PC_MinPit, VS_Rgn2_K, and VS_RtPwr. See EAControl module in FAST_Mods.f90 for variable descriptions.

IMPLICIT                        NONE

   ! Passed variables:

INTEGER(4), INTENT(IN )      :: NumBl                   ! Number of blades, (-).
REAL(ReKi), INTENT(IN )      :: BlPitch   (NumBl)       ! Current values of the blade pitch angles, rad.