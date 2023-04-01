Scriptname CoL_UI_ShowPerkMenu_Script extends activemagiceffect

GlobalVariable Property showPerkMenu Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    showPerkMenu.Mod(1)
EndEvent