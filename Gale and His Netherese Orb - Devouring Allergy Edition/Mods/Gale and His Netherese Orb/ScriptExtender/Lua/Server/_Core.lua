local Gale = "S_Player_Gale_ad9af97d-75da-406a-ae13-7071c563f604"
local BombDisarmedFlag = "ORI_Gale_Event_BombDisarmed_3d014e79-5595-9365-87bb-5cbb1f87fe5c"
local StatusToRemove = "GOON_GALE_MAGICAL_APPETITE_UNLOCK"

-- Helper: check if the flag is set for an object
local function FlagIsSet(flag, object)
    return Osi.IsFlag(flag, object) == 1
end

-- 1️⃣ Check on gameplay start
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, isEditorMode)
    if FlagIsSet(BombDisarmedFlag, Gale) then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_Gale_Event_BombDisarmed flag set. Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)

-- 2️⃣ Check when ORI_GALE_BOMB3 status is removed
Ext.Osiris.RegisterListener("StatusRemoved", 2, "after", function(character, status)
    if status == "ORI_GALE_BOMB3" and character == Gale then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_GALE_BOMB3 status removed. Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)

-- 3️⃣ React if the bomb disarmed flag gets set mid-game
Ext.Osiris.RegisterListener("FlagSet", 3, "after", function(flag, speaker, dialogInstance)
    if flag == BombDisarmedFlag and speaker == Gale then
        Osi.RemoveStatus(Gale, StatusToRemove)
        print("[Gale and His Netherese Orb - A Magical Appetite] ORI_Gale_Event_BombDisarmed flag set. Gale is no longer hungry, status cleared:", StatusToRemove)
    end
end)
