local State = {
  Steps = {
      { 0,  1,  0},
      {-1,  0,  0}, 
      { 0,  0,  1},
      { 0, -1,  0},
      { 1,  0,  0},
      { 0,  0, -1},
      { 1,  0,  0}
  },
  StepCount = 6,
  MaxSteps = 255,
  Step = 7,
  StepsRemaining = 255
}

local Rainbow = function(S)
  Advance()
  local R, G, B = GetLED(2)
  local Step = S.Steps[S.Step]
  
  SetLED(1, R + Step[1], G + Step[2], B + Step[3])
  
  S.StepsRemaining = S.StepsRemaining - 1
  if (S.StepsRemaining == 0) then
    S.StepsRemaining = S.MaxSteps
    if S.Step == 7 then
      S.Step = 0
    end
    S.Step = (S.Step % S.StepCount) + 1
  end  
end

return 10, Rainbow, State