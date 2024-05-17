APCounter = {
    addonName = "APCounter",
    command = "/apc",
    window = APCounter_Window,
    reasons = {
        -- [40] Repair something
        [CURRENCY_CHANGE_REASON_KEEP_REPAIR] = true,
        -- [13] Killing a player
        [CURRENCY_CHANGE_REASON_KILL] = true,
        -- [74] Capture a resource (+), keep (?), outpost (?), imperial city flag (?)
        [CURRENCY_CHANGE_REASON_OFFENSIVE_KEEP_REWARD] = true,
        -- ?? battleground match
        -- ?? daily reward
    },
    vars = {},
}

function APCounter.ToggleWindow()
    SCENE_MANAGER:ToggleTopLevel(APCounter.window)
end

function APCounter.Get()
    local timestamp = GetTimeStamp()
    local hour = math.floor(timestamp / 3600)

    if (not APCounter.vars.journal[hour]) then
        APCounter.vars.journal[hour] = {
            general = {},
            repair = {},
        }
    end

    table.insert(APCounter.vars.journal[hour]['general'], {
        timestamp,
        40,
        1000,
    })

    --d(self.journal)
    --d(self.vars.journal)
end

function APCounter.Initialize()
    SLASH_COMMANDS[APCounter.command] = APCounter.ToggleWindow
    SLASH_COMMANDS["/apc_get"] = APCounter.Get

    local defaults = {
        journal = {}
    }
    APCounter.vars = ZO_SavedVars:NewCharacterIdSettings("APCounterSavedVariables", 1, nil, defaults)

    SCENE_MANAGER:RegisterTopLevel(APCounter.window, locksUIMode)
    EVENT_MANAGER:RegisterForEvent(APCounter.addonName, EVENT_ALLIANCE_POINT_UPDATE, APCounter.OnAlliancePointsUpdate)
end

function APCounter.OnAlliancePointsUpdate(_, _, _, difference, reason)
    if not APCounter.reasons[reason] then
        return
    end

    local timestamp = GetTimeStamp()
    local hour = math.floor(timestamp / 3600)

    if (not APCounter.vars.journal[hour]) then
        APCounter.vars.journal[hour] = {
            -- journal for solid reasons
            general = {},
            -- journal for sum of repairs, prevent to spam log
            repair = {},
        }
    end


    --[[
    TODO Для ремонта обновляем счетчик так, чтобы была сумма полученных AP за целый час. Ключ repair.
    TODO Для всего остального пишем лог. Ключ general. В перспективе учимся расширять остальные причины деталями:
    TODO - убийство игрока - @tag + character
    TODO - захват ресурса/крепости/аванпоста/флага - Name of it
    TODO -

    table.insert(APCounter.vars.journal[hour], {
        timestamp,
        reason,
        difference,
    })]]
end

function APCounter.OnAddOnLoaded(event, addonName)
    if addonName ~= APCounter.addonName then return end

    APCounter.Initialize()
    EVENT_MANAGER:UnregisterForEvent(APCounter.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(APCounter.addonName, EVENT_ADD_ON_LOADED, APCounter.OnAddOnLoaded)
