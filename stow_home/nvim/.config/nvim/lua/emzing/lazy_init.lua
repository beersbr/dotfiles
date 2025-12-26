local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {"nvim-lua/plenary.nvim"},
    {
        "zenbones-theme/zenbones.nvim",
        dependencies = "rktjmp/lush.nvim",
        lazy=false,
        priority = 10000,
        init = function()
            vim.opt.background = "dark",
            vim.cmd.colorscheme("zenbones")
            vim.cmd.hi("Comment gui=none")
        end
    },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false }
    },
    {
        "nvim-mini/mini.nvim", version="*",
        config = function(_, opts)
            require("mini.statusline").setup()
            require("mini.completion").setup()
            pick = require("mini.pick")
            pick.setup()

            vim.keymap.set("n", "<leader>sf", pick.builtin.files)
            vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "bash", "python", "c", "cpp", "lua", "luadoc", "markdown", "vim", "vimdoc" },
            indent = { enable = true }
        },
        config = function(_, opts)
            require("nvim-treesitter").install({
                prefer_git = true,
                "rust",
                "zig",
                "c",
                "python",
                "bash",
                "cpp",
                "lua",
                "luadoc",
                "markdown",
                "vim",
                "vimdoc" 
            })
 
        end

    }
})
