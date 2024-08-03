-- The Action Queue
-- This doesn't have much reason to exist now
-- but the idea is a bunch of triggers add things to do to the "queue" (its not really as queue)
-- only the first one in gets executed
ActionQueue = {}

function ActionQueue.doAction()
  if ActionQueue.pending ~= nil then
    ActionQueue.pending()
    ActionQueue.pending = nil
  end
end

function ActionQueue.addAction(callback)
  if ActionQueue.pending == nil then
    ActionQueue.pending = callback
  end
  seek_target = nil
end


-- END Action Queue