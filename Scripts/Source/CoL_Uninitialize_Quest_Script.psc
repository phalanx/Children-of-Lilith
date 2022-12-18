Scriptname CoL_Uninitialize_Quest_Script extends Quest  

ReferenceAlias Property drainVictimAlias Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

State Run
    Event OnBeginState()
        bool loop = true
        while loop
            Start()
            Actor drainVictim = drainVictimAlias.GetReference() as Actor
            if drainVictim != None
                CoL.Log("Cleaning Victim: " + drainVictim.GetDisplayName())
                drainVictim.RemoveFromFaction(CoL.drainVictimFaction)
                drainVictim.RemoveSpell(CoL.drainHealthSpell)
            else
                CoL.Log("Finished cleaning victims")
                loop = false
            endif
            Stop()
        endwhile
        GoToState("")
    EndEvent
EndState

