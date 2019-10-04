function GetBuffTimeLeft()
    local _, _, _, _, _, duration, expirationTime = UnitBuff("player", "Blutschild")
    return duration or 0, expirationTime or 0
end



