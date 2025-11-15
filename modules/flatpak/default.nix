{
  user,
  config,
  nix-flatpak,
  ...
}:
{
  imports = [
    nix-flatpak.nixosModules.nix-flatpak
  ];

  home-manager.sharedModules = [
    nix-flatpak.homeManagerModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;
    uninstallUnmanagedPackages = true;

    update.auto = {
      enable = true;
      onCalendar = "daily";
    };

    overrides = {
      "com.adamcake.Bolt".Environment = {
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      "com.valvesoftware.Steam".Context.filesystems = [
        "xdg-config/MangoHud:ro"
        "${config.home-manager.users.chris.home-files}/.config/MangoHud/MangoHud.conf:ro"
      ];
    };

    packages = [
      "com.adamcake.Bolt"
      "com.discordapp.Discord"
      "com.slack.Slack"
      "com.spotify.Client"
      "com.valvesoftware.Steam"
      "org.freedesktop.Platform.VulkanLayer.MangoHud//25.08"
      "org.onlyoffice.desktopeditors"
      "xyz.tytanium.DoorKnocker"
    ];
  };

  environment.persistence."/fix" = {
    directories = [ "/var/lib/flatpak" ];
    users.${user}.directories = [
      ".var/app"
    ];
  };
}
