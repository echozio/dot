{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";

    disko.url = "github:nix-community/disko/v1.12.0";
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    walker.url = "github:abenz1267/walker";
    elephant.url = "github:abenz1267/elephant";
    nixpak.url = "github:nixpak/nixpak";
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.6.0";
    imsh-clients.url = "github:echozio/imsh-clients";

    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    walker.inputs.nixpkgs.follows = "nixpkgs";
    walker.inputs.elephant.follows = "elephant";
    elephant.inputs.nixpkgs.follows = "nixpkgs";
    nixpak.inputs.nixpkgs.follows = "nixpkgs";
    imsh-clients.inputs.nixpkgs.follows = "nixpkgs";

    sec.url = "github:echozio/sec";
  };

  outputs =
    inputs@{
      self,
      disko,
      nixpkgs,
      ...
    }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      argsFor = system: {
        pkgs = nixpkgs.legacyPackages.${system};
        disko = disko.packages.${system}.disko;
      };
      forAllSystems = f: lib.genAttrs systems (system: f (argsFor system));
    in
    {
      devShells = forAllSystems (
        { pkgs, disko, ... }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixos-rebuild
              nixos-anywhere
              ssh-to-age
              disko
              (writeShellScriptBin "generate-host-keys" ''
                host="$1"
                out="tmp/fix"
                if [ -z "$host" ]; then
                  echo "Usage: $(basename "$0") hostname" >&2
                  exit 1
                fi
                umask 0022
                mkdir -p "$out/etc/ssh"
                ${openssh}/bin/ssh-keygen -t ed25519 -f "$out/etc/ssh/ssh_host_ed25519_key" -C "root@$host" -q -N ""
                cat <<EOF
                age public key:
                  $(${ssh-to-age}/bin/ssh-to-age < "$out/etc/ssh/ssh_host_ed25519_key.pub")

                install with:
                  nixos-anywhere --flake .#$host --extra-files tmp --target-host root@$host

                remember to:
                  rm -rf tmp
                EOF

              '')
            ];
          };
        }
      );
      packages = forAllSystems (
        { pkgs, ... }:
        {
          neovim-minimal = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
            vimAlias = true;
            viAlias = true;
            luaRcContent = builtins.readFile ./neovim.lua;
            withRuby = false;
          };
        }
      );

      nixosModules.default = ./modules;

      nixosConfigurations =
        let
          mkHost =
            module:
            lib.nixosSystem {
              specialArgs = inputs;
              modules = [
                self.nixosModules.default
                module
              ];
            };
        in
        {
          vm = mkHost ./hosts/vm;
          rc = mkHost ./hosts/rc;
          ws = mkHost ./hosts/ws;
        };

      formatter = forAllSystems (
        { pkgs, ... }:
        pkgs.treefmt.withConfig {
          settings = {
            on-unmatched = "info";
            formatter.nixfmt = {
              command = lib.getExe pkgs.nixfmt-rfc-style;
              includes = [ "*.nix" ];
            };
          };
        }
      );
    };
}
