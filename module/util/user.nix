{ user, ... }:

{
    users.users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "input"
        "adbusers"
        "tty"
        "dialout"
      ];
    };
}
