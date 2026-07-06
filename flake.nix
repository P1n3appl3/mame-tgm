{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }: {
      overlays.default = final: prev: {
        mame-tgm-unwrapped = final.callPackage ./mame-tgm.nix { };
        mame-tgm = final.callPackage ./mame-tgm-wrapper.nix { };
        tgm-games = final.callPackage ./tgm.nix { };
      };
    }
    // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend self.overlays.default;
      in
      {
        packages = {
          default = pkgs.mame-tgm;
          inherit (pkgs) mame-tgm mame-tgm-unwrapped;
          inherit (pkgs.tgm-games) tap tgm;
        };
        checks = pkgs.mame-tgm-unwrapped.tests;
      }
    ));
}
