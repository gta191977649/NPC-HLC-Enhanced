--SECOND LEVEL TYPE : ANIMAL

animal = {
    category = "animal",
};
animal.__index = animal;
setmetatable( animal, creature );

function animal:create(skin,x,y,z)

    outputDebugString("CREATE ANIMAL");

    o = creature:create(skin,x,y,z)
    
    self.__index = self;

    --outputDebugString("TRY TO COPY FROM "..inspect(getmetatable(o)))

    setmetatable(o,self);
    

    return o;
end