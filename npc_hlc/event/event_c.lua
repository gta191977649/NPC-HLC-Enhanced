addEventHandler ( "onClientPedDamage",root,function(attacker) 
    if isHLCEnabled(source) then
        triggerServerEvent("npc_hlc:onClientNPCDamage",root,source,attacker)
    end
end)

addEventHandler ( "onClientVehicleDamage",root,function(attacker) 
    local ped = getVehicleOccupant (source)
    if ped then 
        if isHLCEnabled(ped) and attacker ~= nil and isElement(attacker) then
            triggerServerEvent("npc_hlc:onClientNPCVehicleDamage",root,source,attacker)
        end
    end
end)
--onClientNPCVehicleJacked

function onNPCVehicleJacked(npc,jacker) 
    triggerServerEvent("npc_hlc:onClientNPCVehicleJacked",root,npc,jacker)
    removeEventHandler("onClientPedVehicleExit", npc,onNPCVehicleJacked)
end

addEventHandler("onClientVehicleStartEnter", root, function(player,seat,door)
	local ped = getVehicleOccupant (source,seat)
    if isHLCEnabled(ped) then 
        addEventHandler("onClientPedVehicleExit", ped,function() 
            onNPCVehicleJacked(ped,player)
        end,false)
    end
end)


--[[
addEventHandler("onClientPedVehicleExit", root, function(vehicle) 
    if isHLCEnabled(source) then
        local task = getNPCCurrentTask(source)
        triggerServerEvent("npc_hlc:onClientNPCVehicleJacked",root,source,localPlayer)
    end
end)
]]