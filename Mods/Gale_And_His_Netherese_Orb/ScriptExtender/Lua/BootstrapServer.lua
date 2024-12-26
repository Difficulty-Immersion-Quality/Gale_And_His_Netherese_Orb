-- Gale's Character ID
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local GALE_MAGIC_ALLERGY_PASSIVE = "GALE_GOON_MAGICALLERGY_UNLOCK"
local EXISTING_MAGIC_ALLERGY_PASSIVE = "GOON_MAGICALLERGY_UNLOCK"
local GALE_WILD_MAGIC_PASSIVE = "Gale_WildMagic"
local EXISTING_WILD_MAGIC_PASSIVE = "WildMagic"
local GALE_STATUSES = {"ORI_GALE_BOMB3", "ORI_GALE_BOMB2", "ORI_GALE_BOMB1"}

-- Function to check and update Gale's Magic Allergy passive
local function updateGaleMagicAllergyPassive()
    if Osi.HasPassive(galeCharID, EXISTING_MAGIC_ALLERGY_PASSIVE) == 1 then
        Osi.RemovePassive(galeCharID, GALE_MAGIC_ALLERGY_PASSIVE)
        return
    end

    local hasStatus = false
    for _, status in ipairs(GALE_STATUSES) do
        if Osi.HasActiveStatus(galeCharID, status) == 1 then
            hasStatus = true
            break
        end
    end

    if hasStatus then
        Osi.AddPassive(galeCharID, GALE_MAGIC_ALLERGY_PASSIVE)
    else
        Osi.RemovePassive(galeCharID, GALE_MAGIC_ALLERGY_PASSIVE)
    end
end

-- Function to apply Gale_WildMagic passive
local function applyGaleWildMagicPassive()
    if Osi.HasPassive(galeCharID, EXISTING_WILD_MAGIC_PASSIVE) == 1 then
        -- Do not apply Gale_WildMagic if WildMagic already exists
        Osi.RemovePassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
        return
    end
    Osi.AddPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
end

-- Event Listeners
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, sourceGUID)
    if target == galeCharID and table.contains(GALE_STATUSES, status) then
        updateGaleMagicAllergyPassive()
    end
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, causee, sourceGUID)
    if target == galeCharID and table.contains(GALE_STATUSES, status) then
        updateGaleMagicAllergyPassive()
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level_name, is_editor_mode)
    applyGaleWildMagicPassive()
    updateGaleMagicAllergyPassive()
end)
