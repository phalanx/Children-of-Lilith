Scriptname CoL_ConfigHandler_Script extends Quest

float Property baseMaxEnergy = 100.0 Auto Hidden
string[] Property followedPathOptions Auto Hidden
int Property selectedPath = 0 Auto Hidden
bool Property DebugLogging = false Auto Hidden
bool Property EnergyScaleTestEnabled = false Auto Hidden
bool Property npcSuccubusEnabled = false Auto Hidden

Event OnInit()
    followedPathOptions = new string[3]
    followedPathOptions[0] = "$COL_STATUSPAGE_PATH_SANQUINE"
    followedPathOptions[1] = "$COL_STATUSPAGE_PATH_MOLAG"
    followedPathOptions[2] = "$COL_STATUSPAGE_PATH_VAERMINA"
EndEvent