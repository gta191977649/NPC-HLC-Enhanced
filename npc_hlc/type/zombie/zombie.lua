--SECOND LEVEL TYPE : zombie
zombie = {
    category = "zombie", -- 似乎可以逐渐舍弃了
    --ZB只会肉搏攻击，所以属性写在动物类
    shootdist = 3,--小于这个距离攻击
    followdist = 1,--大于这个距离跟随
    accuracy = 0,
    traits = {"zombie"},
    walkingstyle = "zombie", -- 移动模式为动作库:zombie
};
zombie.__index = zombie;
setmetatable( zombie, creature );

function zombie:create(skin,x,y,z,r)

    --outputDebugString("CREATE zombie");

    --随机皮肤
    if type(skin) == "table" then
        skin = table.random(skin);
    end

    local o = creature:create(skin,x,y,z,r)
    
    self.__index = self;

    --outputDebugString("TRY TO COPY FROM "..inspect(getmetatable(o)))

    setmetatable(o,self);

    for k,v in pairs(zombie) do 
        Data:setData(self.source,k,v)
    end

    return o;
end