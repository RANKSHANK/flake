{ config, lib, ... }:

lib.mkModule "nixvim-codeium" [ "nixvim" "codeium" ] config {
    programs.nixvim = {
        plugins = {
            codeium-vim = { # codeium.nvim isn't feature complete
                enable = true;
                settings = {
                    no_map_tab = true;
                    disable_bindings = true;
                };
            };
            #  cmp.settings.sources = [{
            #     name = "codeium";
            #     priority = 5;
            #     groupIndex = 1;
            # }];
        };
        highlightOverride = let
            colors = config.lib.stylix.colors.withHashtag;
        in {
            CodeiumSuggestion = {
                fg = colors.base0F;
            };
        };

        keymaps = [
            { # Not sure why but overrding the default does not work
                key = "<C-Space>";
                action = "codeium#Accept()";
                mode = [ "i" ];
                options = {
                    silent = true;
                    script = true;
                    nowait = true;
                    expr = true;
                    desc = "Codeium Accept";
                };
            }
        ];
    };
}
