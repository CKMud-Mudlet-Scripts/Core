-- This runs when ever we make the transition from fighting to not fighting
function onFinishedFighting()
  Toggles.meleefighting = false
  Times.lastfightfinished = getEpoch()
  Toggles.NEXTHT = nil
  echoc("\n<red>Fight Finished!")
end