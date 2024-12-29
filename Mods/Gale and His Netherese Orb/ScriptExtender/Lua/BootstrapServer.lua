-- Gale's Character ID
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local GALE_WILD_MAGIC_PASSIVE = "Gale_WildMagic"
local GALE_BOMB1_STATUS = "ORI_GALE_BOMB1"
local GALE_BOMB2_STATUS = "ORI_GALE_BOMB2"
local GALE_BOMB3_STATUS = "ORI_GALE_BOMB3"
local GALE_MAGIC_ALLERGY_UNLOCK = "GALE_GOON_MAGICALLERGY_UNLOCK"
local GALE_WILDMAGIC_PERMANENT_REMOVAL = "GALE_WILDMAGIC_PERMANENT_REMOVAL"

Ext.Utils.Print("[DEBUG] Mod script loaded successfully.")

-- Function to update statuses and passives
local function updateMagicAllergyAndWildMagic()
    Ext.Utils.Print("[DEBUG] Updating Magic Allergy and WildMagic statuses.")

    -- Check if any bomb status is active
    local hasBombStatus = Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1

    -- Magic Allergy
    if hasBombStatus then
        if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 0 then
            Osi.AddPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
            Ext.Utils.Print("[DEBUG] Magic Allergy applied.")
        end
    else
        if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 1 then
            Osi.RemovePassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
            Ext.Utils.Print("[DEBUG] Magic Allergy removed.")
        end
    end

    -- Wild Magic
    if hasBombStatus and Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 0 then
        if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 0 then
            Osi.AddPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
            Ext.Utils.Print("[DEBUG] Gale_WildMagic applied.")
        end
    else
        if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 1 then
            Osi.RemovePassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
            Ext.Utils.Print("[DEBUG] Gale_WildMagic removed.")
        end
    end
end

-- Listener for Bomb statuses and permanent removal
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, _)
    if target == galeCharID then
        Ext.Utils.Print("[DEBUG] Status applied: " .. status)

        if status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS or status == GALE_BOMB3_STATUS or status == GALE_WILDMAGIC_PERMANENT_REMOVAL then
            Ext.Utils.Print("[DEBUG] Relevant status detected. Updating statuses.")
            updateMagicAllergyAndWildMagic()
        end
    end
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, _)
    if target == galeCharID then
        Ext.Utils.Print("[DEBUG] Status removed: " .. status)

        if status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS or status == GALE_BOMB3_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb status removed. Updating statuses.")
            updateMagicAllergyAndWildMagic()
        end

        if status == GALE_BOMB3_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb3 removed. Applying permanent removal.")
            Osi.ApplyStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL, -1, 1)
        end
    end
end)

-- Listener for level gameplay start
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level_name, is_editor_mode)
    Ext.Utils.Print("[DEBUG] LevelGameplayStarted triggered for level: " .. level_name)
    Ext.Utils.Print("[DEBUG] Checking statuses and passives for Gale.")

    updateMagicAllergyAndWildMagic()
end)
