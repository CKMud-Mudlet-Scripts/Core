-- Put all your focus buffs in this list
local list_of_affects = {"resonance", "forcefield", "herculean force", "infravision", "hasshuken", "zanzoken", "energy shield", "kino tsurugi"}


function handleBuffs(seen)
  for _, affect in ipairs(skill_filter_only_learned(list_of_affects)) do
    if not seen[affect] then
      echoc("\n<cyan>Need Rebuff: "..affect)
      focus_buff(affect)
    end
  end
end

function focus_buff(affect)
  send("focus '" .. affect .. "'")
end