local wasFirstPerson = false

-- 🔧 HIER kannst du den Ego-FOV einstellen
local FPS_FOV = 75       -- z. B. 65, 70, 75, 80
local DEFAULT_FOV = 55   -- normaler Standard-FOV

-- 🔫 Waffen, bei denen es aktiv ist
local allowedWeapons = {
    GetHashKey("WEAPON_PISTOL"),
    GetHashKey("WEAPON_COMBATPISTOL"),
    GetHashKey("WEAPON_PISTOL_MK2"),
    GetHashKey("WEAPON_CARBINERIFLE")
}

-- Hilfsfunktion: Waffe erlaubt?
local function isWeaponAllowed(weapon)
    for _, w in ipairs(allowedWeapons) do
        if weapon == w then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        local waitTime = 200
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            waitTime = 0
            local player = PlayerId()
            local isAiming = IsPlayerFreeAiming(player)
            local weapon = GetSelectedPedWeapon(ped)

            if isAiming and isWeaponAllowed(weapon) then
                if not wasFirstPerson then
                    -- 🎥 Ego-Perspektive
                    SetFollowVehicleCamViewMode(4)
                    SetFollowPedCamViewMode(4)

                    -- 👁 FPS-FOV setzen
                    SetProfileSetting(227, FPS_FOV) 
                    -- 227 = profile_fpsFieldofView

                    wasFirstPerson = true
                end
            else
                if wasFirstPerson then
                    -- Zurücksetzen
                    SetFollowVehicleCamViewMode(1)
                    SetFollowPedCamViewMode(1)

                    -- FOV zurück auf normal
                    SetProfileSetting(227, DEFAULT_FOV)

                    wasFirstPerson = false
                end
            end
        else
            if wasFirstPerson then
                SetFollowVehicleCamViewMode(1)
                SetFollowPedCamViewMode(1)
                SetProfileSetting(227, DEFAULT_FOV)
                wasFirstPerson = false
            end
        end

        Citizen.Wait(waitTime)
    end
end)
