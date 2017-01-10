local State = {
  Colours = {
    {255,   0,   0},
    {  0, 255, 255},
    {  0, 255,   0},
    {255,   0, 255},
    {  0,   0, 255},
    {255, 255,   0}
  },
  Step = 0,
  Stride = 3,
  Index = 1,
  Count = 6
}

local Christmas = function(S)
  Advance()
  
  if S.Step == 0 then
    local Colour = S.Colours[S.Index]
    SetLED(1, Colour[1], Colour[2], Colour[3])
    S.Index = (S.Index % S.Count) + 1
  else
    SetLED(1, 0, 0, 0)
  end
  S.Step = (S.Step + 1) % S.Stride
end

return 600, Christmas, State