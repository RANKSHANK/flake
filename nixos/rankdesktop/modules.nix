{...}: {
    config = {

        disabledModules = [
            "qutebrowser"
            "neovim"
            "anyrun"
            # "nixvim"
        ];

        enabledModules = [
            "hyprland"
            "impermanence"
            "nvidia-gpu"
            "sops"
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
