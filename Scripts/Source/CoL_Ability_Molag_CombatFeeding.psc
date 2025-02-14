Scriptname CoL_Ability_Molag_CombatFeeding extends activemagiceffect

Perk Property Combat_Feeding_Active_Perk auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    CoL.playerRef.AddPerk(Combat_Feeding_Active_Perk)
EndEvent
