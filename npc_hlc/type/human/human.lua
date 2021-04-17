--SECOND LEVEL TYPE : human

human = {
    category = "human",
    skin = 0,
    weapon = 30,
};
human.__index = human;
setmetatable( human, creature );

function human:create(skin,x,y,z,r,weapon)

    --outputDebugString("CREATE human");

    --随机皮肤，已挪到人类
    --TODO：可以挪到生物把
    if #skin > 1 then
        skin = skin[math.random(1,#skin)];
    end
    outputDebugString("human skin:"..tostring(skin));

    local o = creature:create(skin,x,y,z,r)
    
    self.__index = self;

    --outputDebugString("TRY TO COPY FROM "..inspect(getmetatable(o)))

    setmetatable(o,self);

    for k,v in pairs(human) do 
        Data:setData(self.source,k,v)
    end

    --随机武器，已挪到人类
    if #weapon > 1 then weapon = weapon[math.random(1,#weapon)] else weapon = weapon or human.weapon end
    --outputDebugString("human weapon:"..tostring(weapon));
    local humanped = o:getElement()
    giveWeapon(humanped,weapon,9999,true)--无限子弹

    return o;
end