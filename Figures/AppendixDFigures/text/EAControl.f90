MODULE EAControl

! This MODULE stores variables used in the controllers programmed by Eric Anderson.
   
USE                             Precision

! Parameters read in from input file primary.fst    
REAL(ReKi) :: TimeDRStart   ! Time for turbine to initiate derating
REAL(ReKi) :: TimeDREnd ! Time for turbine to start returning to full rated operation
REAL(ReKi) :: DerateFactor  ! Ammount turbine will be derated (fraction of 1)
REAL(ReKi) :: TEmShutdown	! Time to initiate an emergency shutdown of the turbine
REAL(ReKi) :: maxOverspeed	! The maximum safe overspeed (%). An overspeed larger than this will initiate an emergency shutdown.

! The following variables are used by several control subroutines.
LOGICAL	   :: EmergencyShutdown = .FALSE. ! Signal instructing the turbine to execute emergency shutdown. Will remain FALSE unless changed by overspeed or TEmShutdown.
REAL(ReKi) :: GenSpeedF   ! Filtered HSS (generator) speed, rad/s.
REAL(ReKi) :: PC_RefSpd   ! Desired (reference) HSS speed for pitch controller, rad/s.
REAL(ReKi) :: PC_MinPit   ! Minimum pitch setting in pitch controller, rad.
REAL(ReKi) :: VS_Rgn2_K   ! Generator torque constant in Region 2 (HSS side), N-m/(rad/s)^2.
REAL(ReKi) :: VS_RtPwr    ! Rated generator generator power in Region 3, Watts. -- chosen to be 5MW divided by the electrical
LOGICAL    :: controlDebug ! Flag to turn on debug output for controller
INTEGER(4) :: modCounterPitch = 1 ! Counter to see how often module data is accessed.
INTEGER(4) :: modCounterTorque = 1 ! Counter to see how often module data is accessed.
