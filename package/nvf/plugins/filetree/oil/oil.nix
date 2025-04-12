{ lib, ... }: let
    inherit (builtins) foldl';
    inherit (lib.types) bool enum float int lines listOf nullOr oneOf str submodule unique;
    inherit (lib.options) mkOption mkEnableOption;
    inherit (lib.nvim.types) mkPluginSetupOption;
    
    win_options = {
        default = {};
        type = submodule {
            options = {

                winblend = mkOption {
                    type = nullOr (float.between 0.0 1.0);
                    default = null;
                    description = ''
                        Blend for the floating window
                    '';
                };

                wrap = mkOption {
                    type = nullOr bool;
                    default = false;
                    description = ''
                        Whether or not long file names should wrap to the next line
                    '';
                };

                signcolumn = mkOption {
                    type = nullOr (enum [
                        "no"
                        "auto"
                    ]);
                    default = null;
                    description = ''
                        Flag for Whether the sign column should be shown
                    '';
                };

                cursorcolumn = mkOption {
                    type = nullOr bool;
                    default = null;
                    description = ''
                        Flag for whether the cursor column should be shown
                    '';
                };

                foldcolumn = mkOption {
                    type = nullOr str;
                    default = 0;
                    description = ''
                        How the foldcolumn is renderd
                        See :help foldcolumn
                    '';
                };

                spell = mkOption {
                    type = nullOr bool;
                    default = null;
                    description = ''
                        Flag for if spell check should be enabled for the window
                    '';
                };

                list = mkOption {
                    type = nullOr bool;
                    default = null;
                    description = ''
                        Flag for if listchars should be used for the window
                    '';
                };

                conceallevel = mkOption {
                    type = nullOr (int.between 0 3);
                    default = null;
                    description = ''
                        How concealed text is rendered
                        See :help conceallevel
                    '';
                };

                concealcursor = mkOption {
                    type = nullOr (listOf (unique (enum [
                        "n" "v" "i" "c"
                    ])));
                    default = null;
                    description = ''
                        Modes for where the cursor is concealed
                        See :help concealcursor
                    '';
                };
            };
        };
    };

in {
    options.vim.filetree.oil = {
        enable = mkEnableOption "filetree via oil.nvim";

        inherit win_options;

        setupOpts = mkPluginSetupOption "oil" {

            columns = mkOption {
                type = enum [
                    "icon"
                    "permissions"
                    "size"
                    "msize"
                ];
                description = '' 
                    Id is automatically added at the beginning, and name at the end
                    :help oil-columns
                '';
                default = [ ];
            };

            delete_to_trash = mkOption {
                default = false;
                description = ''
                    Send deleted files to the trash instead of permanently deleting them 
                    :help oil-trash
                '';
                type = bool;
            };

            buf_options = mkOption {
                default = {};
                type = submodule {
                    options = {

                        buflisted = mkOption {
                            type = bool;
                            default = false;
                        };

                        bufhidden = mkOption {
                            type = enum [
                                "hide"
                                "wipe"
                            ];
                            default = "hide";
                        };
                    };
                };
                description = ''
                    Buffer-local options to use for oil buffers
                '';
            };

            win_options = mkOption {
                default = {};
                type = submodule {
                    options = {

                        wrap = mkOption {
                            type = nullOr bool;
                            default = false;
                            description = ''
                                Whether or not long file names should wrap to the next line
                            '';
                        };

                        signcolumn = mkOption {
                            type = nullOr (enum [
                                "no"
                                "auto"
                            ]);
                            default = null;
                            description = ''
                                Flag for Whether the sign column should be shown
                            '';
                        };

                        cursorcolumn = mkOption {
                            type = nullOr bool;
                            default = null;
                            description = ''
                                Flag for whether the cursor column should be shown
                            '';
                        };

                        foldcolumn = mkOption {
                            type = nullOr str;
                            default = 0;
                            description = ''
                                How the foldcolumn is renderd
                                See :help foldcolumn
                            '';
                        };

                        spell = mkOption {
                            type = nullOr bool;
                            default = null;
                            description = ''
                                Flag for if spell check should be enabled for the window
                            '';
                        };

                        list = mkOption {
                            type = nullOr bool;
                            default = null;
                            description = ''
                                Flag for if listchars should be used for the window
                            '';
                        };

                        conceallevel = mkOption {
                            type = nullOr (int.between 0 3);
                            default = null;
                            description = ''
                                How concealed text is rendered
                                See :help conceallevel
                            '';
                        };

                        concealcursor = mkOption {
                            type = nullOr (listOf (unique (enum [
                                "n" "v" "i" "c"
                            ])));
                            default = null;
                            description = ''
                                Modes for where the cursor is concealed
                                See :help concealcursor
                            '';
                        };
                    };
                };
            };

            skip_confirm_for_simple_edits = mkOption {
                default = false;
                description =  ''
                    Skip the confirmation popup for simple operations
                    See :help oil.skip_confirm_for_simple_edits
                '';
                type = bool;
            };

            prompt_on_save_on_select_new_entry = mkOption {
                type = bool;
                default = false;
                description = ''
                    Selecting a new/moved/renamed file or directory will prompt you to save changes first
                    :help prompt_save_on_select_new_entry
                '';
            };

            cleanup_dealy_ms = mkOption {
                type = oneOf int.nonnegative bool;
                default = 2000;
                validation = val:
                    if val == true then
                        throw "The value 'true' for cleanup_dealy_ms is not allowed, must be false or an integer in milliseconds."
                    else
                        null;
                description = ''
                    Delay in milliseconds before a buffer is deleted.
                    Can be set to false instead to disable cleanup
                '';
            };

            lsp_file_methods = mkOption {
                type = submodule {
                    options = {
                        enabled = mkOption {
                            type = bool;
                            default = true;
                            description = ''
                                Enable flag for LSP file operations
                            '';
                        };
                        timeout_ms = mkOption {
                            type = int.nonnegative;
                            default = 1000;
                            description = ''
                                Time in milliseconds to wait befor skipping LSP file operations
                            '';
                        };
                        autosave_changes = mkOption {
                            type = bool;
                            default = false;
                            description = ''
                                Flag to autosave buffers modified by LSP file operations
                            '';
                        };
                    };
                };
                default = {};
            };

            constrain_cursor = mkOption {
                type = oneOf (enum [
                    "editable"
                    "name"
                ]) bool;
                validation = val:
                    if val == true then
                        throw "The value 'true' for cleanup_dealy_ms is not allowed, must be false or an integer in milliseconds."
                    else
                        null;
                default = "editable";
                description = ''
                    Constrain the cursor to the editable parts of the oil buffer
                    Set to `false` to disable, or 'name' to keep it on the file names
                '';
            };

            watch_for_changes = mkOption {
                type = bool;
                default = false;
                description = ''
                    Flag to reload oil buffers when the targeted directory changes
                '';
            };

            use_default_keymaps = mkOption {
                type = bool;
                default = true;
                description = ''
                    Flag for whether defaut key maps should be used
                '';
            };

            view_options = mkOption {
                options = {

                    show_hidden = mkOption {
                        type = bool;
                        default = false;
                        description = ''
                            Flag for if hidden files should be shown
                        '';
                    };

                    is_hidden_file = mkOption {
                        type = nullOr lines;
                        default = null;
                        description = ''
                            lua function for filtering hidden files
                        '';
                        example = ''
                            function(name, bufnr)
                              local m = name:match("^%.")
                              return m ~= nil
                            end
                        '';
                    };

                    is_always_hidden = mkOption {
                        type = nullOr lines;
                        default = null;
                        description = ''
                            lua function for files that are hidden regardless of toggle
                        '';
                        example = ''
                            function(name, bufnr)
                              return false
                            end
                        '';
                    };

                    natural_order = mkOption {
                        type = nullOr (oneOf (enum [
                            "fast"
                        ]) bool);
                        default = null;
                        description = ''
                            Sets whether or not numerics in filenames are combined to create
                            full values or sequentially.
                            'fast' disables the behavior in large directories
                        '';
                    };

                    case_insensitive = mkOption {
                        type = nullOr bool;
                        default = null;
                        description = ''
                            Flag for if case should be ignored for sorting
                        '';
                    };

                    sort = mkOption {
                        type = nullOr (listOf (listOf str));
                        default = null;
                        description = ''
                            Columns can be specified as a string to use default arguments (e.g. `"icon"`),
                            or as a table to pass parameters (e.g. `{"size", highlight = "Special"}`)
                            See '(:help oil-colums)'
                        '';
                        example = ''
                            vim.filetree.oil.sort = [
                              [ "type", "asc" ],
                              [ "name", "asc" ],
                            ];
                        '';
                    };

                    highlight_filename = mkOption {
                        type = nullOr lines;
                        default = null;
                        description = ''
                            Lua function that returns a specialized highlight group for targeted filenames;
                        '';
                    };

                    extra_scp_args = mkOption {
                        type = nullOr (listOf str);
                        default = null;
                        description = ''
                            Extra arguments to pass to SCP when moving/copying files over SSH
                        '';
                    };

                    git = mkOption {
                        type = submodule;
                        options = foldl' (acc: name: acc // { 
                            ${name} = mkOption {
                                type = nullOr lines;
                                default = null;
                                description = ''
                                    Lua function that returns a bool for whether git ${name}
                                    should be automatically run for the given ${
                                        if name != "mv" then
                                            "path"
                                        else
                                            "source and destination paths"}
                                '';
                            };
                        }) {} [ "add" "mv" "rm" ];
                    };
                };
            };

            float = mkOption {
                type = submodule;
                options = {
                    padding = mkOption {
                        type = nullOr int.nonnegative;
                        default = null;
                        description = ''
                            Paddding pixels around floating windows
                        '';
                    };

                    max_width = mkOption {
                        type = nullOr (oneOf int.nonnegative (float.between 0.0 1.0));
                        default = null;
                        description = ''
                            Either an integer for pixels or a float between 0 and 1 (e.g. 0.4 for 40%)
                        '';
                    };

                    max_height = mkOption {
                        type = nullOr (oneOf int.nonnegative (float.between 0.0 1.0));
                        default = null;
                        description = ''
                            Either an integer for pixels or a float between 0 and 1 (e.g. 0.4 for 40%)
                        '';
                    };

                    border = mkOption {
                        type = nullOr (enum [
                            "rounded"
                            "none"
                        ]);
                        default = null;
                        description = ''
                            Border style for the floating window
                        '';

                    };

                    win_options = mkOption {
                        type = submodule;
                        options = {
                        };
                    };

                    get_win_title = mkOption {
                        type = nullOr lines;
                        default = null;
                        description = ''
                            Lua function that can override the window title
                            Inputs:
                                winid: integer
                            Output:
                                string: the title
                        '';
                    };

                    preview_split = mkOption {
                        type = nullOr (enum [
                            "auto"
                            "left"
                            "right"
                            "above"
                            "below"
                        ]);
                        default = null;
                        description = ''
                            Direction relative to the window that the preview opens
                        '';
                    };

                    override = mkOption {
                        type = nullOr lines;
                        default = null;
                        description = ''
                            Lua function that allows overriding configuration before it is passed  to nvim_open_win
                            Inputs:
                                conf: table
                            Outputs:
                                table: the overriden configuration
                        '';
                    };

                };

            };

            preview_win = mkOption {
                type = submodule;
                options = {

                    inherit win_options;

                    update_on_cursor_moved = mkOption {
                        type = nullOr bool;
                        default = null;
                        description = ''
                            Flag for setting if thef preview updates when the cursor moves
                        '';
                    };

                    preview_method = mkOption {
                        type = nullOr (enum [
                            "load"
                            "scratch"
                            "fast_scratch"
                        ]);
                        default = null;
                        description = ''
                            How previews are opened
                            defaults to 'fast_scratch'
                        '';
                    };

                    disable_preview = mkOption {
                        type = nullOr lines;
                        default = null;
                        description = ''
                            Lua function for disabling previews on specific files
                            Inputs:
                                filename: str
                            Output:
                                bool: true to disable preview
                        '';
                    };

                };
            };

            confirmation = mkOption {
                type = submodule; 
                options = {
                    inherit win_options;

                    max_width = mkOption {
                        type = nullOr (oneOf int (listOf int));
                    };
                };
            };

        };
    };
}
