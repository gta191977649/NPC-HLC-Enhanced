--SECOND LEVEL TYPE : human
--默认数据
human = {
    category = "human",
    skin = 0,
    weapon = "bow", -- 默认武器
    walkingstyle = 0, -- 移动模式
};
human.__index = human;
setmetatable( human, creature );

function human:create(skin,x,y,z,r,holdweapon,walkingstyle)

    --outputDebugString("CREATE human");

    --随机皮肤，已挪到人类
    --TODO：可以挪到生物把
    if type(skin) == "table" then
        skin = skin[math.random(1,#skin)];
    end
    --outputDebugString("human skin:"..tostring(skin));

    local o = creature:create(skin,x,y,z,r)
    
    self.__index = self;
    --outputDebugString("TRY TO COPY FROM "..inspect(getmetatable(o)))
    setmetatable(o,self);

    --get ped
    local humanped = o:getElement()


    --outputDebugString("human weapon:"..tostring(inspect(holdweapon)));
    if holdweapon then

        --同时支持ID和NAME
        local wep = holdweapon
        if type(holdweapon)=="number" then
            wep = getWeaponFromGID(holdweapon);
        end
        --outputDebugString("wep:"..tostring(wep));

        --如果获取到新武器模型ID，则ATTACH
        if wep then
            local modelID = weapons[wep].model_new
            --outputDebugString(wep.." "..tostring(modelID));
            Attach:attachWeapon(humanped,modelID)
            giveWeapon(humanped,weapons[wep].gtaid,9999,true)--无限子弹
            o.weapon = wep;
        end

    end

    --设置动作
    --outputDebugString("skin:"..tostring(skin));
    local wk = gtapeds[skin][3]
    --outputDebugString("gtaped wk:"..tostring(wk));
    local walkingstyle = GTAWalkingStyle[wk];
    if walkingstyle then
        --outputDebugString("walkingstyle:"..tostring(walkingstyle));
        setPedWalkingStyle(humanped,walkingstyle)
        o.walkingstyle = walkingstyle;
    end
    

    --DATA 同步 越外层，优先级最高
    for k,v in pairs(human) do 
        Data:setData(self.source,k,o[k] or v)
    end

    return o;
end