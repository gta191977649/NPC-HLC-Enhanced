--SECOND LEVEL TYPE : human

human = {
    category = "human",
};
human.__index = human;
setmetatable( human, creature );

function human:create(skin,x,y,z)

    --outputDebugString("CREATE human");

    local o = creature:create(skin,x,y,z)
    
    self.__index = self;

    --outputDebugString("TRY TO COPY FROM "..inspect(getmetatable(o)))

    setmetatable(o,self);

    for k,v in pairs(human) do 
        Data:setData(self.source,k,v)
    end

    return o;
end