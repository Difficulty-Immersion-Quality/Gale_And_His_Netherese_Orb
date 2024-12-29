-- Gale's Character ID
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local GALE_WILD_MAGIC_PASSIVE = "Gale_WildMagic"
local GALE_BOMB1_STATUS = "ORI_GALE_BOMB1"
local GALE_BOMB2_STATUS = "ORI_GALE_BOMB2"
local GALE_BOMB3_STATUS = "ORI_GALE_BOMB3"
local GALE_MAGIC_ALLERGY_UNLOCK_STATUS = "GALE_GOON_MAGICALLERGY_UNLOCK_STATUS"
local GALE_WILDMAGIC_PERMANENT_REMOVAL = "GALE_WILDMAGIC_PERMANENT_REMOVAL"

Ext.Utils.Print("[DEBUG] Mod script loaded successfully.")

-- Function to ensure Wild Magic stays applied or is removed appropriately
local function updateWildMagic()
    Ext.Utils.Print("[DEBUG] Updating Wild Magic status.")

    local hasBombStatus = Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1

    if hasBombStatus then
        if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 0 then
            Osi.AddPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
            Ext.Utils.Print("[DEBUG] Gale_WildMagic applied.")
        end
    elseif Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 1 then
        if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 1 then
            Osi.RemovePassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
            Ext.Utils.Print("[DEBUG] Gale_WildMagic removed due to permanent removal status.")
        end
    end
end

-- Function to manage Magic Allergy application and removal as a status
local function updateMagicAllergy()
    Ext.Utils.Print("[DEBUG] Updating Magic Allergy status.")

    local hasBombStatus = Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1

    local permanentRemovalActive = Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 1

    -- Ensure Magic Allergy is not applied if permanent removal is active
    if permanentRemovalActive then
        if Osi.HasActiveStatus(galeCharID, GALE_GOON_MAGICALLERGY_UNLOCK_STATUS) == 1 then
            Osi.RemoveStatus(galeCharID, GALE_GOON_MAGICALLERGY_UNLOCK_STATUS)
            Ext.Utils.Print("[DEBUG] Magic Allergy status removed due to permanent removal.")
        end
        return -- Exit early; no further processing needed
    end

    -- Apply Magic Allergy if any bomb status is active
    if hasBombStatus then
        if Osi.HasActiveStatus(galeCharID, GALE_GOON_MAGICALLERGY_UNLOCK_STATUS) == 0 then
            Osi.ApplyStatus(galeCharID, GALE_GOON_MAGICALLERGY_UNLOCK_STATUS, -1, 1)
            Ext.Utils.Print("[DEBUG] Magic Allergy status applied.")
        end
    else
        -- Remove Magic Allergy if no bomb statuses are active
        if Osi.HasActiveStatus(galeCharID, GALE_GOON_MAGICALLERGY_UNLOCK_STATUS) == 1 then
            Osi.RemoveStatus(galeCharID, GALE_GOON_MAGICALLERGY_UNLOCK_STATUS)
            Ext.Utils.Print("[DEBUG] Magic Allergy status removed.")
        end
    end
end



-- Listener for Bomb statuses being applied
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, _)
    if target == galeCharID then
        Ext.Utils.Print("[DEBUG] Status applied: " .. status)

        if status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS or status == GALE_BOMB3_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb status detected. Applying Gale_WildMagic and Magic Allergy.")
            updateWildMagic()
            updateMagicAllergy()
        elseif status == GALE_WILDMAGIC_PERMANENT_REMOVAL then
            Ext.Utils.Print("[DEBUG] Permanent removal status applied. Updating statuses.")
            updateWildMagic()
            updateMagicAllergy()
        end
    end
end)

-- Listener for Bomb statuses being removed
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, _)
    if target == galeCharID then
        Ext.Utils.Print("[DEBUG] Status removed: " .. status)

        if status == GALE_BOMB3_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb3 removed. Applying permanent removal and updating statuses.")
            Osi.ApplyStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL, -1, 1)
        end

        if status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS or status == GALE_BOMB3_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb status removed. Updating statuses.")
            updateWildMagic()
            updateMagicAllergy()
        end
    end
end)

-- Listener for gameplay start to ensure statuses are in sync
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level_name, is_editor_mode)
    Ext.Utils.Print("[DEBUG] LevelGameplayStarted triggered for level: " .. level_name)
    Ext.Utils.Print("[DEBUG] Checking statuses and passives for Gale.")
    
    updateWildMagic()
    updateMagicAllergy()
end)
