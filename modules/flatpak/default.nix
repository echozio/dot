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
            (map (p: "${p}:ro"))
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

        "org.signal.Signal".Environment = {
          SIGNAL_PASSWORD_STORE = "gnome-libsecret";
        };

        "com.mojang.Minecraft"."Session Bus Policy" = {
          "org.freedesktop.secrets" = "talk";
        };
      };

    packages = [
      "com.adamcake.Bolt"
      "com.discordapp.Discord"
      "com.github.Matoking.protontricks"
      "com.mojang.Minecraft"
      "com.slack.Slack"
      "com.spotify.Client"
      "com.valvesoftware.Steam"
      "io.github.lullabyX.sone"
      "org.freedesktop.Platform.VulkanLayer.gamescope//25.08"
      "org.freedesktop.Platform.VulkanLayer.MangoHud//25.08"
      "org.onlyoffice.desktopeditors"
      "org.signal.Signal"
      "xyz.tytanium.DoorKnocker"
    ];
  };

  environment.persistence."/fix" = {
    directories = [ "/var/lib/flatpak" ];
    users.${user}.directories = [ ".var/app" ];
  };
}
