Scriptname CoL_Ability_Transform_FX_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
Perk Property safeTransformation Auto
Spell Property transformCostSpell Auto
bool Property simple = false Auto

Idle Property SuccubusTransformationIdle Auto
Sound Property SuccubusTransformSound Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    SuccubusTransformSound.Play(akTarget)
    if !simple
        Game.ForceThirdPerson()
        bool isTransformed = CoL.isTransformed
        if isTransformed 
            if CoL.lockTransform
                return
            else
                CoL.playerRef.removeSpell(transformCostSpell)
            endif
        else
            float cost
            if CoL.playerRef.HasPerk(safeTransformation)
                cost = configHandler.becomeEtherealCost
                configHandler.becomeEtherealCost = 0
                CoL.playerRef.AddSpell(CoL.becomeEthereal, false)
            endif
            if configHandler.transformAnimation && CoL.succuRace == CoL.mortalRace
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
            if CoL.playerRef.HasPerk(safeTransformation)
                CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
                configHandler.becomeEtherealCost = cost
            endif
            CoL.playerRef.AddSpell(transformCostSpell, false) ; Doing this in FX will prevent energy being reduced during the transform animation
        endif
    endif
EndEvent