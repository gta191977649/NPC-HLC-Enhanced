--SECOND LEVEL TYPE : ANIMAL
animal = {
    category = "animal",
    --动物只会肉搏攻击，所以属性写在动物类
    shootdist = 3,--小于这个距离攻击
    followdist = 1,--大于这个距离跟随
    accuracy = 0,
    behaviour = "default", -- 默认
};
animal.__index = animal;
setmetatable( animal, creature );

function animal:create(skin,x,y,z,r)

    --outputDebugString("CREATE ANIMAL");

    local o = creature:create(skin,x,y,z,r)
    
    self.__index = self;

    --outputDebugString("TRY TO COPY FROM "..inspect(getmetatable(o)))

    setmetatable(o,self);

    for k,v in pairs(animal) do 
        Data:setData(self.source,k,v)
    end
    

    return o;
end