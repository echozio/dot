{ user, ... }:
{
  home-manager.users.${user} =
    { config, ... }:
    let
      application = name: "${config.home.path}/share/applications/${name}.desktop";
      flatpak = id: "/var/lib/flatpak/exports/share/applications/${id}.desktop";
    in
    {
      wayland.windowManager.hyprland = {
        extraLuaFiles.layouts = ./layouts.lua;

        settings.workspace_rule = [
          {
            workspace = "1";
            layout = "lua:inbox";
          }
          {
            workspace = "3";
            layout = "lua:comms";
          }
        ];
      };

      xdg.autostart = {
        enable = true;
        entries =
          map application [
            "aerc"
            "nom"
            "glirc"
            "signal"
            "firefox"
          ]
          ++ map flatpak [
            "com.spotify.Client"
            "com.slack.Slack"
            "com.discordapp.Discord"
            "com.valvesoftware.Steam"
          ];
      };
    };
}
