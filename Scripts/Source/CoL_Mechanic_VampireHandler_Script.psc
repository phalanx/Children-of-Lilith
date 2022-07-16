Scriptname CoL_Mechanic_VampireHandler_Script extends Quest  
; For Vanilla, Scion, and Sacrosanct
CoL_PlayerSuccubusQuestScript Property CoL Auto
PlayerVampireQuestScript Property playerVampireQuest Auto

Function Feed(Actor drainee)
    playerVampireQuest.VampireFeed()
EndFunction
