{...}: {
    config = {

        disabledModules = [
            "qutebrowser"
#            "neovim"
            "anyrun"
            "thunderbird"
            "dwarf-fortress"
            "nixvim"
        ];

        enabledModules = [
            "hyprland"
            "impermanence"
            "nvidia-gpu"
            "theme"
        ];

        enabledTags = [
            "audio"
            "communication"
            "connectivity"
            "cad"
            "desktop"
            "filesystem"
            "gaming"
            "graphics"
            # "math"
            "office"
            "repo"
            "shell"
            "sync"
            "video"
            "virtualization"
            "wayland"
            "xdg"
        ];
    };
}
