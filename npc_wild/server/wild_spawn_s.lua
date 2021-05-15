MAX_NO_BOTS_SPAWNED = 100 --enforces 最大 100 bots 产生 at a time; 商人和任务NPC extempt; nil 代表无限制; TODO: move this in a settings file TODO: make a settings file

--[[
local raiderMeleeWeapons = {2,4,8,5,10,11,12}--{ 33,25,24,30,27,31}
local raiderGunnerWeapons = {25,30,33,24}--{ 33,25,24,30,27,31}
local banditGunnerWeapons = {25,30,33,27,29} -- 强盗武器
local scavGunnerWeapons = {29,30,25}--{ 33,25,24,30,27,31}
local cdfGunnerWeapons = {30,31,29}--{ 33,25,24,30,27,31}
local estabGunnerWeapons = {27,31}--{ 33,25,24,30,27,31}

raiderSkin = {108,109, 181, 247, 248, 242, 293 }
cdfSkin = {73,16,176,179,2,21,278}
specSkin = {285}
armySkin = {287}
]]

bot_cols = {} -- NPC 碰撞表

----OK, A NEW SPAWNING APPROACH, USING THE EDF SPAWNPOINT ELEMENTS:
--1. parse through all "[..]_spawn" elements and create colshapes

function setupBotSpawnCols (resource)

    local botspawns = { }
    local Raider_spawns = getElementsByType ( "Raider_spawn" )
    local CDF_spawns = getElementsByType ( "CDF_spawn" )
    local Establishment_spawns = getElementsByType ( "Establishment_spawn" )
    local Bandit_spawns = getElementsByType ( "Bandit_spawn" )
    local Scavenger_spawns = getElementsByType ( "Scavenger_spawn" )
    local Neutral_spawns = getElementsByType ( "Neutral_spawn" )
    local Zombie_spawns = getElementsByType ( "Zombie_spawn" )

    outputDebugString("loading bot spawnpoints...")

    --格式
    --theBot

	for BotKey,theBot in ipairs(Raider_spawns) do
		table.insert( botspawns, theBot )
	end
	for BotKey,theBot in ipairs(CDF_spawns) do
		table.insert( botspawns, theBot )
	end
	for BotKey,theBot in ipairs(Establishment_spawns) do
		table.insert( botspawns, theBot )
	end
	for BotKey,theBot in ipairs(Bandit_spawns) do
		table.insert( botspawns, theBot )
	end
	for BotKey,theBot in ipairs(Scavenger_spawns) do
		table.insert( botspawns, theBot )
	end
	for BotKey,theBot in ipairs(Neutral_spawns) do
		table.insert( botspawns, theBot )
	end
	for BotKey,theBot in ipairs(Zombie_spawns) do
        --outputDebugString(inspect(theBot))
		table.insert( botspawns, theBot )
	end
	
	for _,botspawn in ipairs(botspawns) do

		local x = getElementData(botspawn, "posX") 
		local y = getElementData(botspawn, "posY") 
		local z = getElementData(botspawn, "posZ")
		local botRange = getElementData(botspawn, "botRange") -- 产生范围
			
		local spawnRadiusCol = createColSphere (x,y,z,botRange) -- bot 产生 col 半径
		setElementData(spawnRadiusCol,"botToSpawn",botspawn) -- 为COL绑定产生用的数据
		setElementData(spawnRadiusCol,"botWasSpawned",false) -- 设置COL已产生为否
		setElementData(source,"theSpawnedBotPed",false) -- 设置当前资源已产生的BOT为否

		table.insert(bot_cols, spawnRadiusCol) -- BOT 碰撞表

        addEventHandler("onColShapeHit",spawnRadiusCol,onHitF)
        addEventHandler("onColShapeLeave",spawnRadiusCol,onLeaveF)

	end

    outputDebugString("create bot spawn col:"..#bot_cols)

end
--服务器启动时
--暂时关闭用于测试
addEventHandler("onResourceStart",resourceRoot,setupBotSpawnCols)
--2. onColShapeHit: 
	-- is bot already spawned?
		-- Y: return
		-- N: spawn bot; mark as spawned
function onHitF(hitElem,dim)

	--if not getElementData(source,"botToSpawn") then return end --if it ain't a spawncol then return
	if getElementType(hitElem) ~= "player" then return end -- 只有玩家能触发检测
	if not getElementDimension(hitElem)==1 then return end;
	if isTimer(getElementData(source,"respawnTimer")) then return end --if there is a respawntimer active on the bot then return
	if getElementData (source,"botWasSpawned") == true then -- 如果BOT已产生不继续执行
	    return
	elseif getElementData (source,"botWasSpawned") == false then -- it's a spawn col and the bot has not spawned yet; we proceed with spawning

	    spawnpoint = getElementData(source,"botToSpawn") -- 获取产生用的数据
        --outputDebugString(inspect(spawnpoint));

        if MAX_NO_BOTS_SPAWNED then

            local playersonline = getElementsByType("player") -- 在线玩家数量
            local allpeds = getElementsByType("ped") -- 所有PED数量
            local numbotsspawned = (#allpeds-#playersonline) -- 所有PED数量-在线玩家数量
            local typecheck = getElementData(spawnpoint,"BotType") or false
            local forcedSpawn = false
            
            --根据type判断是否强制产生
            if typecheck == "Vendor" 
            or typecheck == "ScavVendor"
            or typecheck == "WasteVendor"
            or typecheck == "SyndVendor"
            or typecheck == "Quest"
            or typecheck == "ScavQuest"
            or typecheck == "SyndQuest"
            or typecheck == "WasteQuest"
            then
                forcedSpawn = true
            end

            if numbotsspawned >= MAX_NO_BOTS_SPAWNED and forcedSpawn == false then return end -- if max bot number is set and reached then return, unless they are traders or quest NPCs

        end

        local x = getElementData(spawnpoint, "posX") 
        local y = getElementData(spawnpoint, "posY") 
        local z = getElementData(spawnpoint, "posZ")
        local r = getElementData(spawnpoint, "rotZ")
        botType = getElementData (spawnpoint,"BotType") or false
        botName = getElementData (spawnpoint,"name") or false
        botSkinID = getElementData (spawnpoint,"botSkinID") or false -- 用于固定皮肤刷新
        ZedType = getElementData (spawnpoint,"ZedType") or false

        spawnType = getElementType(spawnpoint)
        local faction = string.lower(string.gsub(spawnType,"_spawn",""))
        --outputDebugString("TRY COL NPC spawnType:"..tostring(faction).." botType:"..tostring(botType or ZedType).." with Name:"..tostring(botName));

        local cType = "normal";
        if faction == "neutral" then
			if botType =="Goat" then
				cType = "goat"
			elseif botType =="WildPig" then
				cType = "wolf"
			elseif botType =="Freelance" then
				--中立NPC
			elseif botType =="Bear" then
				cType = "bear"
			end
        elseif faction == "zombie" then
			if ZedType == "Walker" then
				cType = "infected"
			elseif ZedType == "Runner" then
				cType = "hunter"
			elseif ZedType == "Brute" then
				cType = "hunter"
			end
        end
        --[[
		if spawnType == "Raider_spawn" then
			if botType == "Guard" then
				ped = createRaiderGuard(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
				
			elseif botType =="Hunter" then
				ped = createRaiderHunter(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Slave" then
				ped = createRaiderSlave(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Meat" then
				ped = createRaiderMeat(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Vendor" then
				ped = createRaiderVendor(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Quest" then
				ped = createRaiderQuestGiver(x,y,z,r,team,botName,botSkinID) 
				setElementData(source,"theSpawnedBotPed", ped)
			end

		elseif spawnType == "CDF_spawn" then
			if botType == "Guard" then
				ped = createCDFGuard(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Staff" then
				ped = createCDFStaff(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Vendor" then
				ped = createCDFVendor(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Quest" then
				ped = createCDFQuestGiver(x,y,z,r,team,botName,botSkinID)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Hunter" then
				ped = createCDFHunter(x,y,z,r,team,botName,botSkinID)	
				setElementData(source,"theSpawnedBotPed", ped)
			end
			
		elseif spawnType == "Establishment_spawn" then
			if botType == "Grunt" then
				ped = createEstablishmentGrunt(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Heavy" then
				ped = createEstablishmentHeavy(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Rescue01" then
				ped = createEstablishmentR01(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Rescue01heavy" then
				ped = createEstablishmentR01H(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Spec" then
				ped = createEstablishmentSpec(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Peacekeeper" then
				ped = createEstablishmentPeacekeeper(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Refugee" then
				ped = createEstablishmentRefugee(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Quest" then
				ped = createEstablishmentQuestGiver(x,y,z,r,team,botName,botSkinID)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Cleaner" then
				ped = createEstablishmentCleaner(x,y,z,r,team,botName,botSkinID)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Staff" then
				ped = createEstablishmentStaff(x,y,z,r,team,botName,botSkinID)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="ArmyPatrol" then
				ped = createEstablishmentArmyPatrol(x,y,z,r,team,botName,botSkinID)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="R01Patrol" then
				ped = createEstablishmentR01Patrol(x,y,z,r,team,botName,botSkinID)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="PeacekePatrol" then
				ped = createEstablishmentPeacekeepPatrol(x,y,z,r,team,botName,botSkinID)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Suit" then
				ped = createEstablishmentSuit(x,y,z,r,team,botName,botSkinID)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="VIP" then
				ped = createEstablishmentVIP(x,y,z,r,team,botName,botSkinID)
				setElementData(source,"theSpawnedBotPed", ped)
			end
			

		elseif spawnType == "Bandit_spawn" then
			if botType =="Guard" then
				ped = createBanditGuard(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Hunter" then
				ped = createBanditHunter(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Quest" then
				ped = createBanditQuestGiver(x,y,z,r,team,botName,botSkinID)	
				setElementData(source,"theSpawnedBotPed", ped)
			end
			
		elseif spawnType == "Neutral_spawn" then
			
		elseif spawnType == "Scavenger_spawn" then --place slothbot entries first, otherwise they engage the civs
			if botType =="ScavGuard" then
				ped = createScavengerGuard(x,y,z,r,team,weap) 
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="WasteFreelance" then
				ped = createWastefreelancer(x,y,z,r,team,weap) 
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Nang" then
				ped = createSyndicateNang(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Triad" then
				ped = createSyndicateTriad(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Freelance" then
				ped = createScavengerFreelancer(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="WasteGuard" then
				ped = createWasteGuard(x,y,z,r,team,weap) 
				setElementData(source,"theSpawnedBotPed", ped)
				
			elseif botType =="ScavVendor" then
				ped = createScavengerVendor(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="WasteVendor" then
				ped = createWasteVendor(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="SyndVendor" then
				ped = createSyndVendor(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="ScavQuest" then
				ped = createScavQuestGiver(x,y,z,r,team,botName,botSkinID) 
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="WasteQuest" then
				ped = createWasteQuestGiver(x,y,z,r,team,botName,botSkinID)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="SyndQuest" then
				ped = createSyndQuestGiver(x,y,z,r,team,botName,botSkinID)	
				setElementData(source,"theSpawnedBotPed", ped)	
				
			elseif botType =="Civ" then
				ped = createScavengerCiv(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="WasteCiv" then
				ped = createWasteCiv(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="SyndCiv" then
				ped = createSyndicateCiv(x,y,z,r,team,weap)	
				setElementData(source,"theSpawnedBotPed", ped)
			elseif botType =="Pig" then
				ped = createPig(x,y,z,r,team,weap)
				setElementData(source,"theSpawnedBotPed", ped)
			end
			
		elseif spawnType == "Zombie_spawn" then --createZombie
			--
		end
        ]]

        --ONLY FOR TEST
        --local ped = createPed(0,x,y,z) -- NPC:createCreature("bear",x,y,z)
        --setElementDimension(ped,1)

        local ped = NPC:createCreature(cType,x,y,z,r,faction,botType and string.lower(botType))
        setElementData(source,"theSpawnedBotPed", ped) -- 设置当前COL产生的BOT为这个PED

        setElementData(source,"botWasSpawned", true) -- 设置当前COL已经产生NPC
        if isElement(ped) then setElementData(ped,"botSpawnCol", source) end -- 绑定产生我的COL
        ped = nil	

	end
end
--3. onColShapeLeave:
	-- is there any other player left in colshape?
		-- Y: return
		-- N: delete bot; mark as unspawned

--TODO：这里删除NPC的写法应该是调用NPC系统中删除而不是直接删除
function onLeaveF (leaveElem,dim)

    --if not getElementData(source,"botToSpawn") then return end
    if getElementType(leaveElem) ~= "player" then return end;
	if not getElementDimension(leaveElem)==1 then return end;
    if getElementData (source,"botWasSpawned") == false then return end;
            
    local playersInColShape = getElementsWithinColShape ( source, "player") -- 获取COL内的玩家
            
    if #(playersInColShape) > 0 then return end -- 如果COL内还有其他玩家

    --这个COL里没有其他玩家了
    botToDelete = getElementData(source,"theSpawnedBotPed")
    if isElement(botToDelete) then 
		NPC:destroyCreature(botToDelete);
	end -- spits an error if you kill the bot, wait until the body gets removed and then leave the area
    setElementData(source,"botWasSpawned", false)
    setElementData(source,"theSpawnedBotPed", false)
    botToDelete = nil

    --outputChatBox("LEAVE COL AND DELETE A NPC ")
    --end
end

--玩家退出后，清理所在COL的信息
addEventHandler("onPlayerQuit", root,
	function ()
		for k, colshape in ipairs(bot_cols) do
			if isElementWithinColShape(source, colshape) then
				--print ("Is inside colshape.")
				--print ("Players inside colshape: "..tostring(#getElementsWithinColShape(colshape, "player")))
				if #getElementsWithinColShape(colshape, "player") == 1 then --no one but him is in the colshape
                    --TODO：删除NPC改为通过NPC系统删除
					local bot = getElementData(colshape, "theSpawnedBotPed")
					if isElement(bot) then
						NPC:destroyCreature(bot);
						setElementData(colshape,"botWasSpawned", false)
						setElementData(colshape,"theSpawnedBotPed", false)
						--print ("Destroyed")
					end
				end
			end
		end
	end
)

--PED死亡后，重设刷新时间？
addEventHandler("onPedWasted", root,
	function ()
		local spawnpoint = getElementData(source,"botSpawnCol")
		outputDebugString("onPedWasted: "..tostring(inspect(spawnpoint)));
		if spawnpoint then
			local respawntimer = getElementData(spawnpoint,"respawnTimer")
			if respawntimer and isTimer(respawntimer) then 
				return 
			else
				local respawnTimerToAdd	= setTimer(function() end,600000,1)
				setElementData(spawnpoint,"respawnTimer",respawnTimerToAdd)
			end
		end
end)