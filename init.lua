local _, core = ...; -- Namespace

function core:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Better Aura Tracker:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end
core.commands = {
	["config"] = core.Config.Toggle, -- this is a function (no knowledge of Config object)
	
	["help"] = function()
		print(" ");
		core:Print("List of slash commands:")
		core:Print("|cff00cc66/bat config|r - shows config menu");
		core:Print("|cff00cc66/bat help|r - shows help info");
		print(" ");
	end
};
local function HandelSlashCommands(str)

 if (#str == 0) then	
		-- User just entered "/at" with no additional args.
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
	core:Print("Welcome back", UnitName("player").."! To bring up options use /bat config");
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", startup)