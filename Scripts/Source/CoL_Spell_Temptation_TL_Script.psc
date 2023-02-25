Scriptname CoL_Spell_Temptation_TL_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.temptationCost
        return
    endif
    Bool ToysInstalled = Quest.GetQuest("toysframework")
    if ToysInstalled
        CoL.Log("Increasing target Toys-Rousing by Caressing") 
        ToysGlobal.Caress()
    endif
EndEvent
