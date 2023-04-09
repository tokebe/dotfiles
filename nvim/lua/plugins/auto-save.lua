return {
  -- Autosave on text changed
  'Pocco81/auto-save.nvim',
  config = function()
    require('auto-save').setup({
      -- trigger_events = { 'InsertLeave' }
    })
    vim.api.nvim_set_keymap('n', "<leader>ta", ":ASToggle<CR>", {})
  end
}
