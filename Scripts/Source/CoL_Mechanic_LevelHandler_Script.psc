Scriptname CoL_Mechanic_LevelHandler_Script extends Quest  

CoL_PlayerSuccubusQuestScript Property CoL Auto
GlobalVariable Property playerSuccubusLevel Auto
GlobalVariable Property perkPointsAvailable Auto
GlobalVariable Property levelUpRatio Auto
GlobalVariable Property levelUpMessage Auto
CoL_ConfigHandler_Script Property configHandler Auto

float playerSuccubusXP_var = 0.0
float Property playerSuccubusXP Hidden
    float Function Get()
        return playerSuccubusXP_var
    EndFunction
    Function Set(float newVal)
        playerSuccubusXP_var = newVal
        CoL.Log("Current Xp: " + playerSuccubusXP_var)
        if playerSuccubusXP_var >= xpForNextLevel
            LevelUp()
        EndIf
        levelUpRatio.SetValue((playerSuccubusXP_var - xpForPreviousLevel)/(xpForNextLevel - xpForPreviousLevel))
    EndFunction
EndProperty
int Property xpForNextLevel = 1 Auto Hidden
int Property xpForPreviousLevel Auto Hidden

State Initialize
    Event OnBeginState()
        CoL.Log("Initializing Level Handler")
        if playerSuccubusLevel.GetValueInt() < 1
            playerSuccubusLevel.SetValueInt(1)
        endif
        calculateXpForNextLevel()
        GrantLevelledSpells(false)
        GoToState("Running")
    EndEvent
EndState

State Running
    Function gainXP(float healthDrained, bool applyDeathMult)
        float xpMod = 1.0
        if applyDeathMult
            xpMod = configHandler.drainToDeathXPMult
        endif
        float xpGained = (healthDrained * configHandler.xpDrainMult * xpMod) + configHandler.xpPerDrain
        CoL.Log("Xp Gained: " + xpGained)
        playerSuccubusXP += xpGained
    EndFunction

    Function addPerkPoint()
        CoL.Log("Adding Perk")
        perkPointsAvailable.Mod(configHandler.perkPointsRecieved)
    EndFunction

    Function calculateXpForNextLevel()
        xpForPreviousLevel = xpForNextLevel
        xpForNextLevel = Math.pow(((playerSuccubusLevel.GetValueInt()+1)/configHandler.xpConstant), configHandler.xpPower) as int
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

Function gainXP(float healthDrained, bool applyDeathMult)
EndFunction

Function LevelUp()
    
    playerSuccubusLevel.Mod(1)

    if (playerSuccubusLevel.GetValueInt() % configHandler.levelsForPerk) == 0
        AddPerkPoint()
    endif
    
    GrantLevelledSpells()
    calculateXpForNextLevel()

    CoL.Log("XP For Next Level: " + xpForNextLevel)
    if playerSuccubusXP >= xpForNextLevel
        LevelUp()
    else
        Debug.Notification("Succubus Level Increased")
        Debug.Notification("New Level: " + playerSuccubusLevel.GetValueInt())
        levelUpMessage.SetValueInt(playerSuccubusLevel.GetValueInt())
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