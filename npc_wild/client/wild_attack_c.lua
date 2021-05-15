--PED 攻击音效会破音...
function pedFire(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)


	local realWeapon = Data:getData(source,"weapon")
	local wepProperty = weapons[realWeapon];

	--计算武器射速
	--TODO:射击延迟交给NPC管理器管理
	--pedFireDelay(source,wepProperty.firedelay);

	--outputChatBox(tostring(inspect(source)).." pedFire: "..tostring(realWeapon).." voice:"..tostring(wepProperty.voice));

	local x,y,z = getElementPosition(source); -- 音源

	--outputChatBox("playElementSFX:"..tostring(x)..","..tostring(y)..","..tostring(z));
	local sound = playSound3D(":NH_Weapon/"..wepProperty.sfx_fire,x,y,z,false);
	if sound then
		setElementDimension(sound,1);
		setSoundVolume(sound,wepProperty.voice); -- 似乎设置了不影响衰减!
		--setSoundMaxDistance(sound,10000); -- 不要用该选项，最大距离导致声音无衰减
	end
   --end

	local clipleft = Data:getData(source,"clipleft") or wepProperty.clip
	if clipleft > 1 then
		clipleft = clipleft - 1	
	else
		outputChatBox("reload ped!");
		--NPC:stopNPCWeaponActions(source)
		IFP:syncAnimation(source,"UZI","UZI_reload",-1,false,false,true);
		clipleft = wepProperty.clip
	end
	Data:setData(source,"clipleft",clipleft)

end
addEventHandler("onClientPedWeaponFire",root,pedFire)