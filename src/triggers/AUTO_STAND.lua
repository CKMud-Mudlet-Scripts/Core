Toggles.standing = false
Toggles.fighting = true
iThinkWeFighting()
PromptFlags.fighting = true
if not Toggles.triedtostand then
  send("stand")
  Toggles.triedtostand = true
end