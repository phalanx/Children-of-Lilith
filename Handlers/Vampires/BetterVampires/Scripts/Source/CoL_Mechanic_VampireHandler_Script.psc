Scriptname CoL_Mechanic_VampireHandler_Script extends Quest  
; For Better Vampires
CoL_PlayerSuccubusQuestScript Property CoL Auto
PlayerVampireQuestScript Property playerVampireQuest Auto

Function Feed(Actor drainee)
    playerVampireQuest.VampireFeed(drainee)
EndFunction
