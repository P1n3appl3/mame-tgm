
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = rec {
      mame-tgm = pkgs.callPackage ./mame-tgm.nix {};
      mame-tgm-wrapped = pkgs.callPackage ./mame-tgm-wrapper.nix {
        inherit mame-tgm;
      };
      default = mame-tgm-wrapped;

    inherit (pkgs.callPackage ./tgm.nix { inherit mame-tgm-wrapped; }) tap tgm;
    };
    checks.${system} = self.packages.${system}.mame-tgm.tests;
  };
}
