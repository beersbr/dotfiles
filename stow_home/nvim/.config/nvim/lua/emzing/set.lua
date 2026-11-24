vim.opt.rnu = true
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.mouse = "a"
vim.opt.breakindent = true
local is_wsl2 = vim.uv.os_uname().release:lower():find("microsoft-standard", 1, true) ~= nil

if is_wsl2 then
	local win32yank = vim.fn.expand("~/.local/bin/win32yank.exe")

	vim.g.clipboard = {
		name = "win32yank",
		copy = {
			["+"] = { win32yank, "-i", "--crlf" },
			["*"] = { win32yank, "-i", "--crlf" },
		},
		paste = {
			["+"] = { win32yank, "-o", "--lf" },
			["*"] = { win32yank, "-o", "--lf" },
		},
		cache_enabled = 0,
	}
end

vim.opt.clipboard = "unnamedplus"
vim.opt.showmode = false
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = true

vim.opt.list = true

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.scrolloff = 8
vim.opt.ff = "unix"

vim.opt.signcolumn = "yes"

vim.opt.isfname:append("@-@")
vim.opt.inccommand = "split"

vim.opt.cursorline = true

vim.fileformat = "unix"
vim.opt.updatetime = 50
vim.opt.colorcolumn = "110"

local colors = {
	fg = "#c0c0c0",
	bg = "#6a4a6a",
	fg_inactive = "#909090",
	bg_inactive = "#343434",
}

vim.api.nvim_set_hl(0, "StatusLine", {
	fg = colors.fg,
	bg = colors.bg,
	bold = true,
})

vim.api.nvim_set_hl(0, "StatusLineNC", {
	fg = colors.fg_inactive,
	bg = colors.bg_inactive,
})
