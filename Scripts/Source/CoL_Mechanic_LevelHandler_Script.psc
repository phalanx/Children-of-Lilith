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
        if playerSuccubusXP_var >= xpForNextLevel
            LevelUp()
        EndIf
    EndFunction
EndProperty
int Property playerMaxLevel = 100 Auto
float Property xpPerDrain = 1.0 Auto
float Property drainToDeathXPMult = 2.0 Auto
float Property xpForNextLevel = 1.0 Auto Hidden

float xpConstant_var = 0.75
float Property xpConstant Hidden
    float Function Get()
        return xpConstant_var
    EndFunction
    Function Set(float new_val)
        xpConstant_var = new_val
        calculateXpForNextLevel()
    EndFunction
endProperty
float xpPower_var = 1.5
float Property xpPower Hidden
    float Function Get()
        return xpPower_var
    EndFunction
    Function Set(float new_val)
        xpPower_var = new_val
        calculateXpForNextLevel()
    EndFunction
endProperty
int Property levelsForPerk = 1 Auto
int Property perkPointsOnLevelUp = 1 Auto

State Initialize
    Event OnBeginState()
        if CoL.DebugLogging
            Debug.Trace("[CoL] Initializing Level Handler")
        endif
        GoToState("Running")
    EndEvent
EndState

State Running
    Event OnBeginState()
        int i = 0
        while i < playerSuccubusLevel.GetValueInt()
            LevelUp(true)
            i += 1
        endwhile
    EndEvent
    Function gainXP(bool applyDeathMult)
        float xpMod = 1.0
        if applyDeathMult
            xpMod = drainToDeathXPMult
        endif
        playerSuccubusXP += (xpPerDrain * xpMod)
    EndFunction

    Function LevelUp(bool catchup=false)
        if !catchup
            playerSuccubusLevel.Mod(1)
        endif

        if (playerSuccubusLevel.GetValueInt() % levelsForPerk) == 0
            AddPerkPoint()
        endif
        if (playerSuccubusLevel.GetValueInt() == 1)
            CoL.GrantSpells(CoL.levelOneSpells)
        endif
        if (playerSuccubusLevel.GetValueInt() == 2)
            CoL.GrantSpells(CoL.levelTwoSpells)
        endif

        calculateXpForNextLevel()
        if CoL.DebugLogging
            Debug.Trace("[CoL] XP For Next Level: " + xpForNextLevel)
        endif
        if playerSuccubusXP > xpForNextLevel
            LevelUp()
        else
            Debug.Notification("Succubus Level Increased")
            Debug.Notification("New Level: " + playerSuccubusLevel.GetValueInt())
        endif
    EndFunction

    Function addPerkPoint()
        if CoL.DebugLogging
            Debug.Trace("[CoL] Adding Perk")
        endif
        CoL.availablePerkPoints += perkPointsOnLevelUp 
    EndFunction

    Function calculateXpForNextLevel()
        xpForNextLevel = Math.pow(((playerSuccubusLevel.GetValueInt()+1)/xpConstant), xpPower)
    EndFunction

    Event OnEndState()
        CoL.RemoveSpells(CoL.levelOneSpells)
        CoL.RemoveSpells(CoL.levelTwoSpells)
    EndEvent
EndState

State Uninitialize
    Event OnBeginState()
        if CoL.DebugLogging
            Debug.Trace("[CoL] Uninitializing Level Handler")
        endif
        GoToState("")
    EndEvent
EndState

Function gainXP(bool applyDeathMult)
EndFunction

Function levelUp(bool catchup=false)
EndFunction

Function addPerkPoint()
EndFunction

Function calculateXpForNextLevel()
EndFunction