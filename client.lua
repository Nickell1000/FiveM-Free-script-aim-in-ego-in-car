local wasFirstPerson = false

Citizen.CreateThread(function()
    while true do
        local waitTime = 200
        local ped = PlayerPedId()

        if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
            if IsPedInAnyVehicle(ped, false) then
                waitTime = 0
                local player = PlayerId()
                local isAiming = IsPlayerFreeAiming(player)
                local weapon = GetSelectedPedWeapon(ped)

                -- 🔫 Liste der Waffen, bei denen Ego aktiviert wird:
                local allowedWeapons = {
                    GetHashKey("WEAPON_PISTOL"),
                    GetHashKey("WEAPON_COMBATPISTOL"),
                    GetHashKey("WEAPON_CARBINERIFLE"),
                    GetHashKey("WEAPON_PISTOL_MK2")
                }

                -- Prüfen, ob aktuelle Waffe in der Liste ist
                local weaponAllowed = false
                for _, w in ipairs(allowedWeapons) do
                    if weapon == w then
                        weaponAllowed = true
                        break
                    end
                end

                -- Wenn gezielt wird und Waffe erlaubt ist
                if isAiming and weaponAllowed then
                    if not wasFirstPerson then
                        if SetFollowVehicleCamViewMode then
                            SetFollowVehicleCamViewMode(4)
                        end
                        if SetFollowPedCamViewMode then
                            SetFollowPedCamViewMode(4)
                        end
                        wasFirstPerson = true
                    end
                else
                    if wasFirstPerson then
                        if SetFollowVehicleCamViewMode then
                            SetFollowVehicleCamViewMode(1)
                        end
                        if SetFollowPedCamViewMode then
                            SetFollowPedCamViewMode(1)
                        end
                        wasFirstPerson = false
                    end
                end
            else
                if wasFirstPerson then
                    if SetFollowVehicleCamViewMode then SetFollowVehicleCamViewMode(1) end
                    if SetFollowPedCamViewMode then SetFollowPedCamViewMode(1) end
                    wasFirstPerson = false
                end
            end
        end

        Citizen.Wait(waitTime)
    end
end)
