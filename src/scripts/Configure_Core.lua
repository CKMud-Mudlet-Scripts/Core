local fried = require("CKMud-Core.fried")

-- Initalize how we use EMCO
registerAnonymousEventHandler(
  "sysLoadEvent",
  fried:run_init(
    "EMCO Tabs",
    function()
      demonnic.chat.consoles = {"All", "OOC", "Tells", "Group", "Auction", "Event", "Say"}
      demonnic.helpers.save()
    end
  )
)

-- Initalize the used Tables
registerAnonymousEventHandler(
    "sysLoadEvent",
    fried:run_init(
        "Core",
        function()
            cecho("<green>[ FRIED ] - Starting __PKGNAME__ v__VERSION__\n")
            Counters = {}
            Player = {}
            Times = {}
            Timers = {}
            Toggles = {}
            PromptCounters = {}
            PromptFlags = {}
            Settings = {}
            Settings.config_attack = "attack 90"
            -- Auto Learning / Mastery
            Player.Learned = {}
            Player.Mastered = {}
            Player.Boosted = {}
            Player.Supreme = {}
            -- Toggle Defaults
            Toggles.standing = true
            Toggles.no_fight = false
            Toggles.wakeok = true
        end
    )
)