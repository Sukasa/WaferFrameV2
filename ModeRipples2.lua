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
  Ripples = { }, -- { Loc, Dir, Value }
  Splashes = { }, -- { Age, Loc }
  Step = 0,
  Speed = 0.32,
  Delay = 35,
  FadeRate = 0.9,
  FadeMin = 0.015,
  SpawnDelay = 6,
  SpawnStep = 0
}

local Ripples = function(S)
  local MakeRipple = function(LED, Value)
    local A = LED - math.floor(LED)
    local LED1 = math.floor(LED)
    local LED2 = math.ceil(LED)
    
    if LED1 < 0 then LED1 = LED1 + 52 end
    if LED2 < 0 then LED2 = LED2 + 52 end
    if LED1 > 52 then LED1 = LED1 - 52 end
    if LED2 > 52 then LED2 = LED2 - 52 end
    
    local R, G, B = GetLED(LED2)
    SetLED(LED2, math.max(R, S.Colour[1] * A * Value), math.max(G, S.Colour[2] * A * Value), math.max(B, S.Colour[3] * A * Value))
      
    R, G, B = GetLED(LED1)
    SetLED(LED1, math.max(R, S.Colour[1] * (1 - A) * Value), math.max(G, S.Colour[2] * (1 - A) * Value), math.max(B, S.Colour[3] * (1 - A) * Value))
  end

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
  S.Step = (S.Step + 1) % 16 -- 128
  
  for i = 1, 52, 1 do
    SetLED(i, 0, 0, 0)
  end

  for i = #S.Ripples, 1, -1 do
    local Ripple = S.Ripples[i]
    Ripple[1] = Ripple[1] + Ripple[2]
    Ripple[3] = math.max(0, math.min(Ripple[3] * S.FadeRate, Ripple[3] - S.FadeMin))
    if Ripple[3] < 0.01 then
      table.remove(S.Ripples, i)
    else
      MakeRipple(Ripple[1], Ripple[3])
    end
  end  

  for i = #S.Splashes, 1, -1 do
    local Splash = S.Splashes[i]
    Splash[1] = Splash[1] + 1
    Splash[3] = Splash[3] + 0.25
    SetLED(Splash[2], S.Colour[1] * Splash[3], S.Colour[2] * Splash[3], S.Colour[3] * Splash[3])
    if Splash[1] == 4 then
      table.insert(S.Ripples, {Splash[2], -S.Speed, 1})
      table.insert(S.Ripples, {Splash[2],  S.Speed, 1})
      table.remove(S.Splashes, i)
    end
  end
  
  S.SpawnStep = S.SpawnStep + 1
  if S.SpawnStep >= S.SpawnDelay then
    S.SpawnStep = 0
    -- New ripple
    local N = math.random(52)
    table.insert(S.Splashes, {0, N, 0} )
  end
  
end

return State.Delay, Ripples, State