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
        CoL.Log("Xp Gained: " + newVal)
        CoL.Log("Current Xp: " + playerSuccubusXP_var)
        if playerSuccubusXP_var > xpForNextLevel
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
        CoL.Log("Initializing Level Handler")
        if playerSuccubusLevel.GetValueInt() < 1
            playerSuccubusLevel.SetValueInt(1)
        endif
        GrantLevelledSpells(false)
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

    Function addPerkPoint()
        CoL.Log("Adding Perk")
        CoL.availablePerkPoints += perkPointsOnLevelUp 
    EndFunction

    Function calculateXpForNextLevel()
        xpForNextLevel = Math.pow(((playerSuccubusLevel.GetValueInt()+1)/xpConstant), xpPower)
    EndFunction
EndState

State Uninitialize
    Event OnBeginState()
        CoL.Log("Uninitializing Level Handler")
        CoL.RemoveSpells(CoL.levelOneSpells)
        CoL.RemoveSpells(CoL.levelTwoSpells)
        CoL.RemoveSpells(CoL.levelFiveSpells)
        CoL.RemoveSpells(CoL.levelTenSpells)
        GoToState("")
    EndEvent
EndState

Function gainXP(bool applyDeathMult)
EndFunction

Function LevelUp()
    
    playerSuccubusLevel.Mod(1)

    if (playerSuccubusLevel.GetValueInt() % levelsForPerk) == 0
        AddPerkPoint()
    endif
    
    GrantLevelledSpells()

    calculateXpForNextLevel()
    CoL.Log("XP For Next Level: " + xpForNextLevel)
    if playerSuccubusXP > xpForNextLevel
        LevelUp()
    else
        Debug.Notification("Succubus Level Increased")
        Debug.Notification("New Level: " + playerSuccubusLevel.GetValueInt())
    endif
EndFunction

Function GrantLevelledSpells(bool verbose = true)
    if (playerSuccubusLevel.GetValueInt() >= 1)
        CoL.GrantSpells(CoL.levelOneSpells, verbose)
    endif
    if (playerSuccubusLevel.GetValueInt() >= 2)
        CoL.GrantSpells(CoL.levelTwoSpells, verbose)
    endif
    if (playerSuccubusLevel.GetValueInt() >= 5)
        CoL.GrantSpells(CoL.levelFiveSpells, verbose)
    endif
    if (playerSuccubusLevel.GetValueInt() >= 10)
        CoL.GrantSpells(CoL.levelTenSpells, verbose)
    endif
EndFunction

Function addPerkPoint()
EndFunction

Function calculateXpForNextLevel()
EndFunction