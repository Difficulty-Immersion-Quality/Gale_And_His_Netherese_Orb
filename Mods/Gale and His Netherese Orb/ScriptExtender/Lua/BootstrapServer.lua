-- Gale's Character ID
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"

-- Constants for statuses and passives
local GOON_MAGICALLERGY_AURA = "GOON_MAGICALLERGY_AURA"
local GALE_WILDMAGIC_PERMANENT_REMOVAL = "GALE_WILDMAGIC_PERMANENT_REMOVAL"
local GALE_BOMB_STATUSES = { "ORI_GALE_BOMB1", "ORI_GALE_BOMB2", "ORI_GALE_BOMB3" }
local GALE_WILDMAGIC_PASSIVE = "Gale_WildMagic"

-- Function to check if any bomb status is active
local function isBombActive()
    for _, bombStatus in ipairs(GALE_BOMB_STATUSES) do
        if Osi.HasActiveStatus(galeCharID, bombStatus) == 1 then
            return true
        end
    end
    return false
end

-- Unified function to update Magic Allergy and Wild Magic
local function updateMagicAndWildMagic()
    if not galeCharID or galeCharID == "" then
        Ext.Utils.Print("[ERROR] Gale's character ID is not valid!")
        return
    end

    local permanentRemovalActive = Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 1
    local hasBombStatus = isBombActive()

    -- Handle Magic Allergy and Wild Magic when permanent removal is active
    if permanentRemovalActive then
        -- Remove Magic Allergy
        if Osi.HasActiveStatus(galeCharID, GOON_MAGICALLERGY_AURA) == 1 then
            Osi.RemoveStatus(galeCharID, GOON_MAGICALLERGY_AURA)
            Ext.Utils.Print("[DEBUG] Magic Allergy removed due to permanent removal.")
        end

        -- Remove Wild Magic
        if Osi.HasPassive(galeCharID, GALE_WILDMAGIC_PASSIVE) == 1 then
            Osi.RemovePassive(galeCharID, GALE_WILDMAGIC_PASSIVE)
            Ext.Utils.Print("[DEBUG] Wild Magic removed due to permanent removal.")
        end
        return
    end

    -- Update Magic Allergy based on bomb status
    if hasBombStatus then
        if Osi.HasActiveStatus(galeCharID, GOON_MAGICALLERGY_AURA) == 0 then
            Osi.ApplyStatus(galeCharID, GOON_MAGICALLERGY_AURA, -1, 1)
            Ext.Utils.Print("[DEBUG] Magic Allergy applied.")
        end
    else
        if Osi.HasActiveStatus(galeCharID, GOON_MAGICALLERGY_AURA) == 1 then
            Osi.RemoveStatus(galeCharID, GOON_MAGICALLERGY_AURA)
            Ext.Utils.Print("[DEBUG] Magic Allergy removed.")
        end
    end

    -- Update Wild Magic based on bomb status
    if hasBombStatus then
        if Osi.HasPassive(galeCharID, GALE_WILDMAGIC_PASSIVE) == 0 then
            Osi.AddPassive(galeCharID, GALE_WILDMAGIC_PASSIVE)
            Ext.Utils.Print("[DEBUG] Wild Magic applied due to Bomb status.")
        end
    elseif Osi.HasPassive(galeCharID, GALE_WILDMAGIC_PASSIVE) == 1 then
        -- Make sure Wild Magic stays until Bomb3 is removed
        if not Osi.HasActiveStatus(galeCharID, "ORI_GALE_BOMB3") then
            Osi.RemovePassive(galeCharID, GALE_WILDMAGIC_PASSIVE)
            Ext.Utils.Print("[DEBUG] Wild Magic removed as no Bomb status is active.")
        end
    end
end

-- Listener for bomb status application and removal (combined)
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status)
    if target == galeCharID then
        -- Check if the applied status is one of the bomb statuses
        for _, bombStatus in ipairs(GALE_BOMB_STATUSES) do
            if status == bombStatus then
                Ext.Utils.Print("[DEBUG] Bomb status applied: " .. status)
                updateMagicAndWildMagic()
                break
            end
        end
    end
end)

-- Combined Listener for bomb status removal
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status)
    if target == galeCharID then
        -- Check if the removed status is one of the bomb statuses
        for _, bombStatus in ipairs(GALE_BOMB_STATUSES) do
            if status == bombStatus then
                Ext.Utils.Print("[DEBUG] Bomb status removed: " .. status)
                updateMagicAndWildMagic()
                break
            end
        end

        -- Handle Bomb3-specific removal logic
        if status == "ORI_GALE_BOMB3" then
            Ext.Utils.Print("[DEBUG] Bomb3 status removed for Gale.")
            
            -- Remove Wild Magic permanently when Bomb3 is removed
            if Osi.HasPassive(galeCharID, GALE_WILDMAGIC_PASSIVE) == 1 then
                Osi.RemovePassive(galeCharID, GALE_WILDMAGIC_PASSIVE)
                Ext.Utils.Print("[DEBUG] Wild Magic removed due to Bomb3 removal.")
            end

            -- Ensure Magic Allergy is updated after Bomb3 removal
            if Osi.HasActiveStatus(galeCharID, GOON_MAGICALLERGY_AURA) == 1 then
                Osi.RemoveStatus(galeCharID, GOON_MAGICALLERGY_AURA)
                Ext.Utils.Print("[DEBUG] Magic Allergy removed due to Bomb3 removal.")
            end
        end
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function()
    --Ext.Utils.Print("Event triggered: LevelGameplayStarted")
    updateLoneWolfStatus()
end)

-- Listener for when the level gameplay starts
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function()
    -- Check if Gale has the GALE_GOON_MAGICALLERGY_UNLOCK passive
    if Osi.HasPassive(galeCharID, "GALE_GOON_MAGICALLERGY_UNLOCK") == 1 then
        -- Remove the passive
        Osi.RemovePassive(galeCharID, "GALE_GOON_MAGICALLERGY_UNLOCK")
        Ext.Utils.Print("[DEBUG] GALE_GOON_MAGICALLERGY_UNLOCK passive removed at level start.")
    end
end)
