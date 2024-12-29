-- Gale's Character ID should be correctly assigned here
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"  -- Ensure this is properly set

-- Magic Allergy and Wild Magic Constants
local GALE_GOON_MAGICALLERGY_UNLOCK_STATUS = "GALE_GOON_MAGICALLERGY_UNLOCK_STATUS"
local GALE_WILDMAGIC_PERMANENT_REMOVAL = "GALE_WILDMAGIC_PERMANENT_REMOVAL"
local GALE_BOMB1_STATUS = "ORI_GALE_BOMB1"
local GALE_BOMB2_STATUS = "ORI_GALE_BOMB2"
local GALE_BOMB3_STATUS = "ORI_GALE_BOMB3"

-- Function to manage Magic Allergy application and removal as a status
local function updateMagicAllergy()
    if not galeCharID or galeCharID == "" then
        Ext.Utils.Print("[ERROR] Gale's character ID is not valid!")
        return
    end

    Ext.Utils.Print("[DEBUG] Updating Magic Allergy status.")

    -- Check if any Bomb status is active
    local hasBombStatus = Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1

    -- Check if permanent removal is active
    local permanentRemovalActive = Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 1

    -- Early exit if permanent removal is active
    if permanentRemovalActive then
        if Osi.HasActiveStatus(galeCharID, GALE_GOON_MAGICALLERGY_UNLOCK_STATUS) == 1 then
            Osi.RemoveStatus(galeCharID, GALE_GOON_MAGICALLERGY_UNLOCK_STATUS)
            Ext.Utils.Print("[DEBUG] Magic Allergy status removed due to permanent removal.")
        end
        return -- Exit early; no further processing needed
    end

    -- Apply or remove Magic Allergy based on bomb status presence
    if hasBombStatus then
        -- Only apply Magic Allergy if it's not already active
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

-- Function to manage Wild Magic status (with checks for Bomb and Permanent Removal)
local function updateWildMagic()
    if not galeCharID or galeCharID == "" then
        Ext.Utils.Print("[ERROR] Gale's character ID is not valid!")
        return
    end

    Ext.Utils.Print("[DEBUG] Updating Wild Magic status.")

    -- Check if any Bomb status is active
    local hasBombStatus = Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
                          Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1

    -- Apply Wild Magic if Bomb status is present
    if hasBombStatus then
        if Osi.HasPassive(galeCharID, "Gale_WildMagic") == 0 then
            Osi.AddPassive(galeCharID, "Gale_WildMagic")
            Ext.Utils.Print("[DEBUG] Gale_WildMagic applied.")
        end
    elseif Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 1 then
        if Osi.HasPassive(galeCharID, "Gale_WildMagic") == 1 then
            Osi.RemovePassive(galeCharID, "Gale_WildMagic")
            Ext.Utils.Print("[DEBUG] Gale_WildMagic removed due to permanent removal status.")
        end
    end
end

-- Function to trigger updates on bomb status changes
local function onBombStatusChange(target, status)
    -- Check if Gale is the target of the status change
    if target == galeCharID then
        Ext.Utils.Print("[DEBUG] Status change detected: " .. status)
        
        -- Update Magic Allergy and Wild Magic based on Bomb status changes
        if status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS or status == GALE_BOMB3_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb status detected. Applying Gale_WildMagic and Magic Allergy.")
            updateWildMagic()
            updateMagicAllergy()
        end
    end
end

-- Register listeners for status applied and status removed events
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, _)
    onBombStatusChange(target, status)
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, _)
    onBombStatusChange(target, status)
end)

-- Register listener for LevelGameplayStarted event (optional but useful for debugging)
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level_name, is_editor_mode)
    Ext.Utils.Print("[DEBUG] LevelGameplayStarted triggered for level: " .. level_name)
end)
