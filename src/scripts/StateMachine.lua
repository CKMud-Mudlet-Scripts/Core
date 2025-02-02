local fried = require("CKMud-Core.fried")

registerAnonymousEventHandler(
  "sysLoadEvent",
  fried:run_init(
    "StateMachine",
    function()
      State =
        fried:make_enum(
          "State",
          {
            'REST',
            'REPAIR',
            'FLEE',
            'SEEK_REST',
            'CPU_REST',
            'SENSE',
            'NORMAL',
            'BUFFING',
            'CRAFTING',
          }
        )
      State._CURRENT_STATE = State.NORMAL
      State._PREV_STATE = State.NORMAL
    end
  )
)

function set_state(state)
  State._PREV_STATE = get_state() or State.NORMAL
  State._CURRENT_STATE = state
end

function get_state()
  return State._CURRENT_STATE
end

function state_revert()
  set_state(State._PREV_STATE)
end

function is_state(state, botmode)
  return get_state() == state and (botmode or Toggles.botmode or Toggles.training)
end

function pretty_state()
  local state = get_state()
  if state == State.REST then
    return "REST"
  elseif state == State.REPAIR then
    return "REPAIR"
  elseif state == State.FLEE then
    return "<yellow>FLEE"
  elseif state == State.SEEK_REST then
    return "SEEK_REST"
  elseif state == State.CPU_REST then
    return "CPU_REST"
  elseif state == State.NORMAL then
    return "NORMAL"
  elseif state == State.SENSE then
    return "SENSE"
  elseif state == State.BUFFING then
    return "<yellow>BUFFING"
  elseif state == State.CRAFTING then
    return "<yellow>CRAFTING"
  end
  return "UNKNOWN"
end