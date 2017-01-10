local Party = function()
  for i = 0, 51 do
    SetLED(i, math.random(255), math.random(255), math.random(255))
  end
end

return 100, Party, nil