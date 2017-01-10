local State = {
  Fades = {
    { 0,  1,  0},
    {-1,  0,  0}, 
    { 0,  0,  1},
    { 0, -1,  0},
    { 1,  0,  0},
    { 0,  1,  0},
    { 0, -1, -1}
  },
  FadeIndex = 1,
  FadeCount = 7,
  FadeStep = 0,
  Colour = { 127,   0,   0 },
  Ripples = { }, -- { Age, Pos1, Pos2, Pos1b, Pos2b }
  Step = 0
}
local Ripples = function(S)
  if S.Step == 0 then
    S.Colour[1] = S.Colour[1] + S.Fades[S.FadeIndex][1]
    S.Colour[2] = S.Colour[2] + S.Fades[S.FadeIndex][2]
    S.Colour[3] = S.Colour[3] + S.Fades[S.FadeIndex][3]
    S.FadeStep = S.FadeStep + 1
    if S.FadeStep == 127 then
      S.FadeStep = 0
      S.FadeIndex = (S.FadeIndex % S.FadeCount) + 1
    end
  end
  S.Step = (S.Step + 1) % 48
  for i = #S.Ripples, 1, -1 do
    local Ripple = S.Ripples[i]
    Ripple[1] = Ripple[1] + 1
    SetLED(Ripple[4], 0, 0, 0)
    SetLED(Ripple[5], 0, 0, 0)
    if Ripple[1] >= 9 then
      table.remove(S.Ripples, i)
      SetLED(Ripple[2], 0, 0, 0)
      SetLED(Ripple[3], 0, 0, 0)
    else
      local isnew = Ripple[2] == Ripple[3]
      Ripple[4] = Ripple[2]
      local Old1, Old2, Old3 = GetLED(Ripple[2])
      Ripple[2] = Ripple[2] - 1
      if Ripple[2] == 0 then Ripple[2] = 52 end
      Old1 = Old1 / 2
      Old2 = Old2 / 2
      Old3 = Old3 / 2
      SetLED(Ripple[4], Old1 / 3, Old2 / 3, Old3 / 3)
      SetLED(Ripple[2], Old1, Old2, Old3)
      Ripple[5] = Ripple[3]
      if not isnew then
        Old1, Old2, Old3 = GetLED(Ripple[3])
        Old1 = Old1 / 2
        Old2 = Old2 / 2
        Old3 = Old3 / 2
      end
      Ripple[3] = Ripple[3] + 1
      if Ripple[3] == 52 then Ripple[3] = 1 end    
      SetLED(Ripple[5], Old1 / 3, Old2 / 3, Old3 / 3)
      SetLED(Ripple[3], Old1, Old2, Old3)
    end
  end
  if S.Step % 3 == 0 then
    -- New ripple
    local N = math.random(52)
    table.insert(S.Ripples, {0, N, N, -1, -1})
    SetLED(N, S.Colour[1], S.Colour[2], S.Colour[3])
  end
end
return 80, Ripples, State