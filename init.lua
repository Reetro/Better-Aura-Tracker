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

local function HandelSlashCommands(str)

 if (#str == 0) then	
		-- User just entered "/bat" with no additional args.
		core.commands.help();
		return;		
	end	
	
	local args = {};
	for _, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
		end
	end
	
	local path = core.commands; -- required for updating found table.
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then -- if string length is greater than 0.
			arg = arg:lower();			
			if (path[arg]) then
				if (type(path[arg]) == "function") then				
					-- all remaining args passed to our function!
					path[arg](select(id + 1, unpack(args))); 
					return;					
				elseif (type(path[arg]) == "table") then				
					path = path[arg]; -- another sub-table found!
				end
			else
				-- does not exist!
				core.commands.help();
				return;
			end
		end
	end

end


SLASH_BAT1 = "/bat"
SlashCmdList["BAT"] = HandelSlashCommands;


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