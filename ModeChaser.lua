local State = { 
  StepCount = 1,
  Step = 0,
  Step1 = 0,
  MaxSteps = 18
}

local Chaser = function(S)
  SetLED(S.Step1, 0, 0, 0)
  SetLED(44 - S.Step1, 0, 0, 0)
  
  SetLED(S.Step, 0, 64, 0)
  SetLED(44 - S.Step, 0, 64, 0)
  
  S.Step1 = S.Step
  S.Step = S.Step + S.StepCount  
  
  SetLED(S.Step, 0, 255, 0)
  SetLED(44 - S.Step, 0, 255, 0)
  
  if S.Step == 0 or S.Step == S.MaxSteps then
    S.StepCount = -S.StepCount
  end
end

return 50, Chaser, State