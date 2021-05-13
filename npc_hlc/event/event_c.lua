addEventHandler ( "onClientPedDamage",root,function(attacker) 
    if isHLCEnabled(source) then
        triggerServerEvent("npc_hlc:onClientNPCDamage",root,source,attacker)
    end
end)

addEventHandler ( "onClientVehicleDamage",root,function(attacker) 
    local ped = getVehicleOccupant (source)
    if ped then 
        if isHLCEnabled(ped) and isElement(attacker) then
            triggerServerEvent("npc_hlc:onClientNPCVehicleDamage",root,source,attacker)
        end
    end
end)