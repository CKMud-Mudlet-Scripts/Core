if PromptFlags.scorecard then
  Player.MONEY = tonumber(string.trim(string.gsub(matches[2], ",", "")))
  echoc(
    string.format(
      '      <dim_gray>Gauntlet Runs:<yellow> %s\n',
      reformatInt(math.floor(Player.MONEY / 25000000))
    )
  )
end