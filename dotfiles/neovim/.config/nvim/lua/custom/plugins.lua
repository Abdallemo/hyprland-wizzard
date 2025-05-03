local plugins = {
  {
    'nvimtools/none-ls.nvim',
    --event= "VeryLazy",
    opts = function()
      return require('custom.configs.null-ls')
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('plugins.configs.lspconfig')
      require('custom.configs.lspconfig')
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
  },
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = {
        'typescript-language-server',
        'tailwindcss-language-server',
        'eslint-lsp',
        'prettierd',
        'bash-language-server',
        'dockerfile-language-server',
        -- 'dockerfile-language-server',
      }
    }
  }
}


return plugins
