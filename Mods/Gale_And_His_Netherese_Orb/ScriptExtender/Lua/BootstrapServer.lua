-- Gale's Character ID
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local GALE_WILD_MAGIC_PASSIVE = "Gale_WildMagic"
local GALE_BOMB1_STATUS = "ORI_GALE_BOMB1"
local GALE_BOMB2_STATUS = "ORI_GALE_BOMB2"
local GALE_BOMB3_STATUS = "ORI_GALE_BOMB3"
local GALE_MAGIC_ALLERGY_UNLOCK = "GALE_GOON_MAGICALLERGY_UNLOCK"
local GALE_WILDMAGIC_PERMANENT_REMOVAL = "GALE_WILDMAGIC_PERMANENT_REMOVAL"

-- Function to apply Gale_WildMagic passive if not already applied
local function applyGaleWildMagic()
    if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 0 and Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 0 then
        Osi.AddPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
    end
end

-- Function to remove Gale_WildMagic passive if Bomb 3 is removed
local function removeGaleWildMagic()
    if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 1 then
        Osi.RemovePassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
    end
end

-- Function to apply Magic Allergy passive if the required statuses are present
local function updateMagicAllergy()
    if Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
       Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
       Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1 then
        if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 0 then
            Osi.AddPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
        end
    else
        if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 1 then
            Osi.RemovePassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
        end
    end
end

-- Listener for when any bomb status (Bomb1, Bomb2, or Bomb3) is applied to Gale
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, _)
    if target == galeCharID and (status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS or status == GALE_BOMB3_STATUS) then
        -- Apply Gale_WildMagic if not already applied
        applyGaleWildMagic()

        -- Check and apply Magic Allergy if any bomb status is present
        updateMagicAllergy()
    end
end)

-- Listener for when Bomb3 is removed from Gale (this is when we permanently remove Gale_WildMagic and apply the permanent flag)
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, _)
    if target == galeCharID and status == GALE_BOMB3_STATUS then
        -- Remove Gale_WildMagic when Bomb3 is removed
        removeGaleWildMagic()

        -- Recheck Magic Allergy status since Bomb3 was removed
        updateMagicAllergy()

        -- Apply the permanent flag to prevent Gale_WildMagic from being applied again
        Osi.ApplyStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL, -1, 1)
    end
end)

-- Listener for when any of the Bomb statuses are removed from Gale (Bomb1 or Bomb2)
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, _)
    if target == galeCharID and (status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS) then
        -- Recheck Magic Allergy status when Bomb1 or Bomb2 are removed
        updateMagicAllergy()
    end
end)
