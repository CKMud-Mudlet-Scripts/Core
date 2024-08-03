local wat = matches[2]
if wat ~= "Combo" and wat ~= "DEAD" then
  -- Enemy line comes first
  Toggles.EnemyLineComboTest = true
elseif wat == "Combo" then
  Toggles.EnemyLineComboTest = false
  local combos = string.trim(matches[3])
  Player.COMBO = string.split(combos, ", ")
  if last_combo ~= combos then
    COMBO_ID = {}
  end
  last_combo = combos
  iThinkWeFighting()
end
