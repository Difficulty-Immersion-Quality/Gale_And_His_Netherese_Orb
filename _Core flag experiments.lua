local Gale = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local BombDisarmedFlag = "ORI_Gale_Event_BombDisarmed_3d014e79-5595-9365-87bb-5cbb1f87fe5c"
local StatusToRemove = "GOON_GALE_MAGICAL_APPETITE_UNLOCK"

-- Check on gameplay start
Ext.Osiris.RegisterListener("FlagLoadedInPresetEvent", 2, "after", function(object, flag)
    if object == Gale and flag == BombDisarmedFlag then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_Gale_Event_BombDisarmed flag set. Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)

-- Check when ORI_GALE_BOMB3 status is removed
-- Ext.Osiris.RegisterListener("StatusRemoved", 2, "after", function(character, status)
--     if status == "ORI_GALE_BOMB3" and character == Gale then
--         Osi.RemoveStatus(Gale, StatusToRemove)
--         print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMB3 status removed. Gale is no longer hungry, status cleared:", StatusToRemove)
--     end
-- end)

-- React if the bomb disarmed flag gets set mid-game
Ext.Osiris.RegisterListener("FlagSet", 3, "after", function(flag, speaker, dialogInstance)
    if flag == BombDisarmedFlag and speaker == Gale then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_Gale_Event_BombDisarmed flag set. Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)
