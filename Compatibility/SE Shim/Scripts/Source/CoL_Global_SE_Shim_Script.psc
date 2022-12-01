Scriptname CoL_Global_SE_Shim_Script Hidden

import PapyrusUtil

Form[] Function RemoveDupeForm(Form[] ArrayValues) global
    Debug.Trace("[CoL] Using SE Shim")
    Form[] newList = new Form[1]
    return ClearNone(MergeFormArray(ArrayValues, newList, true))
EndFunction

Actor[] Function RemoveDupeActor(Actor[] ArrayValues) global
    Debug.Trace("[CoL] Using SE Shim")
    Actor[] newList = new Actor[1]
    return MergeActorArray(ArrayValues, newList, true)
EndFunction