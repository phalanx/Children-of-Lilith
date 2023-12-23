Scriptname CoL_Global_SLCumOverlays_Script Hidden

function reapplySCOEffects(Quest scoCumHandler, Actor playerRef) global
    Spell CumSpell = StorageUtil.GetFormValue(playerRef, "SCO_CumSpell") as Spell
    (scoCumHandler as SCO_CumHandler).ReAddCum(playerRef, CumSpell)
endfunction