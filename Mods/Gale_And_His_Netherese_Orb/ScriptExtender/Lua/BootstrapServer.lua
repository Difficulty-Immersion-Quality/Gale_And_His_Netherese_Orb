-- Gale's Character ID
local galeCharID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local GALE_WILD_MAGIC_PASSIVE = "Gale_WildMagic"
local GALE_BOMB1_STATUS = "ORI_GALE_BOMB1"
local GALE_BOMB2_STATUS = "ORI_GALE_BOMB2"
local GALE_BOMB3_STATUS = "ORI_GALE_BOMB3"
local GALE_MAGIC_ALLERGY_UNLOCK = "GALE_GOON_MAGICALLERGY_UNLOCK"
local GALE_WILDMAGIC_PERMANENT_REMOVAL = "GALE_WILDMAGIC_PERMANENT_REMOVAL"

Ext.Utils.Print("[DEBUG] Mod script loaded successfully.")

-- Function to apply Gale_WildMagic passive if not already applied
local function applyGaleWildMagic()
    Ext.Utils.Print("[DEBUG] Applying Gale_WildMagic passive.")
    if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 0 and 
       Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 0 then
        Osi.AddPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
        Ext.Utils.Print("[DEBUG] Gale_WildMagic applied.")
    else
        Ext.Utils.Print("[DEBUG] Gale_WildMagic not applied (already applied or permanently removed).")
    end
end

-- Function to remove Gale_WildMagic passive
local function removeGaleWildMagic()
    Ext.Utils.Print("[DEBUG] Removing Gale_WildMagic passive.")
    if Osi.HasPassive(galeCharID, GALE_WILD_MAGIC_PASSIVE) == 1 then
        Osi.RemovePassive(galeCharID, GALE_WILD_MAGIC_PASSIVE)
        Ext.Utils.Print("[DEBUG] Gale_WildMagic removed.")
    else
        Ext.Utils.Print("[DEBUG] Gale_WildMagic was not active.")
    end
end

-- Function to update Magic Allergy status
local function updateMagicAllergy()
    Ext.Utils.Print("[DEBUG] Updating Magic Allergy status.")
    if Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
       Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
       Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1 then
        if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 0 then
            Ext.Utils.Print("[DEBUG] Applying Magic Allergy passive.")
            Osi.AddPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
        end
    else
        if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 1 then
            Ext.Utils.Print("[DEBUG] Removing Magic Allergy passive.")
            Osi.RemovePassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
        end
    end
end

-- Listener for Bomb statuses being applied or permanent removal
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(target, status, _)
    if target == galeCharID then
        Ext.Utils.Print("[DEBUG] Status applied: " .. status)

        if status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS or status == GALE_BOMB3_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb status detected. Applying Gale_WildMagic.")
            applyGaleWildMagic()
            updateMagicAllergy()
        elseif status == GALE_WILDMAGIC_PERMANENT_REMOVAL then
            Ext.Utils.Print("[DEBUG] Permanent removal status applied.")
            removeGaleWildMagic()
            if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 1 then
                Osi.RemovePassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
                Ext.Utils.Print("[DEBUG] Magic Allergy removed permanently.")
            end
        end
    end
end)

-- Listener for Bomb statuses being removed
Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(target, status, _)
    if target == galeCharID then
        Ext.Utils.Print("[DEBUG] Status removed: " .. status)

        if status == GALE_BOMB3_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb3 removed. Applying permanent removal.")
            removeGaleWildMagic()
            Osi.ApplyStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL, -1, 1)
        elseif status == GALE_BOMB1_STATUS or status == GALE_BOMB2_STATUS then
            Ext.Utils.Print("[DEBUG] Bomb status removed: " .. status)
            updateMagicAllergy()
        end
    end
end)

-- Listener for when gameplay starts
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level_name, is_editor_mode)
    Ext.Utils.Print("[DEBUG] LevelGameplayStarted triggered for level: " .. level_name)

    if not Osi.CharacterIsDead(galeCharID) then
        Ext.Utils.Print("[DEBUG] Gale is alive. Checking statuses and passives.")

        if Osi.HasActiveStatus(galeCharID, GALE_WILDMAGIC_PERMANENT_REMOVAL) == 1 then
            Ext.Utils.Print("[DEBUG] Permanent removal detected. Ensuring passives are cleared.")
            removeGaleWildMagic()
            if Osi.HasPassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK) == 1 then
                Osi.RemovePassive(galeCharID, GALE_MAGIC_ALLERGY_UNLOCK)
                Ext.Utils.Print("[DEBUG] Magic Allergy removed on gameplay start.")
            end
        else
            if Osi.HasActiveStatus(galeCharID, GALE_BOMB1_STATUS) == 1 or 
               Osi.HasActiveStatus(galeCharID, GALE_BOMB2_STATUS) == 1 or 
               Osi.HasActiveStatus(galeCharID, GALE_BOMB3_STATUS) == 1 then
                Ext.Utils.Print("[DEBUG] Bomb status detected on gameplay start. Applying Gale_WildMagic.")
                applyGaleWildMagic()
            end

            updateMagicAllergy()
        end
    else
        Ext.Utils.Print("[DEBUG] Gale is dead or not present. Skipping status checks.")
    end
end)
