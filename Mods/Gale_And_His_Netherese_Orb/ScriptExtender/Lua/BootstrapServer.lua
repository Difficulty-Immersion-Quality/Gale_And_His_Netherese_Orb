-- Gale's Character ID
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local GALE_WILD_MAGIC_PASSIVE = "Gale_WildMagic"
local GALE_BOMB1_STATUS = "ORI_GALE_BOMB1"
local GALE_BOMB2_STATUS = "ORI_GALE_BOMB2"
local GALE_BOMB3_STATUS = "ORI_GALE_BOMB3"
local GALE_MAGIC_ALLERGY_UNLOCK = "GALE_GOON_MAGICALLERGY_UNLOCK"
local GALE_WILDMAGIC_PERMANENT_REMOVAL = "GALE_WILDMAGIC_PERMANENT_REMOVAL"

local function applyGaleWildMagic()
    if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 0 and Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 0 then
        Ext.Utils.Print("[DEBUG] Applying Gale_WildMagic passive")
        Osi.AddPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
    else
        Ext.Utils.Print("[DEBUG] Gale_WildMagic not applied. Conditions not met.")
    end
end

local function removeGaleWildMagic()
    if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 1 then
        Ext.Utils.Print("[DEBUG] Removing Gale_WildMagic passive")
        Osi.RemovePassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
    end
end

local function updateMagicAllergy()
    if Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
       Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
       Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1 then
        if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 0 then
            Ext.Utils.Print("[DEBUG] Applying Magic Allergy passive")
            Osi.AddPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
        end
    else
        if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 1 then
            Ext.Utils.Print("[DEBUG] Removing Magic Allergy passive")
            Osi.RemovePassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
        end
    end
end

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, _)
    if target == galeCharID and (status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS or status == GALE_BOMB3_STATUS) then
        Ext.Utils.Print("[DEBUG] StatusApplied triggered for Gale with status: " .. status)
        applyGaleWildMagic()
        updateMagicAllergy()
    end
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, _)
    if target == galeCharID and status == GALE_BOMB3_STATUS then
        Ext.Utils.Print("[DEBUG] StatusRemoved triggered for Gale with status: " .. status)
        removeGaleWildMagic()
        updateMagicAllergy()
        Osi.ApplyStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL, -1, 1)
    elseif target == galeCharID and (status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS) then
        Ext.Utils.Print("[DEBUG] StatusRemoved triggered for Gale with status: " .. status)
        updateMagicAllergy()
    end
end)
