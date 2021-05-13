UPDATE_COUNT = 35
UPDATE_INTERVAL_MS = 2000

local streamed_npcs = {}
Async:setDebug(false)

--Async:setPriority(500, 33); 
addEventHandler( "onClientElementStreamIn", root,
    function ( )
        if getElementType( source ) == "ped" then
            if isHLCEnabled(source) then
				streamed_npcs[source] = true
			end
        end
    end
);
addEventHandler( "onClientElementStreamOut", root,
    function ( )
        if getElementType( source ) == "ped" then
            if isHLCEnabled(source) then
				streamed_npcs[source] = nil
			end
        end
    end
);

function cycleNPCs() 
	Async:setPriority("low")
	Async:forkey(streamed_npcs,function(npc,val) 
		if isElement(npc) and getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			local task = getNPCCurrentTask(npc)
			if task then
				if performTask[task[1]](npc,task) then
					setNPCTaskToNext(npc)
				end
			else
				stopAllNPCActions(npc)
			end
		end
	end,function() 
		initNPCControl()
	end)
end


function initNPCControl()
	--addEventHandler("onClientHUDRender",root,cycleNPCs,true,"low")
	setTimer ( cycleNPCs, UPDATE_COUNT,1)

end