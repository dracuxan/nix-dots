require("bufferline").setup({
	options = {
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		mode = "buffers",
		name_formatter = function(buf)
			local relative_path = vim.fn.fnamemodify(buf.path, ":.") -- Convert to relative path

			if relative_path:match("/") then
				-- If file is in a subdirectory, show "subdir/filename"
				return vim.fn.fnamemodify(relative_path, ":h:t") .. "/" .. vim.fn.fnamemodify(relative_path, ":t")
			end

			-- Otherwise, show only the filename
			return vim.fn.fnamemodify(relative_path, ":t")
		end,
		-- set to "tabs" to only show tabpages instead
		themable = true, -- allows highlight groups to be overridden
		numbers = "none", -- "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
		close_command = "bd! %d", -- Use 'bd! %d' instead if 'Bdelete' is unavailable
		buffer_close_icon = "✗",
		close_icon = "✗",
		path_components = 2, -- Show only the file name without the directory
		modified_icon = "●",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 30,
		max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
		tab_size = 21,
		diagnostics = "nvim_lsp",
		color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		separator_style = { "│", "│" }, -- "thick" | "thin" | { 'any', 'any' },
		enforce_regular_tabs = true,
		always_show_bufferline = false,
		show_tab_indicators = false,
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				local sym = e == "error" and " " or (e == "warning" and " " or " ")
				s = s .. n .. sym
			end
			return s
		end,
		icon_pinned = "󰐃",
		minimum_padding = 1,
		maximum_padding = 5,
		maximum_length = 15,
		sort_by = "insert_at_end",
	},
	highlights = {
		separator = {
			fg = "#434C5E",
		},
		buffer_selected = {
			bold = true,
			italic = false,
		},
	},
})
