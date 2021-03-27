--JUNE 的生物DEBUG 显示器

local otherElements = getElementByID("otherElements") -- we would need that aswell for binding handlers.
sW,sH = guiGetScreenSize();

function debugCreature()
    --outputChatBox("debugCreature")

    --NOTICE:ONLY DEBUG IN PARENTS AND STREAMED IN PED
    for _,creature in pairs(getElementsByType("ped",otherElements,true)) do
        --outputChatBox("c:"..tostring(inspect(creature)))
        if isElement(creature) and getElementType(creature)=="ped" and not isPedDead(creature) then

            ------------------DEBUG VISIBLE/HEAR -----------------
            find,s,v = checkFind(creature) -- TODO 优化：这里应该直接提取本地的NPC数据，否则每帧执行一次复杂的checkFind函数
            -----------

            local cX,cY,cZ = getElementPosition( creature )
            local x,y = getScreenFromWorldPosition(cX,cY,cZ) --TO SCREEN POS
            

            local textcolor = tocolor(255,255,255)
            if Data:getData(creature,"name")~= "Wolf Crew" then
                textcolor = tocolor(0,255,0)
            end

            --distance
            local pX,pY,pZ = getElementPosition( localPlayer )
            local distance = getDistanceBetweenPoints2D(cX,cY,pX,pY);

            --targets
            local targets = Data:getData(creature,"targets") or {}; -- 获取我的目标表

			if tonumber(x) and tonumber(y) then
                local text = "Name:"..tostring(Data:getData(creature,"name") or "MISS TYPE")
                --text = text .. "\n".."Type:"..tostring(Data:getData(creature,"type") or "MISS TYPE")
                --text = text .. "\nCategory:"..tostring(Data:getData(creature,"category") or "MISS CATEGORY")
                --text = text .. "\n".."Speed:"..tostring(Data:getData(creature,"speed") or "MISS SPEED")
                --text = text .. "\n".."HP:"..tostring(getElementHealth(creature) or "MISS SPEED")
                --text = text .. "\n".."Visble:"..tostring(checkVisible(creature))
                --text = text .. "\n".."targets:"..tostring(inspect(targets))
                text = text .. "\n".."Target:"..tostring(inspect(Data:getData(creature,"target")) or "MISS TARGET")
                text = text .. "\n".."Gang:"..tostring(Data:getData(creature,"gang") or "MISS GANG")
                --text = text .. "\n".."Distance:"..tostring(distance)
                --text = text .. "\n".."Ammo:"..tostring(getPedTotalAmmo(creature))
                --text = text .. "\n".."Accuracy:"..tostring(Data:getData(creature,"accuracy") or "MISS accuracy")
                --if(isNPCHaveTask(creature))then text = text .. "\n".."task:"..tostring(inspect(getNPCCurrentTask(creature))) end -- 对外的写法
            
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

            --这里需要从客户端获取服务端的数据
            local radius = Data:getData(creature,"fovDistance")
            local angle = Data:getData(creature,"fovAngle")

            if find then
                color = tocolor(255,0,0)
            else
                color = tocolor(0,255,0)
            end
            
            local rx,ry,rz =  getElementRotation(creature)
            for a = -angle/2,angle/2,30 do 
                
                local x,y,z = getPositionFromOffsetByPosRot(cX,cY,cZ,rx,ry,rz+a,0,radius,0)
                dxDrawLine3D( cX,cY,cZ, x,y,z,color,1 )
            end

        end

    end
end

addEventHandler ( "onClientRender", root, debugCreature )