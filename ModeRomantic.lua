local State = {
  Step = 0,
  StepCount = 1
}

local Romantic = function(S)
  Advance()
  S.Step = S.Step + S.StepCount
  if S.Step == 0 or S.Step == 255 then
    S.StepCount = -S.StepCount
  end
  local Hint = math.max(0, S.Step - 96) / 4
  SetLED(1, S.Step, Hint, Hint)
end

return 30, Romantic, State