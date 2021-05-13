-- Trigger and handle the server data sync
addEvent("npc_hlc:onClientReceivedSync", true)
addEventHandler("npc_hlc:onClientReceivedSync",root,function(syned_data) 
    --print("NPC Sync..")
    --iprint(syned_data)
end)

function requestNPCServerSync(npc) 
    triggerServerEvent("npc_hlc:onClientRequestNPCSync",root,npc)
end