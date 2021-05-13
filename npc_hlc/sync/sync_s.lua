-- Trigger when client request a data sync for a specific npc
addEvent("npc_hlc:onClientRequestNPCSync", true)
addEventHandler("npc_hlc:onClientRequestNPCSync",root,function(npc) 
    if all_npcs[npc] ~= nil then
        triggerClientEvent(client,"npc_hlc:onClientReceivedSync",client,all_npcs[npc])
    else
        print("NPC:HLC Error, Client Request Invaild NPC Data!")
    end
end)
