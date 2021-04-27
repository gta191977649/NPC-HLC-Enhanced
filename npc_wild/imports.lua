NPC = exports.npc_hlc
Zone = exports.nh_Zone
--Player = exports.NH_Player
npcRoot = getResourceRootElement(getResourceFromName("npc_hlc"))
--函数
loadstring(exports.Lib:settingsGetInline())()
includeModule("bind.lua")
includeModule("table.lua")
includeModule("dx.lua")