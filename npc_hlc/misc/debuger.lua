--JUNE 的生物DEBUG 显示器

local otherElements = getElementByID("otherElements") -- we would need that aswell for binding handlers.
sW,sH = guiGetScreenSize();

function debugCreature()
    --outputChatBox("debugCreature")

    --NOTICE:ONLY DEBUG IN PARENTS AND STREAMED IN PED
    for _,creature in pairs(getElementsByType("ped",otherElements,true)) do
        --outputChatBox("c:"..tostring(inspect(creature)))
        if isElement(creature) and getElementType(creature)=="ped" then


            ------------------DEBUG VISIBLE/HEAR -----------------
            find,s,v = checkFind(creature) -- TODO 优化：这里应该直接提取本地的NPC数据，否则每帧执行一次复杂的checkFind函数
            -----------

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
                text = text .. "\n".."Visble:"..tostring(checkVisible(creature))
                ----------------checkFind
                --[[
                if s or v then 
                    text = text.."\n";
                    if s then 
                        text = text.."听到";
                    end
                    if v then
                        text = text.." 看到";
                    end
                else 
                    text = text.."\n ";
                end
                ]]
                ----------------

                local length = dxGetTextWidth(text,1,"clear")
				dxDrawText(text,x-length/2-sW*0.01,y*0.8, x+length/2+sW*0.01, y+sH*0.03, textcolor,1, "clear", "center", "center")
			end

            --TEST getPositionFromElementOffset
            --local lx,ly,lz = getPositionFromElementOffset(creature,-2,0,0) --left
            --local lx,ly,lz = getPositionFromElementOffset(creature,2,0,0) --right
            local f_x,f_y,f_z = getPositionFromElementOffset(creature,0,5,0) --front
            local lf_x,lf_y,lf_z = getPositionFromElementOffset(creature,-5,5,0) --lf
            local rf_x,rf_y,rf_z = getPositionFromElementOffset(creature,5,5,0) --rf

            if find then
                color = tocolor(255,0,0)
            else
                color = tocolor(0,255,0)
            end 
            --dxDrawLine3D( cX,cY,cZ, f_x,f_y,f_z,color,1 )
            dxDrawLine3D( cX,cY,cZ, lf_x,lf_y,lf_z,color,1 )
            dxDrawLine3D( cX,cY,cZ, rf_x,rf_y,rf_z,color,1 )
        end

    end
end

addEventHandler ( "onClientRender", root, debugCreature )