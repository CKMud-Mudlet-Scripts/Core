-- Every Prompt where we are not fighting

function onNotFightingPrompt()
  Toggles.EnemyLineComboTest = true
  Toggles.skip_fight = nil
  if false and is_state(State.NORMAL, true) and not Player.SUPPRESSED then
    send("suppress 69")
  end
  -- Remove when we have repair logic
  if
    ok_to_vent and
    (is_state(State.NORMAL, true) or is_state(State.REPAIR, true)) and
    Player.HEAT > 80
  then
    ok_to_vent = false
    if Toggles.botmode or Toggles.training then
      send("--")
    end
    send("vent")
    set_state(State.REST)
  end
  if is_state(State.REPAIR, true) and Player.HEALTH == 100 then
    set_state(State.NORMAL)
  end
  if (is_state(State.FLEE) or is_state(State.NORMAL, true)) and Player.HEALTH <= 50 then
    set_state(State.REPAIR)
  end
  if
    (is_state(State.REST, true) or is_state(State.REPAIR, true)) and
    Player.HEALTH < 100
  then
    send("repair")
  end
  -- Timed Status Refreshes
  if is_state(State.NORMAL, true) and last(Times.laststatus) > 240 then
    send("status")
    Times.laststatus = getEpoch()
  end
  if is_state(State.NORMAL, true) and last(Times.lastscore) > 240 then
    send("score")
    Times.lastscore = getEpoch()
  end
  if false and is_state(State.NORMAL, true) and last(Times.lasttrain) > 120 then
    send("train")
    Times.lasttrain = getEpoch()
  end
  if is_state(State.NORMAL, true) and Player.HEAT == 0 and last(Times.lastscouterself) > 900 then
    send("analyze self")
    Times.lastscouterself = getEpoch()
  end
  -- Handle Send Queue
  SendQueue.trySendNow()
  if not SendQueue.hasnext() then
    -- Handle Action Queue
    ActionQueue.doAction()
  end
end