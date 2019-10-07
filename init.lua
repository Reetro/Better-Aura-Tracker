---------------------------
-- Ace 3 Setup
---------------------------

BetterAuraTracker = LibStub("AceAddon-3.0"):NewAddon("BetterAuraTracker")
BetterAuraTrackerConsole = LibStub("AceAddon-3.0"):NewAddon("BetterAuraTrackerConsole", "AceConsole-3.0")

local A, L = ...

local _, core = ...; -- Namespace


function core:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Better Aura Tracker:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end


local function startup(self, event, arg2, ...)
	core.Aura.getAura()
	core.Config.CreateMenu()
end



function BetterAuraTracker:OnEnable()
	-- Called when the addon is enabled
	startup()
end