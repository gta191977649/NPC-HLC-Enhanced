local otherElements = getElementByID("otherElements") -- we would need that aswell for binding handlers.
sW,sH = guiGetScreenSize();

function debugCreature()
    --outputChatBox("debugCreature")

    --NOTICE:ONLY DEBUG IN PARENTS AND STREAMED IN PED
    for _,creature in pairs(getElementsByType("ped",otherElements,true)) do
        --outputChatBox("c:"..tostring(inspect(creature)))
        if isElement(creature) and getElementType(creature)=="ped" then
            local cX,cY,cZ = getElementPosition( creature )
            local x,y = getScreenFromWorldPosition(cX,cY,cZ) --TO SCREEN POS

            local textcolor = tocolor(255,255,255)
            if Data:getData(creature,"name")~= "Wolf Crew" then
                textcolor = tocolor(0,255,0)
            end

			if tonumber(x) and tonumber(y) then
                local text = "Category:"..tostring(Data:getData(creature,"category") or "MISS CATEGORY")
                text = text .. "\n".."Type:"..tostring(Data:getData(creature,"type") or "MISS TYPE")
                text = text .. "\n".."Name:"..tostring(Data:getData(creature,"name") or "MISS TYPE")
                local length = dxGetTextWidth(text,1,"clear")
				dxDrawText(text,x-length/2-sW*0.01,y*0.8, x+length/2+sW*0.01, y+sH*0.03, textcolor,1, "clear", "center", "center")
			end
        end

    end
end

addEventHandler ( "onClientRender", root, debugCreature )