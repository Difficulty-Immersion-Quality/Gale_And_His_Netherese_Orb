local Gale = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local DoneWithItemsTag = "ORI_GALE_BOMBDISARMED_f37724b5-9235-4ab2-8d65-78efcf50f95b"
local StatusToRemove = "GOON_GALE_MAGICAL_APPETITE_UNLOCK"

-- On gameplay start, check if Gale already has the tag
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    if Osi.IsTagged(Gale, DoneWithItemsTag) == 1 then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMBDISARMED tag found, Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)

-- React dynamically if the tag gets added during play
Ext.Osiris.RegisterListener("TagSet", 2, "after", function(object, tag)
    if object == Gale and tag == DoneWithItemsTag then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMBDISARMED tag found, Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)
