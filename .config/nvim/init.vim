set nu
set rnu

"
"keymaps
map é $

"indentation
set et
set sts=4
set sw=4

"define plugins
call plug#begin()

"treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  

"lspconfig
Plug 'neovim/nvim-lspconfig'


"dap
Plug 'mfussenegger/nvim-dap'


Plug 'mfussenegger/nvim-dap-python'

"luasnip
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} " Replace <CurrentMajor> by the latest released major (first number of latest release)
Plug 'rafamadriz/friendly-snippets'
Plug 'molleweide/LuaSnip-snippets.nvim'

"nvim-cmp
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'saadparwaiz1/cmp_luasnip'

"indentation guides
Plug 'lukas-reineke/indent-blankline.nvim'

"autopairs
Plug 'windwp/nvim-autopairs'

"lsp setup
"lua
"Plug 'folke/lazydev.nvim'

call plug#end()

"python-dap
lua << EOF
    require("dap-python").setup("debugpy-adapter")

EOF

"indentation guides
lua require("ibl").setup()

"autopairs
lua << EOF
    require("nvim-autopairs").setup
    {
        check_ts = true, -- enable treesitter integration
    }

    --[[

    _G.MPairsCR = function()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_get_current_line()
      local prev = line:sub(col, col)
      local next = line:sub(col + 1, col + 1)

      if prev == "{" and next == "}" and line:sub(1, col - 1):match("%)%s*$") then
        local indent = line:match("^(%s*)") or ""

        vim.schedule(function()
          local cur_row = vim.api.nvim_win_get_cursor(0)[1]

          -- Replace line with Allman-style block
          vim.api.nvim_buf_set_lines(0, cur_row - 1, cur_row, false, {
            line:sub(1, col - 1),
            indent .. "{",
            indent .. "    ",
            indent .. "}",
          })

          -- Defer cursor move slightly to allow line insertion to complete
          vim.defer_fn(function()
            vim.api.nvim_win_set_cursor(0, {cur_row + 1, #indent + 4})
          end, 0)
        end)
        return ""
      end

      return require("nvim-autopairs").autopairs_cr()
    end

    vim.api.nvim_set_keymap("i", "<CR>", "v:lua.MPairsCR()", { expr = true, noremap = true })

    ]]



EOF



"lspconfig
lua vim.lsp.enable(vimls)
lua vim.lsp.enable(pylsp)

lua << EOF



EOF

lua << EOF

    --setup snippets
    return function()

        local luasnip = require("luasnip")

        -- be sure to load this first since it overwrites the snippets table.
        luasnip.snippets = require("luasnip-snippets").load_snippets()

        require("luasnip.loaders.from_vscode").lazy_load()

    end

EOF

lua << EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --   capabilities = capabilities
  -- }

EOF




"enable treesitter
lua << EOF
require'nvim-treesitter.configs'.setup{

    --languages to install treesitter for
    ensure_installed = {

        "c",
        "lua",
        "bash",
        "cpp",
        "dockerfile",
        "json",
        "markdown",
        "vim",
        "xml",


        "python",

        },


    --enable syntax-highlighting
    highlight={enable=true}

}


--enable folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
EOF




