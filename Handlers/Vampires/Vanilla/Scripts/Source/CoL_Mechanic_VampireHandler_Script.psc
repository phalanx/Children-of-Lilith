Scriptname CoL_Mechanic_VampireHandler_Script extends Quest  

PlayerVampireQuestScript Property playerVampireQuest Auto

Function Feed(Actor drainee)
    playerVampireQuest.VampireFeed()
EndFunction
