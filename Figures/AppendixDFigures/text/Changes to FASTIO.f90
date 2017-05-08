!  -------------- DERATE PARAMETERS --------------------------------------------

   ! Skip the comment line.
   CALL ReadCom ( UnIn, PriFile, 'derate parameters' )
   
   ! TimeDRStart - Time for turbine to initiate derating
CALL ReadRVar ( UnIn, PriFile, TimeDRStart, 'TimeDRStart', 'Time for turbine to initiate derating' )

   ! TimeDREnd - Time for turbine to start returning to full rated operation
CALL ReadRVar ( UnIn, PriFile, TimeDREnd, 'TimeDREnd', 'Time for turbine to start  returning to full rated operation' )

   ! DerateFactor - Ammount turbine will be derated
CALL ReadRVar ( UnIn, PriFile, DerateFactor, 'DerateFactor', 'Ammount turbine will be derated' )

    ! TEmShutdown - Time to initiate an emergency shutdown
CALL ReadRVar ( UnIn, PriFile, TEmShutdown, 'TEmShutdown', 'Time to initiate emergency shutdown' )

   ! maxOverspeed - The maximum safe overspeed (%).
CALL ReadRVar (UnIn,PriFile, maxOverspeed, 'maxGenOS', 'The maximum safe overspeed (%).' ) 

   ! controlDebug - Flag to turn on debug output for controller.
CALL ReadLVar ( UnIn, PriFile, controlDebug, 'controlDebug', 'Flag to turn on debug &
                output for controller' ) 