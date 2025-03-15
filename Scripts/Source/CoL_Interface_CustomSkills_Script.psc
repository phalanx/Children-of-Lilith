Scriptname CoL_Interface_CustomSkills_Script extends Quest

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    int CustomSkillsVersion = CustomSkills.GetAPIVersion()
    if CustomSkillsVersion != 0
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return true
    endFunction
    Function OpenCustomSkillMenu(string skillName)
        CustomSkills.OpenCustomSkillMenu(skillName)
    endFunction
    Function IncrementSkill(string skillName)
        CustomSkills.IncrementSkill(skillName)
    endFunction
EndState

bool Function IsInterfaceActive()
    return false
EndFunction

Function OpenCustomSkillMenu(string skillName)
    return
endFunction

Function IncrementSkill(string skillName)
    return
endFunction