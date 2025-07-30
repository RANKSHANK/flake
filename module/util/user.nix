{user, ...}: {
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "video"
      "input"
      "adbusers"
      "tty"
      "dialout"
    ];
  };
}
