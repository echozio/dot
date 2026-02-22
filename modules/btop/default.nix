{ lib, pkgs, ... }:
let
  package = pkgs.btop-rocm;

  config = pkgs.writeText "btop.conf" ''
    vim_keys = true
    color_theme = "nord"
    theme_background = false
    presets = ""
    shown_boxes = "proc cpu mem net"
    update_ms = 100
    freq_mode = "range"
    save_config_on_exit = false
    clock_format = "/user@/host %X %z @%s"
  '';

  wrapper = pkgs.writeShellScript "btop" ''
    ${lib.getExe package}\
      --themes-dir ${package}/share/btop/themes \
      --config ${config} \
      "$@"
  '';
in
{
  environment.systemPackages = [
  ];

  security.wrappers.btop = {
    owner = "root";
    group = "root";
    source = wrapper;
    capabilities = "cap_perfmon+ep cap_dac_read_search=+ep";
  };
}
