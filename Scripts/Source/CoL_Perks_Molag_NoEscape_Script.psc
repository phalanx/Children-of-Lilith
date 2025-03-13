Scriptname CoL_Perks_Molag_NoEscape_Script extends activemagiceffect


Event OnEffectStart(Actor akTarget, Actor akCaster)
    Debug.Trace("Starting No Escape")
    akTarget.ModActorValue("CarryWeight",0.1)
    akTarget.ModActorValue("CarryWeight",-0.1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Debug.Trace("Ending No Escape")
    akTarget.ModActorValue("CarryWeight",0.1)
    akTarget.ModActorValue("CarryWeight",-0.1)
EndEvent
