local State = {
  Colours = {
    {   0,   0,   0},
    {   0,   0,   0},
    {   0,   8,   0},
    {   0,  16,   0},
    {   0,  32,   0},
    {   0,  48,   0},
    {   0,  64,   0}
  },
  NumColours = 7
}

local Bitter = function(S)
  local Colour = S.Colours[math.random(S.NumColours)]
  SetLED(math.random(52), Colour[1], Colour[2], Colour[3])
end

return 30, Bitter, State