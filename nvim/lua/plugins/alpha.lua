local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {

	[[      .___                                                  ]],
	[[    __| _/___________    ____  __ _____  ________    ____   ]],
	[[   / __ |\_  __ \__  \ _/ ___\|  |  \  \/  /\__  \  /    \  ]],
	[[  / /_/ | |  | \// __ \\  \___|  |  />    <  / __ \|   |  \ ]],
	[[  \____ | |__|  (____  /\___  >____//__/\_ \(____  /___|  / ]],
	[[       \/            \/     \/            \/     \/     \/  ]],
}

dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
	dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
	dashboard.button("n", "  New file", "<cmd>ene | startinsert<cr>"),
	dashboard.button("c", "  Config", "<cmd>e $MYVIMRC<cr>"),
	dashboard.button("l", "  Lazygit", "<cmd>lua _LAZYGIT_TOGGLE()<cr>"),
	-- dashboard.button("s", "  Restore Session", "<cmd>lua require('persistence').load()<cr>"),
	dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
}

for _, button in ipairs(dashboard.section.buttons.val) do
	button.opts.hl = "AlphaButtons"
	button.opts.hl_shortcut = "AlphaShortcut"
end

dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"

dashboard.opts.layout[1].val = 8

return dashboard.config
