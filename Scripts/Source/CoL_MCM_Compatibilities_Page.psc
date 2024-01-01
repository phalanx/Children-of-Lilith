Scriptname CoL_MCM_Compatibilities_Page extends nl_mcm_module

Quest Property oStim_Interfaces Auto
Quest Property SexLab_Interfaces Auto

Event OnInit()
    RegisterModule("$COL_COMPATIBILITIESPAGE_NAME", 80)
EndEvent

Event OnPageInit()
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("OStim")
    AddToggleOptionST("OStim", "OStim", (oStim_Interfaces as CoL_Interface_Ostim_Script).IsInterfaceActive(), OPTION_FLAG_DISABLED)
    AddHeaderOption("SexLab")
    AddToggleOptionST("SexLab", "SexLab", (SexLab_Interfaces as CoL_Interface_SexLab_Script).IsInterfaceActive(), OPTION_FLAG_DISABLED)
    AddToggleOptionST("SLSO", "SexLab Separate Orgasms", Quest.GetQuest("SLSO"), OPTION_FLAG_DISABLED)
    AddToggleOptionST("SLAR", "SexLab Aroused", (SexLab_Interfaces as CoL_Interface_SLAR_Script).IsInterfaceActive(), OPTION_FLAG_DISABLED)
    AddHeaderOption("Toys & Love")
    AddToggleOptionST("TL", "Toys & Love", Game.IsPluginInstalled("Toys.esm"), OPTION_FLAG_DISABLED)
    AddHeaderOption("OSL Aroused")
    AddToggleOptionST("OSL", "OSL Aroused", Game.IsPluginInstalled("OSLAroused.esp"), OPTION_FLAG_DISABLED)
    AddHeaderOption("SlaveTats")
    AddToggleOptionST("SlaveTats", "SlaveTats", Game.IsPluginInstalled("SlaveTats.esp"), OPTION_FLAG_DISABLED)
EndEvent