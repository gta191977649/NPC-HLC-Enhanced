function getPedAvaiableWeaponSlot(npc)
    for i=1,12 do 
        local weapon = getPedWeapon (npc, i)
        local ammo = getPedTotalAmmo(npc,i)
        if weapon ~= 0 and ammo > 0 then return i end
    end
    return 0
end