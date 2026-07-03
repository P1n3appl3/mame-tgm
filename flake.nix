
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # TODO: move
    # in the install step, need to `magick ${tgm_icon} -resize '256x256!' tgm.png`
    tgm_icon = pkgs.lib.fetchurl {
      url = "https://tetris.wiki/images/5/57/Arika_tgm1_title.jpg";
      hash = "";
    };
    tap_icon = pkgs.lib.fetchurl {
      url = "https://tetris.wiki/images/5/51/Arika_tap_title.jpg";
      hash = "";
    };
    tgm_desktop = pkgs.lib.makeDesktopItem {
      name = "Tetris The Grandmaster";
      desktopName = "TGM";
      icon = "tgm";
      exec = "tgm-mame -joy -inp tgm1.inp tgmj";
      comment = "The first TGM game";
      categories = [ "Game" ];
    };
    tap_desktop = pkgs.lib.makeDesktopItem {
      name = "Tetris The Absolute The Grand Master 2 PLUS";
      desktopName = "TAP";
      icon = "tap";
      exec = "tgm-mame -joy -inp tgm2p.inp tgm2p";
      comment = "The second TGM game";
      categories = [ "Game" ];
    };
  in {
    packages.${system} = rec {
      mame-tgm = pkgs.callPackage ./mame-tgm.nix {};
      mame-tgm-wrapped = pkgs.callPackage ./mame-tgm-wrapper.nix {
        inherit mame-tgm;
      };
      default = mame-tgm-wrapped;
    };
    checks.${system} = self.packages.${system}.mame-tgm.tests;
  };
}
