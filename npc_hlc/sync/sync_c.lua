-- Trigger and handle the server data sync
addEvent("npc_hlc:onClientReceivedSync", true)
addEventHandler("npc_hlc:onClientReceivedSync",root,function(syned_data) 
    --print("NPC Sync..")
    --iprint(syned_data)
end)

function requestNPCServerSync(npc) 
    triggerServerEvent("npc_hlc:onClientRequestNPCSync",root,npc)
end

addEventHandler("onClientElementDataChange", root, function(key, old, new) 
    --[[
    if isHLCEnabled(source) then 
        local taskno = split(key,"npchlc:task.")
        if #taskno > 1 then 
            taskno = tonumber(taskno[2])
            if taskno and new ~= nil then 
                streamed_npcs[source].tasks[taskno] = new
            end
        end
        
        if key == "thistask" then
            streamed_npcs[source].thistask = new
        end
        if key == "lasttask" then
            streamed_npcs[source].lasttask = new
        end

        --print(theKey)
    end
    ]]
end)