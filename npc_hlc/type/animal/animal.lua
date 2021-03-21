--SECOND LEVEL TYPE : ANIMAL

animal = {
    category = "animal",
};
animal.__index = animal;
setmetatable( animal, creature );

function animal:create(skin,x,y,z)

    --outputDebugString("CREATE ANIMAL");

    local o = creature:create(skin,x,y,z)
    
    self.__index = self;

    --outputDebugString("TRY TO COPY FROM "..inspect(getmetatable(o)))

    setmetatable(o,self);

    for k,v in pairs(animal) do 
        Data:setData(self.source,k,v)
    end
    

    return o;
end