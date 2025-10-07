{
  users = {
    users = {
      dhcpcd.uid = 999;
      flatpak.uid = 998;
      greeter.uid = 997;
      nscd.uid = 996;
      rtkit.uid = 995;
      sshd.uid = 994;
      systemd-oom.uid = 993;
    };
    groups = {
      dhcpcd.gid = 999;
      flatpak.gid = 998;
      greeter.gid = 997;
      nscd.gid = 996;
      polkituser.gid = 995;
      resolvconf.gid = 994;
      rtkit.gid = 993;
      sshd.gid = 992;
      systemd-coredump.gid = 991;
      systemd-oom.gid = 990;
    };
  };
}
