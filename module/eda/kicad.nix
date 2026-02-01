{
  config,
  lib,
  pkgs,
  user,
  util,
  ...
}: let
  inherit (lib.attrsets) attrValues filterAttrs listToAttrs mapAttrs;
  inherit (lib.lists) elemAt genList length;
  inherit (lib.strings) hasPrefix stringLength;
  inherit (lib.trivial) mod;
  inherit (util) hexToRgb mkModule;
in
  mkModule "kicad" ["desktop" "cad"] {
    environment.systemPackages = attrValues {
      inherit (pkgs) kicad-unstable-small;
      # inherit (inputs.nix-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}) kicad; # OOM -_-
    };
    services.flatpak.packages = [
      # "flathub-beta:app/org.kicad.KiCad"
      "flathub-beta:app/org.kicad.KiCad.Library.Packages3D/${pkgs.stdenv.hostPlatform.system}/beta"
    ];

    home-manager.users.${user}.xdg.configFile."kicad/9.99/colors/stylix.json".text = let
      colors = mapAttrs (_: hexToRgb) (filterAttrs (name: _: (stringLength name == 6 && hasPrefix "base" name)) config.lib.stylix.colors);
      rgb = mapAttrs (_: val: "rgb(${toString val.r}, ${toString val.g}, ${toString val.b})") colors;
      rgba = mapAttrs (_: val: opacity: "rgba(${toString val.r}, ${toString val.g}, ${toString val.b}, ${toString opacity})") colors;
    in
      builtins.toJSON {
        meta = {
          filename = "stylix";
          name = "Stylix";
          version = 1;
        };
        "3d_viewer" = {
          background_bottom = rgb.base00;
          background_top = rgb.base02;
          board = rgb.base08;
          copper = rgb.base0F;
          silkscreen_bottom = rgb.base01;
          silkscreen_top = rgb.base01;
          soldermask = rgb.base0E;
          solderpaste = rgb.base0D;
        };
        board = {
          anchor = rgb.base0E;
          aux_items = rgb.base0A;
          b_adhesive = rgb.base0C;
          b_crtyd = rgb.base0B;
          b_fab = rgb.base0C;
          b_mask = rgb.base09;
          b_paste = rgb.base08;
          b_silks = rgb.base0E;
          background = rgb.base00;
          cmts_user = rgb.base0C;
          copper = let
            genCopper = selections: count:
              listToAttrs (genList (index: {
                  name = "in${toString (index + 1)}";
                  value = elemAt selections (mod index (length selections));
                })
                count);
          in
            {
              b = rgb.base0B;
              f = rgb.base08;
            }
            // genCopper (with rgb; [base0F base0A base0D base09 base0E base0C]) 30;
          cursor = rgb.base05;
          drc_error = rgb.base08;
          drc_exclusion = rgb.base0C;
          drc_warning = rgb.base09;
          dwgs_user = rgb.base04;
          edge_cuts = rgb.base09;
          f_adhes = rgb.base0E;
          f_crtyd = rgb.base05;
          f_fab = rgb.base02;
          f_mask = rgb.base0E;
          f_paste = rgb.base08;
          f_silks = rgb.base0C;
          footprint_text_back = rgb.base04;
          footprint_text_front = rgb.base05;
          footprint_text_invisible = rgb.base05;
          grid = rgb.base01;
          grid_axes = rgb.base01;
          margin = rgb.base08;
          no_connect = rgb.base0E;
          pad_back = rgb.base0B;
          pad_front = rgb.base09;
          pad_plated_hole = rgb.base09;
          pad_through_hole = rgb.base09;
          plated_hole = rgb.base09;
          ratsnest = rgb.base05;
          select_overlay = rgba.base05 0.5;
          through_via = rgb.base01;
          via = rgb.base00;
          via_blind_buried = rgb.base09;
          via_micro = rgb.base0C;
          via_through = rgb.base01;
          worksheet = rgb.base0E;
        };
        gerbview = {
          axes = rgb.base0D;
          background = rgb.base00;
          dcodes = rgb.base05;
          grid = rgb.base01;
          layers = with rgb; [
            base08
            base09
          ];
          negative_objects = rgb.base03;
          worksheet = rgb.base0D;
        };
        palette = (attrValues rgb);
        schematic = {
          aux_items = rgb.base05;
          background = rgb.base00;
          brightened = rgb.base09;
          bus = rgb.base0C;
          bus_junction = rgb.base0C;
          component_body = rgb.base01;
          component_outline = rgb.base05;
          cursor = rgb.base05;
          erc_error = rgb.base08;
          erc_warning = rgb.base0A;
          fields = rgb.base0E;
          grid = rgb.base01;
          grid_axis = rgb.base0C;
          hidden = rgb.base01;
          junction = rgb.base0B;
          label_global = rgb.base0E;
          label_hier = rgb.base0D;
          label_local = rgb.base0D;
          net_name = rgb.base04;
          no_connect = rgb.base04;
          note = rgb.base04;
          override_item_colors = false;
          pin = rgb.base08;
          pin_name = rgb.base0B;
          pin_number = rgb.base08;
          reference = rgb.base0C;
          shadow = rgba.base00 0.8;
          sheet_background = "rgba(255, 255, 255, 0.00)";
          sheet_fields = rgb.base05;
          sheet_filename = rgb.base05;
          sheet_label = rgb.base05;
          sheet_name = rgb.base05;
          value = rgb.base04;
          wire = rgb.base0B;
          worksheet = rgb.base05;
        };
      };
  }
