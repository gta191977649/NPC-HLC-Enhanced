local otherElements = getElementByID("otherElements") -- 重要，不然不知道为何物
--local sW,sH = guiGetScreenSize()

--绘制野生动物名字
function drawWildName()

	--outputDebugString("drawWildName");

	for _,creature in pairs(getElementsByType("ped",otherElements,true)) do
		if isElement(creature) and getElementType(creature)=="ped" and not isPedDead(creature) then
			--过滤
			if not getElementData(creature,"creature") then return end

			--outputDebugString("drawWildName of:"..tostring(inspect(creature)));

			local cX,cY,cZ = getElementPosition( creature )
			local x,y = getScreenFromWorldPosition(cX,cY,cZ+1.1) --TO SCREEN POS

			--distance
			local pX,pY,pZ = getElementPosition( localPlayer )
			local distance = getDistanceBetweenPoints2D(cX,cY,pX,pY);

			if distance < 10 then 

				if tonumber(x) and tonumber(y) then
					local text = tostring(Data:getData(creature,"name") or "Nameless") --"Name:"..
			
					local length = dxGetTextWidth(text,0.3,font_bn)
					dxDrawText(text,x-length/2-sW*0.01,y,x+length/2+sW*0.01, y+sH*0.03, textcolor,0.3, font_bn, "center", "top")
				end

			end

		end
	end

end

--addEventHandler ("onClientRender",root,drawWildName ) -- 绘制名字