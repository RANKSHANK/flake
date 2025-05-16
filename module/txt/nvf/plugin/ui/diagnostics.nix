{ ... }:
{
    vim.diagnostics = {
        enable = true;
        config = {
            virtual_lines = true;
        };
        nvim-lint = {
            enable = true;
        };
    };
}
