-----------
cType = {}
cType["wolf"] = wolf
cType["bear"] = bear
cType["puma"] = puma
cType["goat"] = goat

cType["normal"] = normal

cType["hunter"] = hunter
cType["infected"] = infected

--2021
--创建生物
--如果是人类，需要阵营，名字
--参数：CLASS类型，坐标XYZ,角度R，姓名name，子分类subtype（人类是阵营，其他动物是种类）
function createCreature(type,x,y,z,r,subtype,btype)

	--DEBUG 不存在的类型创建为僵尸
	--outputDebugString("table have key "..tostring(cType[type]))
	--outputDebugString("not table have key "..tostring(not cType[type]))
	--outputDebugString("TRY CALL createCreature:"..tostring(subtype).." "..tostring(btype));

	local c = nil;

	if type == "normal" then
		c = cType[type]:create(x,y,z,r,subtype,btype) -- 不要使用预留名creature..不然BUG
	else
		c = cType[type]:create(x,y,z,r) -- 不要使用预留名creature..不然BUG
	end
	local cElement = c:getElement();

	--反绑定
	setElementData(cElement,"creature",type);
	creatures[cElement] = c;

	--绑定到任务结束函数
	addEventHandler("npc_hlc:onNPCTaskDone",cElement,taskDone)

	local accuracy = Data:getData(cElement,"accuracy");
	local speed = Data:getData(cElement,"speed");
	--local category = Data:getData(cElement,"category");

	local behaviour = Data:getData(cElement,"behaviour");
	NPC:enableHLCForNPC(cElement,speed,accuracy,1)

	--默认任务
	if behaviour == "guard" then
		accuracy = 1 -- 守卫设计准确度很高
		Data:setData(cElement,"sensor",true); -- 开启感知
		NPC:setNPCTask(cElement, {"guardPos",x,y,z,r})--loop false to sequence random animation

	elseif behaviour == "hunt" then
		--追杀
		Data:setData(cElement,"sensor",true); -- 开启感知
		NPC:setNPCTask(cElement,{"hangOut",x,y,x,y}) -- 默认闲逛任务

	elseif behaviour == "default" then
		--闲逛市民/僵尸
		NPC:setNPCTask(cElement,{"hangOut",x,y,x,y})
	else
		--trade NOT MOVE
		--NPC:setNPCTask(cElement,{"hangOut",x,y,x,y})
	end
	
	--outputDebugString("createCreature to:"..tostring(table.nums(creatures)));

	return cElement;

end

--NEW
--摧毁生物
function destroyCreature(element)
	local creature = creatures[element];
	--outputDebugString(tostring(inspect(element)).."creature:"..tostring(inspect(creature)))
	if creature then
		--outputDebugString("TRY destroyCreature "..tostring(inspect(element)))
		creature:destroy(element)
	else
		outputDebugString("no creature in lib to destroy..left:"..tostring(table.nums(creatures)))
	end
end