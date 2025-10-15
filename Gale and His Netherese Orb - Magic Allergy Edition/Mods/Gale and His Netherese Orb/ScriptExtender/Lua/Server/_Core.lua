local Gale = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local DoneWithItemsTag = "ORI_GALE_DONEWITHITEMS_f37724b5-9235-4ab2-8d65-78efcf50f95b"
local StatusToRemove = "GOON_GALE_MAGICAL_APPETITE_UNLOCK"

-- Run when gameplay starts
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    if Osi.IsTagged(Gale, DoneWithItemsTag) == 1 then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_DONEWITHITEMS tag found, Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)

-- Run when ORI_GALE_BOMB3 is removed from any character
Ext.Osiris.RegisterListener("StatusRemoved", 2, "after", function(character, status)
    if status == "ORI_GALE_BOMB3" and character == Gale then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMB3 status removed, Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)