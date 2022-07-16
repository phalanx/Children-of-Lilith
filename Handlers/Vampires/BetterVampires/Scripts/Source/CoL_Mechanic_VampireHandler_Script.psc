Scriptname CoL_Mechanic_VampireHandler_Script extends Quest  
; For Better Vampires
PlayerVampireQuestScript Property playerVampireQuest Auto

Function Feed(Actor drainee)
    playerVampireQuest.VampireFeed(drainee)
EndFunction
