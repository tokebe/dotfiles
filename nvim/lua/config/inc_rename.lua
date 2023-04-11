return {
  config = function()
    require('inc_rename').setup({
      input_buffer_type = 'dressing',
    })
    vim.keymap.set("n", "<leader>gr", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
  end
}
