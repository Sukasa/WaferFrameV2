local State = {
  Colours = {
    {   0, 255,   0},
    { 255,   0,   0},
    {   0,   0, 255},
    { 255, 255,   0},
    { 255,   0, 255},
    { 128, 255, 255},
  },
  Colour = 1,
  NumColours = 6,
  StepCount = 1,
  Step = 0,
  Step1 = 0,
  MaxSteps = 18
}

local Chaser2 = function(S)
  local Color = S.Colours[S.Colour]
  
  SetLED(S.Step1, 0, 0, 0)
  SetLED(45 - S.Step1, 0, 0, 0)
  
  SetLED(S.Step, Color[1] / 4, Color[2] / 4, Color[3] / 4)
  SetLED(45 - S.Step, Color[1] / 4, Color[2] / 4, Color[3] / 4)
  
  S.Step1 = S.Step
  S.Step = S.Step + S.StepCount  
  
  SetLED(S.Step, Color[1], Color[2], Color[3])
  SetLED(45 - S.Step, Color[1], Color[2], Color[3])
  
  if S.Step == 0 or S.Step == S.MaxSteps then
    S.StepCount = -S.StepCount
  end
  
  if S.Step == 0 then
    S.Colour = (S.Colour % S.NumColours) + 1
  end
end

return 50, Chaser2, State