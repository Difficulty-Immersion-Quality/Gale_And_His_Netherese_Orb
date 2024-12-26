-- Gale's Character ID
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local MAGIC_ALLERGY_PASSIVE = "MAGIC_ALLERGY_UNLOCK"
local WILD_MAGIC_PASSIVE = "WildMagic"
local GALE_STATUSES = {"ORI_GALE_BOMB3", "ORI_GALE_BOMB2", "ORI_GALE_BOMB1"}

-- Function to check and update Gale's Magic Allergy passive
local function updateMagicAllergyPassive()
    local hasStatus = false
    for _, status in ipairs(GALE_STATUSES) do
        if Osi.HasActiveStatus(galeCharID, status) == 1 then
            hasStatus = true
            break
        end
    end
    
    if hasStatus then
        Osi.AddPassive(galeCharID, MAGIC_ALLERGY_PASSIVE)
    else
        Osi.RemovePassive(galeCharID, MAGIC_ALLERGY_PASSIVE)
    end
end

-- Function to apply WildMagic passive
local function applyWildMagicPassive()
    Osi.AddPassive(galeCharID, WILD_MAGIC_PASSIVE)
end

-- Event Listeners
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, causee, sourceGUID)
    if target == galeCharID and table.contains(GALE_STATUSES, status) then
        updateMagicAllergyPassive()
    end
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, causee, sourceGUID)
    if target == galeCharID and table.contains(GALE_STATUSES, status) then
        updateMagicAllergyPassive()
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level_name, is_editor_mode)
    applyWildMagicPassive()
    updateMagicAllergyPassive()
end)
