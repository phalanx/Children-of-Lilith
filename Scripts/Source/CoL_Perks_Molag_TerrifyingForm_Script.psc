Scriptname CoL_Perks_Molag_TerrifyingForm_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Acheron Property iAcheron Auto

Function Log(string msg)
    CoL.Log("Terrifying Form - " + msg)
endFunction

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if !iAcheron.IsInterfaceActive()
        return
    endif
    Log("Defeating " + akTarget.GetName())
    iAcheron.defeatActor(akTarget)
EndEvent