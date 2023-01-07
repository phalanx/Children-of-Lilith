Scriptname CoL_Mechanic_VampireHandler_Script extends Quest  
; For Vampiric Thirst

CoL_PlayerSuccubusQuestScript Property CoL Auto
PlayerVampireQuestScript Property playerVampireQuest Auto

Function Feed(Actor drainee)
    playerVampireQuest.VampireFeed(drainee, 0, 0)
EndFunction

