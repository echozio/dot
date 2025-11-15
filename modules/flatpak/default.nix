{
  lib,
  config,
  pkgs,

  nix-flatpak,

  user,
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
    uninstallUnmanaged = true;

    update.auto = {
      enable = true;
      onCalendar = "daily";
    };

    overrides =
      let
        hmConfig = config.home-manager.users.${user};

        storePath =
          path:
          lib.pipe path [
            (rootPaths: pkgs.closureInfo { inherit rootPaths; })
            (closureInfo: builtins.readFile "${closureInfo}/store-paths")
            (lib.splitString "\n")
            (builtins.filter (p: p != ""))
            (builtins.map (p: "${p}:ro"))
          ];
      in
      {
        global = {
          Context.filesystems = [
            "xdg-config/MangoHud:ro"
            "${hmConfig.home-files}/.config/MangoHud/MangoHud.conf:ro"
            "${hmConfig.home-files}/.local/share/icons:ro"
            "${hmConfig.xdg.dataFile."icons/default/index.theme".source}:ro"
          ]
          ++ (storePath hmConfig.home.pointerCursor.package);

          Environment = {
            XCURSOR_PATH = "${hmConfig.home-files}/.local/share/icons";
          };
        };

        "com.adamcake.Bolt".Environment = {
          _JAVA_AWT_WM_NONREPARENTING = "1";
        };
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
    users.${user}.directories = [ ".var/app" ];
  };
}
