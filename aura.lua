local A, L = ...

function ConvertSpellNameToID(name)
	for i = 1, 100000 do
		if name == GetSpellInfo(i) then
			return i
		end
	end
end

function CreateBuffFrame()
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

  rBuffFrame:CreateBuffFrame(A,buffFrameConfig)
  

end


function CreateDebuffFrame()
  
end 

function SetAura()
  for i=1,40 do
    local name, icon, _, _, _, etime = UnitBuff("player",i)
    local id = ConvertSpellNameToID(name)
    if name then
      CreateBuffFrame()    
    end
  end
end


local frame = CreateFrame("FRAME", "AuraFrame");
frame:RegisterEvent("UNIT_AURA");
frame:SetScript("OnEvent", SetAura);

