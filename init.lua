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

-- TODO figure out why minimap icons don't appear on login
local function startup(self, event, arg2, ...)
	getAura()
	core.Config.CreateMenu()
end

function getAura()

	local buffFrameConfig = {
		framePoint      = { "TOPRIGHT", Minimap, "TOPLEFT", -5, -5 },
		frameScale      = 1,
		framePadding    = 5,
		buttonWidth     = 32,
		buttonHeight    = 32,
		buttonMargin    = 5,
		numCols         = 10,
		startPoint      = "TOPRIGHT",
		--rowMargin       = 20,
	  }

	for i=1,40 do
		local name, icon, _, _, _, etime = UnitBuff("player",i)
		if name then
			rBuffFrame:CreateBuffFrame(A,buffFrameConfig)
  		end
	  end

	local debuffFrameConfig = {
		  framePoint      = { "TOPRIGHT", buffFrame, "BOTTOMRIGHT", 0, -5 },
		  frameScale      = 1,
		  framePadding    = 5,
		  buttonWidth     = 40,
		  buttonHeight    = 40,
		  buttonMargin    = 5,
		  numCols         = 8,
		  startPoint      = "TOPRIGHT",
		}
		function SetDebuff()
			for i=1,40 do
			  local name, icon, _, _, _, etime = UnitDebuff("player",i)
			  if name then
				rBuffFrame:CreateDebuffFrame(A, debuffFrameConfig)
			end
		end
	  
	  end 

end

function BetterAuraTracker:OnEnable()
	-- Called when the addon is enabled
	startup()
end