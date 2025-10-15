local GaleGUID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local BombDisarmedTagUUID = "f37724b5-9235-4ab2-8d65-78efcf50f95b" -- ORI_GALE_BOMBDISARMED_f37724b5-9235-4ab2-8d65-78efcf50f95b
local StatusToRemove = "GOON_GALE_MAGICAL_APPETITE_UNLOCK"

local function CheckAndRemoveStatus(char)
    -- print("[Gale Appetite Debug] Running CheckAndRemoveStatus on:", char)

    local hasTag = Osi.IsTagged(char, BombDisarmedTagUUID)
    -- print("[Gale Appetite Debug] Tag check result:", hasTag)

    if hasTag == 1 then
        local hasStatus = Osi.HasActiveStatus(char, StatusToRemove)
        -- print("[Gale Appetite Debug] Status check result:", hasStatus)

        if hasStatus == 1 then
            Osi.RemoveStatus(char, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMBDISARMED tag found, Gale is no longer hungry, clearing status:", StatusToRemove)
            -- print("[Gale Appetite Debug] Removed status:", StatusToRemove)
        else
            -- print("[Gale Appetite Debug] Gale does not have the status.")
        end
    else
        -- print("[Gale Appetite Debug] Gale does NOT have the disarmed tag.")
    end
end

-- Run once on level start (after delay so Gale actually exists)
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, _)
    print("[Gale Appetite Debug] LevelGameplayStarted triggered on:", levelName)

    Ext.Timer.WaitFor(2000, function()
        -- print("[Gale Appetite Debug] Attempting direct Gale check after delay...")
        CheckAndRemoveStatus(GaleGUID)
    end)
end)

-- Helper function to check if a character has the tag and remove the status
local function CheckAndRemoveStatus(charGUID)
    if Osi.IsTagged(charGUID, BombDisarmedTagUUID) == 1 then
        Osi.RemoveStatus(charGUID, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMBDISARMED tag found, Gale is no longer hungry, clearing status:", StatusToRemove)
    end
end

-- React dynamically if the tag is applied during gameplay
Ext.Osiris.RegisterListener("TagSet", 2, "after", function(object, tag)
    if object == GaleGUID and tag == BombDisarmedTagUUID then
        CheckAndRemoveStatus(object)
    end
end)
