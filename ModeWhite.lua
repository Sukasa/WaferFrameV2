local White = function()
  for i = 1, 52 do
    SetLED(i, 96, 255, 160)
  end
end
return 500, White, nil