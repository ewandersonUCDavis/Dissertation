SUBROUTINE updateControlParameters( HSS_Spd, ZTime )

USE								precision
USE								EAControl 	! contains variables: TimeDRStart, TimeDREnd, DerateFactor, TEmShutdown, maxOverspeed, EmergencyShutdown, GenSpeedF, PC_RefSpd, PC_MinPit, VS_Rgn2_K, and VS_RtPwr. See EAControl module in FAST_Mods.f90 for variable descriptions.

IMPLICIT                        NONE

   ! Passed Variables:
REAL(ReKi), INTENT(IN)      :: HSS_Spd  ! Current  HSS (generator) speed, rad/s.
REAL(ReKi), INTENT(IN )     :: ZTime    ! Current simulation time, sec.

	! Local variables storing baseline control parameters (FROM the controller described in the NREL 5MW specifications)
REAL(ReKi), PARAMETER				:: PC_MinPit_baseline     = 0.0     ! Minimum pitch setting in NREL 5MW baseline pitch controller, rad.
REAL(ReKi), PARAMETER           	:: PC_RefSpd_baseline     = 122.9096 ! Desired (reference) HSS speed for NREL 5MW baseline pitch controller, rad/s.
REAL(ReKi), PARAMETER           	:: VS_Rgn2K_baseline      = 2.332287 ! Generator torque constant in Region 2 (HSS side) for NREL 5MW baseline controller, N-m/(rad/s)^2.
REAL(ReKi), PARAMETER           	:: VS_RtGnSp_baseline     = 121.6805 ! Rated generator speed (HSS side) for NREL 5MW baseline controller, rad/s. -- chosen to be 99% of PC_RefSpd
REAL(ReKi), PARAMETER			    :: VS_RtPwr_baseline      = 5296610.0  ! Rated generator generator power in Region 3 for NREL 5MW baseline controller, Watts. -- chosen to be 5MW divided by tthe electrical generator efficiency of 94.ReKi%
REAL(ReKi), PARAMETER			    :: VS_Rgn2Sp_baseline	  = 91.21091   ! Transitional generator speed (HSS side) between regions 1 1/2 and 2 for NREL 5MW baseline controller, rad/s.
REAL(ReKi), PARAMETER			    :: VS_CtInSp_baseline	  = 70.16224   ! Transitional generator speed (HSS side) between regions 1 and 1 1/2 for NREL 5MW baseline controller, rad/s.

	!Local variables used to filter generator speed
REAL(ReKi)                      :: Alpha                  ! Current coefficient in the recursive, single-pole, low-pass filter, (-).
REAL(ReKi), SAVE                :: LastTime               ! Last time this subroutine was called, sec.
REAL(ReKi), PARAMETER           :: CornerFreq    =       1.570796  ! Corner frequency (-3dB point) in the recursive, single-pole, low-pass filter, rad/s. -- chosen to be 1/4 the blade edgewise natural frequency ( 1/4 of approx. 1Hz = 0.25Hz = 1.570796rad/s)

	!Local variables used for derate calculations
REAL(ReKi), PARAMETER			   :: pDR = 0.2		!- poles of the second order derate input filter.
REAL(ReKi), SAVE                   :: FF_pwrFactor = 1.0 ! The derate factor. A fraction of 1, where 1 is not derated.
REAL(ReKi), PARAMETER, DIMENSION (17)	:: DRPitchArray = (/ 0.1178, 0.1091, &
0.1004, 0.0916, 0.0829, 0.0742, 0.0654, 0.0611, 0.0524, 0.0436, 0.0393, 0.0349, &
0.0305, 0.0262, 0.0218, 0.0131, 0.0 /) !Array of minimum pitch values, (radians)
REAL(ReKi), PARAMETER, DIMENSION (17)	:: DRArray   = (/ 0.5789, 0.6184, 0.6579, &
0.6974, 0.7368, 0.7763, 0.8158, 0.8289, 0.8684, 0.9079, 0.9211, 0.9342, 0.9474, &
0.9605, 0.9737, 0.9868, 1.0000 /) !Array of derate values corresponding to the minimum pitch array
INTEGER(4)      						:: interpCounter !This is an index used by the minimum pitch interpolation DO loop.
  
LOGICAL, SAVE					:: Initialize = .TRUE.					!Flag used to initialize some saved variables on the first call to this subroutine

!=======================================================================
   ! Initialize saved variables on first call to subroutine
	IF ( Initialize ) THEN
		WRITE(*,*)  'First call to subroutine updateControlParameters(), '// &
'programmed by Eric Anderson. Subroutine can be found in UserSubs.f90 '
		Initialize = .FALSE.
		GenSpeedF  = HSS_Spd            ! This will ensure that generator speed filter will use the initial value of the generator speed on the first pass
		LastTime   = ZTime             ! This will ensure that generator speed filter will use the initial value of the generator speed on the first pass
	ENDIF
!=======================================================================
   ! Filter the HSS (generator) speed measurement:
   ! NOTE: This is a very simple recursive, single-pole, low-pass filter with
   !       exponential smoothing.
		! Update the coefficient in the recursive formula based on the elapsed time
		!   since the last call to the controller:
		Alpha     = EXP( ( LastTime - ZTime )*CornerFreq )
		! Apply the filter:
		GenSpeedF = ( 1.0 - Alpha )*HSS_Spd + Alpha*GenSpeedF
!=======================================================================
	!Derate Calculations
	IF (ZTime >= TimeDREnd) THEN
		!return turbine to normal operation
		FF_pwrFactor = 1.0 - DerateFactor + DerateFactor*(1.0 - pDR*(ZTime - &
		TimeDREnd)*EXP(-pDR*(ZTime - TimeDREnd)) - EXP(-pDR*(ZTime - TimeDREnd)))
	ELSEIF (ZTime >= TimeDRStart) THEN
		!Derate turbine
		FF_pwrFactor = 1.0 - DerateFactor*(1.0 - pDR*(ZTime - TimeDRStart)*&
		EXP(-pDR*(ZTime - TimeDRStart)) - EXP(-pDR*(ZTime - TimeDRStart)))
	ENDIF
!=======================================================================
	! Set pitch control parameters
	PC_RefSpd = PC_RefSpd_baseline*FF_pwrFactor
	DO interpCounter = 2, size(DRPitchArray)
 		IF ( (FF_pwrFactor .GT. DRArray(interpCounter-1) ) .AND. &
 		   (FF_pwrFactor .LT. DRArray(interpCounter) )) THEN 
 			PC_MinPit = DRPitchArray(interpCounter-1) +  ( DRPitchArray&
 			(interpCounter) - DRPitchArray(interpCounter-1) )*( FF_pwrFactor - &
DRArray(interpCounter-1) )/( DRArray(interpCounter) - DRArray(interpCounter-1) )
  			WRITE(*,*) 'PowerFactor = ',FF_pwrFactor,'  PC_MinPit =',PC_MinPit
  		ENDIF
  	ENDDO
!=======================================================================
	! Set torque control parameters	
	VS_Rgn2_K = VS_Rgn2K_baseline/(FF_pwrFactor**2) 	! Region 2 torque constant
	VS_RtPwr = VS_RtPwr_baseline*FF_pwrFactor		! Rated power
!=======================================================================
	! Check to see if emergency shutdown should be initiated
	IF ((ZTime > 30.0) .AND. (EmergencyShutdown .EQV. .FALSE.)) THEN ! If simulation has run long enough to pass the initial transient behavior and an emergency shutdown hasn't been requested yet. 
		IF ( ( ZTime > TEmShutdown ) .OR. ( (100*(HSS_Spd-PC_RefSpd_baseline)&
		    /PC_RefSpd_baseline) .GE. maxOverspeed)) THEN ! Should an emergency shutdown be requested now?
			EmergencyShutdown = .TRUE.
			WRITE(*,*)  'Emergency shutdown requested at T =',ZTime, &
			' Overspeed =',(100*(HSS_Spd-PC_RefSpd_baseline)/PC_RefSpd_baseline) 
		ENDIF
	ENDIF
!=======================================================================
! Reset the value of LastTime to the current value:
   LastTime = ZTime
     
RETURN
END SUBROUTINE updateControlParameters