--SECOND LEVEL TYPE : human
--默认数据
human = {
    category = "human",
    skin = 0,
    weapon = "bow", -- 默认武器
};
human.__index = human;
setmetatable( human, creature );

function human:create(skin,x,y,z,r,holdweapon)

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

    --outputDebugString("human weapon:"..tostring(inspect(holdweapon)));
    if holdweapon then

        local humanped = o:getElement()
        giveWeapon(humanped,holdweapon,9999,true)--无限子弹

        --
        local wep = getWeaponFromGID(holdweapon);
        --outputDebugString("getWeaponFromGID:"..tostring(wep));

        --如果获取到新武器模型ID，则ATTACH
        if wep then
            local modelID = weapons[wep].model_new
            --outputDebugString(wep.." "..tostring(modelID));
            Attach:attachWeapon(humanped,modelID)
            o.weapon = wep;
        end

    end

    --DATA 同步 越外层，优先级最高
    for k,v in pairs(human) do 
        Data:setData(self.source,k,o[k] or v)
    end

    return o;
end