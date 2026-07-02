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
    in
    {
      devShell = pkgs.mkShell {
        NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libs;
      };
    }
  );
}
