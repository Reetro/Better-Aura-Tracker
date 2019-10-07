local A, L = ...
local _, core = ...;
core.Aura = {}
local Aura = core.Aura

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
    rowMargin       = 20,
  }

  rBuffFrame:CreateBuffFrame(A,buffFrameConfig)
 
end


function CreateDebuffFrame()
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
  
  rBuffFrame:CreateDebuffFrame(A, debuffFrameConfig)

end 

function Aura:getAura()
  for i=1,40 do
    local name, icon, _, _, _, etime = UnitBuff("player",i)
    if name then
      CreateBuffFrame()    
    end
  end
  for i=1,40 do
    local name, icon, _, _, _, etime = UnitDebuff("player",i)
    if name then
      CreateDebuffFrame()
    end
  end 
end

local frame = CreateFrame("FRAME", "AuraFrame");
frame:RegisterEvent("UNIT_AURA");
frame:SetScript("OnEvent", getAura);