
addEvent("npc_hlc:onNPCDamage",true)
addEvent("npc_hlc:onClientNPCDamage",true)
addEventHandler("npc_hlc:onClientNPCDamage",root,function(npc,attacker)
    triggerEvent("npc_hlc:onNPCDamage",npc,attacker)
end)

addEvent("npc_hlc:onNPCVehicleDamage",true)
addEvent("npc_hlc:onClientNPCVehicleDamage",true)
addEventHandler("npc_hlc:onClientNPCVehicleDamage",root,function(veh,attacker)
    triggerEvent("npc_hlc:onNPCVehicleDamage",veh,attacker)
end)


addEvent("npc_hlc:onNPCVehicleJacked",true)
addEvent("npc_hlc:onClientNPCVehicleJacked",true)
addEventHandler("npc_hlc:onClientNPCVehicleJacked",root,function(npc,jacker)
    triggerEvent("npc_hlc:onNPCVehicleJacked",npc,jacker)
    print("jacked")
end)

