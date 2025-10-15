local GaleGUID = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local BombDisarmedTagUUID = "f37724b5-9235-4ab2-8d65-78efcf50f95b" -- ORI_GALE_BOMBDISARMED_f37724b5-9235-4ab2-8d65-78efcf50f95b
local StatusToRemove = "GOON_GALE_MAGICAL_APPETITE_UNLOCK"

-- Helper function to check if Gale has the disarmed tag
local function GaleHasDisarmedTag()
    return Osi.IsTagged(GaleGUID, BombDisarmedTagUUID) == 1
end

-- On gameplay start, remove status if tag already exists
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, _)
    if GaleHasDisarmedTag() then
        Osi.RemoveStatus(GaleGUID, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMBDISARMED tag found, Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)

-- React dynamically if the tag is applied during gameplay
Ext.Osiris.RegisterListener("TagSet", 2, "after", function(object, tag)
    if object == GaleGUID and tag == BombDisarmedTagUUID then
        Osi.RemoveStatus(GaleGUID, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMBDISARMED tag found, Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)
