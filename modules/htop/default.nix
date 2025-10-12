{ pkgs, ... }:
{
  programs.htop = {
    enable = true;

    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
      shadow_other_users = true;
      highlight_base_name = true;
      update_interval = 1;
      show_cpu_frequency = true;
      show_cpu_temperature = true;
    };

    package = pkgs.htop.overrideAttrs {
      patches = [ ./keys.patch ];
    };
  };
}
