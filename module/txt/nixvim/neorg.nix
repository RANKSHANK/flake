{ config, lib, ... }:

lib.mkSubmodule "nixvim" config {
    programs.nixvim = {
        plugins.neorg = {
            enable = true;
            lazyLoading = true;
        modules = let
            empty = { __empty = null; };
        in {
            "core.defaults" = empty;
            "core.concealer" = empty;
            "core.dirman" = {
                config = {
                    workspaces = {
                        notes = "$XDG_DOCUMENTS_DIR/notes";
                    };
                };
            };
            "core.integrations.telescope" = empty;
            # "core.ui.calendar" = empty;
            "core.summary" = empty;
          };
        };
      };
}
