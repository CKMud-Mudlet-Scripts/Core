if is_connected() then
if (Toggles.botmode or Toggles.training) and last(Times.lastprompt) > 8 then
  send("\n")
end
end