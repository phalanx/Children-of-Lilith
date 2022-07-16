Scriptname CoL_Mechanic_VampireHandler_Script extends Quest  
; For Sanguinaire

CoL_PlayerSuccubusQuestScript Property CoL Auto
PlayerVampireQuestScript Property playerVampireQuest Auto

Function Feed(Actor drainee)
    playerVampireQuest.VampireFeed(CoL.playerRef, drainee)
EndFunction
