--This even Fires every single Prompt
function onPrompt()
  -- Lets make sure we get a prompt on a regular cadence
  if Timers.forceprompt ~= nil then
    killTimer(Timers.forceprompt)
    Timers.forceprompt = nil
  end
  Timers.forceprompt =
    tempTimer(
      30,
      function()
        send("score")
      end
    )
  
  if not Player.HT then
    Toggles.NEXTHT = nil
  end
  -- Things that had not been set since last prompt maybe we can clear
  if Toggles.fighting and not isPromptCounterActive('fighting') then
    Toggles.fighting = false
    raiseEvent("onFinishedFighting")
  end
  -- Lets handle fighting and non fighting stuff
  if Toggles.fighting then
    raiseEvent("onFightingPrompt")
  else
    raiseEvent("onNotFightingPrompt")
  end
  
  -- Handle Buffs before we clear flags
  if PromptFlags.affections and is_state(State.NORMAL, true) then
    handleBuffs(PromptFlags.affects)
  end
  
  -- All flags since last prompt should be cleared so next prompt we can take action
  PromptFlags = {}
  decPromptCounters()
end

function decPromptCounters()
  for k, v in pairs(PromptCounters) do
    if v ~= nil then
      if v <= 1 then
        PromptCounters[k] = nil
      elseif v ~= nil then
        PromptCounters[k] = v - 1
      end
    end
  end
end

function isPromptCounterActive(name)
  return PromptCounters[name] ~= nil
end

function iThinkWeFighting()
  -- If we have two prompts with not fight messages its safe to say fighting is over
  PromptCounters.fighting = 3
end

