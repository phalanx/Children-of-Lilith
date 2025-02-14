Scriptname CoL_Global_Utils Hidden

bool Function IsMenuOpen() Global
    Return Utility.IsInMenuMode() || \
        UI.IsMenuOpen("Dialogue Menu") || \
        UI.IsMenuOpen("Console") || \
        UI.IsMenuOpen("Crafting Menu") || \
        UI.IsMenuOpen("BarterMenu") || \
        UI.IsMenuOpen("MessageBoxMenu") || \
        UI.IsMenuOpen("ContainerMenu") || \
        UI.IsTextInputEnabled()
endFunction