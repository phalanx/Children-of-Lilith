Scriptname CoL_Global_SlaveTats_Script Hidden

Function reapplySlaveTats(Actor target, bool silent = false) global
    SlaveTats.mark_actor(target)
    SlaveTats.synchronize_tattoos(target, silent)
endFunction