Scriptname CoL_Ability_BecomeEthereal_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if Col.playerEnergyCurrent >= configHandler.becomeEtherealCost
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Out of Energy: Become Ethereal Disabled")
        CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
    endif
EndEvent

Event OnUpdate()
    if Col.playerEnergyCurrent < configHandler.becomeEtherealCost
        CoL.Log("Out of Energy")
        Debug.Notification("Out of Energy: Become Ethereal Disabled")
        Col.playerEnergyCurrent = 0
        CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
        return
    endif
    CoL.playerEnergyCurrent -= configHandler.becomeEtherealCost
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
EndEvent