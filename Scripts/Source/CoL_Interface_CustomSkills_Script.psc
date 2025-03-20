Scriptname CoL_Interface_CustomSkills_Script extends Quest

GlobalVariable Property playerSuccubusLevel Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

int detectedCSFVersion

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    Utility.Wait(5)
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    detectedCSFVersion = CustomSkills.GetAPIVersion()
    Log("Detected Version: " + detectedCSFVersion)
    if detectedCSFVersion > 0
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

Function Log(string msg)
    CoL.Log("Interface - CSF - " + msg)
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return true
    endFunction
    Function OpenCustomSkillMenu(string skillName)
        CustomSkills.OpenCustomSkillMenu(skillName)
    endFunction
EndState

bool Function IsInterfaceActive()
    return false
EndFunction

Function OpenCustomSkillMenu(string skillName)
endFunction