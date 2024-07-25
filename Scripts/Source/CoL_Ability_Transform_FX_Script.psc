Scriptname CoL_Ability_Transform_FX_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
bool Property simple = false Auto

Idle Property SuccubusTransformationIdle Auto
Sound Property SuccubusTransformSound Auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
    CoL.transformReadiness[0] = false
    SuccubusTransformSound.Play(akTarget)
    if !simple
        Game.ForceThirdPerson()
        bool isTransformed = CoL.isTransformed
        if !isTransformed 
            if configHandler.transformAnimation && CoL.succuRace == CoL.mortalRace && !CoL.PlayerArmsBound()
                bool weaponDrawn
                if CoL.playerRef.IsWeaponDrawn()
                    weaponDrawn = true
                    CoL.playerRef.SheatheWeapon()
                    Utility.Wait(2)
                endif
                akTarget.PlayIdle(SuccubusTransformationIdle)
                Utility.Wait(5)
                Debug.SendAnimationEvent(akTarget, "IdleForceDefaultState")
                if weaponDrawn
                    CoL.playerRef.DrawWeapon()
                    Utility.Wait(2)
                endif
            endif
        endif
    endif
    CoL.transformReadiness[0] = true
EndEvent

Function Log(string msg)
    CoL.Log("Transform - FX - " + msg)
EndFunction