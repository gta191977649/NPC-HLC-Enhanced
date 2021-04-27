--JUNE 的生物DEBUG 显示器

local otherElements = getElementByID("otherElements") -- we would need that aswell for binding handlers.
sW,sH = guiGetScreenSize();

function debugCreature()
    --outputChatBox("debugCreature")

    --NOTICE:ONLY DEBUG IN PARENTS AND STREAMED IN PED
    --注意，不要再循环内用return，会结束整个循环和函数

    for _,creature in pairs(getElementsByType("ped",otherElements,true)) do
        --outputDebugString("creature:"..tostring(inspect(creature)))
        if isElement(creature) and getElementType(creature)=="ped" and not isPedDead(creature) and getElementData(creature,"creature") then

            local cX,cY,cZ = getElementPosition( creature )
            local x,y = getScreenFromWorldPosition(cX,cY,cZ) --TO SCREEN POS

            --仅显示近距离？
            --distance
            local pX,pY,pZ = getElementPosition( localPlayer )
            local distance = getDistanceBetweenPoints2D(cX,cY,pX,pY);

            --TAG 距离
            if distance < 45 then 

                ------------------DEBUG VISIBLE/HEAR -----------------
                find,s,v = checkFind(creature) -- TODO 优化：这里应该直接提取本地的NPC数据，否则每帧执行一次复杂的checkFind函数
                -----------

                local textcolor = tocolor(255,255,255)
                --if Data:getData(creature,"name")~= "Wolf Crew" then
                --    textcolor = tocolor(0,255,0)
                --end

                --targets
                local targets = Data:getData(creature,"targets") or {}; -- 获取我的目标表

                if tonumber(x) and tonumber(y) then
                    local text = tostring(Data:getData(creature,"name") or "MISS TYPE") --"Name:"..
                    --text = text .. "\n".."Type:"..tostring(Data:getData(creature,"type") or "MISS TYPE")
                    --text = text .. "\nCategory:"..tostring(Data:getData(creature,"category") or "MISS CATEGORY")
                    --text = text .. "\n".."Speed:"..tostring(getNPCWalkSpeed(creature) or "MISS SPEED")
                    --text = text .. "\n".."HP:"..tostring(getElementHealth(creature) or "MISS SPEED")
                    --text = text .. "\n".."Visble:"..tostring(checkVisible(creature))
                    --text = text .. "\n".."Senser:"..tostring(Data:getData(creature,"sensor"))
                    --text = text .. "\n".."targets:"..tostring(inspect(targets))
                    --text = text .. "\n".."Target:"..tostring(inspect(Data:getData(creature,"target")) or "MISS TARGET")
                    --text = text .. "\n".."Gang:"..tostring(Data:getData(creature,"gang") or "MISS GANG")
                    --text = text .. "\n".."Distance:"..tostring(math.round(distance))
                    --text = text .. "\n".."Ammo:"..tostring(getPedTotalAmmo(creature))
                    --text = text .. "\n".."Accuracy:"..tostring(Data:getData(creature,"accuracy") or "MISS accuracy")
                    --text = text .. "\n"..inspect(creature).." thistask:"..tostring(getElementData(creature,"npc_hlc:thistask")) 

                     --if(isNPCHaveTask(creature)) then 
                    --    text = text .. "\n".."task:"..tostring(inspect(getNPCCurrentTask(creature))) 
                    --end -- 对外的写法
                
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

                    local length = dxGetTextWidth(text,1,"sans")
                    dxDrawText(text,x-length/2-sW*0.01,y*0.8, x+length/2+sW*0.01, y+sH*0.03, textcolor,1, "sans", "center", "center")
                end
                
            end

            --接下来是 Sensor
            if Data:getData(creature,"sensor") then

                --这里需要从客户端获取服务端的数据
                local radius = Data:getData(creature,"fovDistance")
                local angle = Data:getData(creature,"fovAngle")

                if find then
                    color = tocolor(255,0,0)
                else
                    color = tocolor(0,255,0)
                end
                
                local rx,ry,rz = getElementRotation(creature)
                for a = -angle/2,angle/2,30 do 
                    local x,y,z = getPositionFromOffsetByPosRot(cX,cY,cZ,rx,ry,rz+a,0,radius,0)
                    --outputDebugString("dxDrawLine3D of:"..tostring(Data:getData(creature,"name")))
                    dxDrawLine3D( cX,cY,cZ, x,y,z,color,1 )
                end

            end

            ----SENSOR STOP
        end

    end
end

addEventHandler ( "onClientRender", root, debugCreature )