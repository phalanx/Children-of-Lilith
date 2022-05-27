Scriptname CoL_Mechanic_LevelHandler_Script extends Quest  

CoL_PlayerSuccubusQuestScript Property CoL Auto

GlobalVariable Property playerSuccubusLevel Auto

float playerSuccubusXP_var = 0.0
float Property playerSuccubusXP Hidden
    float Function Get()
        return playerSuccubusXP_var
    EndFunction
    Function Set(float newVal)
        playerSuccubusXP_var = newVal
        if CoL.DebugLogging
            Debug.Trace("[CoL] Xp Gained: " + newVal)
            Debug.Trace("[CoL] Current Xp: " + playerSuccubusXP_var)
        Endif
        if playerSuccubusXP_var > xpForNextLevel
            LevelUp()
        EndIf
    EndFunction
EndProperty
int Property playerMaxLevel = 100 Auto
float Property xpPerDrain = 1.0 Auto
float Property drainToDeathXPMult = 2.0 Auto
float Property xpForNextLevel = 1.0 Auto Hidden

float Property xpConstant = 0.75 Auto Hidden
float Property xpPower = 1.5 Auto Hidden

int Property levelsForPerk = 5 Auto

State Initialize
    Event OnBeginState()
        if CoL.DebugLogging
            Debug.Trace("[CoL] Initializing Level Handler")
        endif
        GoToState("Maintenance")
    EndEvent
EndState

State Maintenance
    Event OnBeginState()
        GoToState("Running")
    EndEvent
EndState

State Running
    Function gainXP(bool applyDeathMult)
        float xpMod = 1.0
        if applyDeathMult
            xpMod = drainToDeathXPMult
        endif
        playerSuccubusXP += (xpPerDrain * xpMod)
    EndFunction

    Function LevelUp()
        playerSuccubusLevel.Mod(1)
        Debug.Notification("Succubus Level Increased")
        Debug.Notification("New Level: " + playerSuccubusLevel.GetValueInt())

        if (playerSuccubusLevel.GetValueInt() % levelsForPerk) == 0
            AddPerk()
        endif

        xpForNextLevel = Math.pow(((playerSuccubusLevel.GetValueInt()+1)/xpConstant), xpPower)
        if CoL.DebugLogging
            Debug.Trace("[CoL] XP For Next Level: " + xpForNextLevel)
        endif
    EndFunction

    Function addPerk()
        if CoL.DebugLogging
            Debug.Trace("[CoL] Adding Perk")
        endif
    EndFunction
EndState

State Uninitialize
    Event OnBeginState()
        if CoL.DebugLogging
            Debug.Trace("[CoL] Uninitializing Level Handler")
        endif
    EndEvent
EndState

Function gainXP(bool applyDeathMult)
EndFunction

Function levelUp()
EndFunction

Function addPerk()
EndFunction