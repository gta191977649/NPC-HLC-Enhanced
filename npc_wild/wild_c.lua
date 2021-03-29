--接受服务器产生Creature的要求
--修复坐标/检测条件
function clientSpawnCheck(xcoord, ycoord)
	--outputChatBox("clientSpawnCheck");
	local x,y,z = getElementPosition( localPlayer )
	local posx = x+xcoord
	local posy = y+ycoord
	local gz = getGroundPosition ( posx, posy, z+500 )
	triggerServerEvent ("wild > serverSpawn", localPlayer, posx, posy, gz+1 ) -- 产生

end
addEvent( "wild > clientSpawn", true )
addEventHandler("wild > clientSpawn", getRootElement(), clientSpawnCheck)

--客户端受伤判定
function wildDamage(attacker,weapon,bodypart,loss)

	if not getElementData(source,"creature") then
		cancelEvent()
		outputChatBox("return need after cancel");
		return;
	end
	--source:ped that got damaged
	--outputChatBox(inspect(attacker).." attack "..inspect(source));

	--有攻击者
	if attacker then

		--根据两者关系决定动物的行为
		local gang = Data:getData(source,"gang");--被攻击者帮会
		local gang_attacker = Data:getData(attacker,"gang");--攻击者帮会

	else
	end

	--通用，无效伤害
	if weapon and weapon == 37 or weapon == 54 or weapon == 55 then
		--火焰 坠落 未知
		--setElementHealth(source,100)
		cancelEvent();
		outputChatBox("fall by vehicle is harmless");
		return;
	end

	--误伤是否反击
	--目前只反击玩家或者非同帮会成员
	if getElementType(attacker) == "player" then
		-----------------
		---player killer
		------------------
		-- damage = 100
		if weapon then

			if weapon == 63 or weapon == 51 or weapon == 19 then -- holy kill

				--秒杀
				killPed(source,attacker) -- 击杀玩家传入

			elseif weapon ~= 0 then

				--不同武器伤害
				if bodypart == 9 then

					--秒杀
					killPed(source,attacker) -- 击杀玩家传入
					--setPedHeadless(source,false)
				
				end


			elseif weapon == 0 then
				--拳头伤害
				cancelEvent();
			end
		end


	elseif getElementType(attacker) == "vehicle" then
		-----------------
		---veh killer
		-----------------
		-- damage = 100

		if weapon then

			if weapon == 63 or weapon == 51 or weapon == 19 or weapon == 49 or weapon == 50 then
				--汽车爆炸 爆炸 火箭弹 Rammed

				--秒杀
				killPed(source,attacker) -- 击杀车辆信息传入
				--triggerServerEvent("wild > Killed",source,attacker,headshot,weapon)
				
			end

		end

	end 

	Sound:playSoundLib("zombie","hit");

	--TODO 如果NPC被2个以上玩家顺序攻击，会频繁的改变目标，需要增加一个仇恨值判断，例如新目标是否比旧目标仇恨值更高

end
--注意这里getRootElement()需要是NPC的上级
addEventHandler ( "onClientPedDamage", getRootElement(), wildDamage )