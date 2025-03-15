Scriptname CoL_UI_ShowPerkMenu_Script extends activemagiceffect

CoL_Interface_CustomSkills_Script Property CustomSkillsInterface Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    CustomSkillsInterface.OpenCustomSkillMenu("col_succubus_skill")
EndEvent