if string.find(matches[2], "^alias ") ~= nil then
  send(matches[2], false)
else
  for _, v in ipairs(string.split(matches[2], ";")) do
    if v ~= "" then
      send(v, false)
    end
  end
end