#!/bin/bash


function serialize(){
    spriggit serialize -i ./ChildrenOfLilith.esp -o ./ESP/ChildrenOfLilith -g SkyrimSE --PackageName Spriggit.Yaml &
    spriggit serialize -i ./Handlers/ASkyrimKiss/ChildrenOfLilithASKPatch.esp -o ./ESP/ASKPatch -g SkyrimSE --PackageName Spriggit.Yaml &
    spriggit serialize -i ./Handlers/FlowerGirls/ChildrenOfLilithFGPatch.esp -o ./ESP/FGPatch -g SkyrimSE --PackageName Spriggit.Yaml &
    spriggit serialize -i ./Handlers/ImmersiveLapSitting/CoL_ILS_Patch.esp -o ./ESP/ILS -g SkyrimSE --PackageName Spriggit.Yaml &
    spriggit serialize -i ./Compatibility/ChildrenOfLilithVancianPatch.esp -o ./ESP/Vancian -g SkyrimSE --PackageName Spriggit.Yaml &
}

function deserialize(){
    spriggit deserialize -o ./ChildrenOfLilith.esp -i ./ESP/ChildrenOfLilith --PackageName Spriggit.Yaml &
    spriggit deserialize -o ./Handlers/ASkyrimKiss/ChildrenOfLilithASKPatch.esp -i ./ESP/ASKPatch --PackageName Spriggit.Yaml &
    spriggit deserialize -o ./Handlers/FlowerGirls/ChildrenOfLilithFGPatch.esp -i ./ESP/FGPatch --PackageName Spriggit.Yaml &
    spriggit deserialize -o ./Handlers/ImmersiveLapSitting/CoL_ILS_Patch.esp -i ./ESP/ILS --PackageName Spriggit.Yaml &
    spriggit serialize -o ./Compatibility/ChildrenOfLilithVancianPatch.esp -i ./ESP/Vancian --PackageName Spriggit.Yaml &
}

if [[ "$1" == "serialize" ]]; then
    serialize
elif [[ "$1" == "deserialize" ]]; then
    deserialize
fi

wait