if APCounter == nil then APCounter = {} end

APCounter.addonName = "APCounter"
APCounter.command = "/apc"
APCounter.window = APCounter_Window

function APCounter.Open()
    local self = APCounter

    self.window:SetHidden(false)
end

function APCounter.Close()
    local self = APCounter

    self.window:SetHidden(true)
end

function APCounter.Initialize()
    local self = APCounter

    SLASH_COMMANDS[self.command] = self.Open
end

function APCounter.OnAddOnLoaded(event, addonName)
    if addonName ~= APCounter.addonName then return end

    local self = APCounter

    self.Initialize()
    EVENT_MANAGER:UnregisterForEvent(APCounter.addonName, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(APCounter.name, EVENT_ADD_ON_LOADED, APCounter.OnAddOnLoaded)
