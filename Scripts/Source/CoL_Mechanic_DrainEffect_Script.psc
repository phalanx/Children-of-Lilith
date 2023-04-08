Scriptname CoL_Mechanic_DrainEffect_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectFinish(Actor drainTarget, Actor akTarget)
    StorageUtil.UnsetFloatValue(drainTarget, "CoL_drainRemovalDay")
    StorageUtil.UnsetFloatValue(drainTarget, "CoL_drainAmount")
    drainTarget.RemoveFromFaction(CoL.drainVictimFaction)
    drainTarget.RemoveSpell(CoL.DrainHealthSpell)
EndEvent