APCounter = {
    addonName = "APCounter",
    command = "/apc",
    window = APCounter_Window,

    vars = {},
}

function APCounter.ToggleWindow()
    local self = APCounter

    SCENE_MANAGER:ToggleTopLevel(self.window)
end

function APCounter.Log()
    local self = APCounter

    local timestamp = GetTimeStamp()
    local hour = math.floor(timestamp / 3600)
    local type = "kill"
    local points = math.random(1, 1000)

    if (not self.vars.journal[hour]) then self.vars.journal[hour] = {} end

    table.insert(self.vars.journal[hour], {
        timestamp,
        type,
        points,
    })
end

function APCounter.Get()
    local self = APCounter

    --d(self.journal)
    d(self.vars.journal)
end

function APCounter.Initialize()
    local self = APCounter

    SLASH_COMMANDS[self.command] = self.ToggleWindow
    SLASH_COMMANDS["/apc_add"] = self.Log
    SLASH_COMMANDS["/apc_get"] = self.Get

    local defaults = {
        journal = {}
    }
    self.vars = ZO_SavedVars:NewCharacterIdSettings("APCounterSavedVariables", 1, nil, defaults)

    SCENE_MANAGER:RegisterTopLevel(self.window, locksUIMode)
end

function APCounter.OnAddOnLoaded(event, addonName)
    if addonName ~= APCounter.addonName then return end

    local self = APCounter

    self.Initialize()
    EVENT_MANAGER:UnregisterForEvent(APCounter.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(APCounter.addonName, EVENT_ADD_ON_LOADED, APCounter.OnAddOnLoaded)
