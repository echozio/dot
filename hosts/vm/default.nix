{
  modulesPath,
  sec,
  user,
  ...
}:
{
  imports = [
    sec.nixosModules.dot

    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  disko.devices.disk.system.device = "/dev/vda";

  networking = {
    hostName = "vm";
    hostId = "522ef8a2";
  };

  home-manager.users.${user}.wayland.windowManager.hyprland.settings."$mod" = "ALT";
}
