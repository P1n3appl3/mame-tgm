{
  inputs = { utils.url = "github:numtide/flake-utils"; };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      libs = with pkgs; [
          stdenv.cc.cc.lib
          SDL
          libX11
          libXinerama
          gtk2
          pango
          atk
          cairo
          gdk-pixbuf
          glib
          fontconfig
          freetype
          gnome2.GConf
          libGL
      ];
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
    in
    {
      devShell = pkgs.mkShell {
        NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libs;
      };
    }
  );
}
