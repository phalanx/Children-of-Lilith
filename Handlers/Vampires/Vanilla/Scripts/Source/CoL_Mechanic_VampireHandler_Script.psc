Scriptname CoL_Mechanic_VampireHandler_Script extends Quest  
; For Vanilla and Sacrosanct
PlayerVampireQuestScript Property playerVampireQuest Auto

Function Feed(Actor drainee)
    playerVampireQuest.VampireFeed()
EndFunction
