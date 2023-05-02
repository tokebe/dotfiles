return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function()
    -- pcall(require('nvim-treesitter.install').update({ with_sync = true }))
    require('nvim-treesitter.configs').setup({
      highlight = {
        enabled = true,
        language_tree = true,
        is_supported = function()
          if vim.fn.strwidth(vim.fn.getline('.')) > 300 or vim.fn.getfsize(vim.fn.expand('%')) > 1024 * 1024 then
            return false
          else
            return true
          end
        end,
      },
    })
    require('treesitter-context').setup()
  end,
}
