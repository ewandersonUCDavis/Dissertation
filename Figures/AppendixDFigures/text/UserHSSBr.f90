SUBROUTINE UserHSSBr ( GenTrq, ElecPwr, HSS_Spd, GBRatio, NumBl, ZTime, DT, DirRoot, & 
                       HSSBrFrac )

	! wrote a very simple High speed brake torque control routine. If the high speed 
	! shaft comes to a complete stop the high speed shaft brake will be engaged at 
	! full torque. Otherwise the brake will not be used. The intention is to keep the 
	! rotor stationary after an emergency shutdown, but not use the brake durring the 
	! emergency shutdown or in normal operation. (Eric Anderson)

USE                             Precision
USE								EAControl 	! contains LOGICAL variable EmergencyShutdown.

IMPLICIT                        NONE

   ! Passed Variables:

INTEGER(4), INTENT(IN )     :: NumBl     ! Number of blades, (-).
REAL(ReKi), INTENT(IN )     :: DT        ! Integration time step, sec.
REAL(ReKi), INTENT(IN )     :: ElecPwr ! Electrical power (account for losses), watts.
REAL(ReKi), INTENT(IN )     :: GBRatio   ! Gearbox ratio, (-).
REAL(ReKi), INTENT(IN )     :: GenTrq    ! Electrical generator torque, N-m.
REAL(ReKi), INTENT(IN )     :: HSS_Spd   ! HSS speed, rad/s.
REAL(ReKi), INTENT(OUT)     :: HSSBrFrac   ! Fraction of full braking torque: 0 (off) <= HSSBrFrac <= 1 (full), (-).
REAL(ReKi), INTENT(IN )     :: ZTime     ! Current simulation time, sec.
CHARACTER(1024), INTENT(IN ) :: DirRoot  ! The name of the root file including the full path to the current working directory.  
REAL(ReKi), SAVE		    :: brakeStartTime ! Time when HHS Brake is initiated.
LOGICAL, SAVE				:: brakeOff = .TRUE.
REAL(ReKi), PARAMETER		:: HSSBrDT = 0.6  ! Time it takes for HSS brake to reach full deployment once deployed.
	
IF  ( ( EmergencyShutdown ) .AND. ( GenSpeedF < 1 ) ) THEN ! If emergency shutdown has been initiated and generator speed is almost zero.

	IF ( brakeOff ) THEN
		brakeStartTime = ZTime
		brakeOff = .FALSE.
		WRITE(*,*)  'HSS Brake initiated at T =',ZTime,' GenSpeedF =',GenSpeedF
		HSSBrFrac = 0.0 
	ELSEIF ( (ZTime-brakeStartTime) < HSSBrDT ) THEN
		HSSBrFrac = (ZTime-brakeStartTime)/HSSBrDT
	ELSE
		HSSBrFrac = 1.0 !Engage brake
	ENDIF
ELSE
	HSSBrFrac = 0.0   
ENDIF

RETURN
END SUBROUTINE UserHSSBr