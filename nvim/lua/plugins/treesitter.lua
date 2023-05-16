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
        disable = function(lang, bufnr)
          local max_filesize = 1024 * 1024 -- 1MB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
    })
    require('treesitter-context').setup({
      max_lines = 3
    })
  end,
}
