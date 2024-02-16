local function close_unmodified_buffers()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == bufnr then return end
        end
        if vim.api.nvim_buf_get_option(bufnr, 'modified') then return end
        vim.api.nvim_buf_delete(bufnr, {})
    end
end

vim.api.nvim_create_autocmd("BufLeave", {
    callback = close_unmodified_buffers,
})

return {}
