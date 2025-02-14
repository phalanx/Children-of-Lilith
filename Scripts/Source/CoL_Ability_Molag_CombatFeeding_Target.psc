Scriptname CoL_Ability_Molag_CombatFeeding_Target extends activemagiceffect

CoL_Interface_Acheron Property iAcheron auto
Perk Property CombatFeeding_Active auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    iAcheron.defeatActor(akTarget)
    CoL.playerRef.RemovePerk(CombatFeeding_Active)
EndEvent