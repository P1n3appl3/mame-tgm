{ stdenvNoCC
, lib
, replaceVars
, runtimeShell
, fetchurl
, imagemagick
, moreutils
, makeDesktopItem
, copyDesktopItems
, mame-tgm-unwrapped

, gameName ? null
, extraArgs ? []
, desktopItemExtraAttrs ? {}
, icon ? null
}:

stdenvNoCC.mkDerivation (finalAttrs: let
  script = replaceVars ./mame-tgm-wrapper.bash {
    inherit runtimeShell;
    mameTgm = lib.getExe mame-tgm-unwrapped;
    sponge = lib.getExe' moreutils "sponge";
    extraArgs = extraArgs;
  };

  mainProgram = if gameName == null then "tgm-mame" else gameName;

  desktopItem = makeDesktopItem ({
    desktopName = "MAME for Tetris The Grandmaster";
    name = "MAME TGM";
    exec = mainProgram;
    icon = mainProgram;
    categories = [ "Game" ];
    keywords = [ "tetris" "TGM" "emulator" "arika" "block" "stacking" ];
  } // desktopItemExtraAttrs);
in {
  pname = "mame-wrapper-${mainProgram}";
  inherit (mame-tgm-unwrapped) version;

  nativeBuildInputs = [ copyDesktopItems imagemagick ];
  desktopItems = [ desktopItem ];

  dontUnpack = true;
  buildPhase = ''
    runHook preBuild

    mkdir -p "$out/bin"
    cp "${script}" "$out/bin/${mainProgram}"
    chmod +x "$out/bin/${mainProgram}"

    runHook postBuild
  '';

  icon = if icon != null then icon else (fetchurl {
    url = "https://cdn2.steamgriddb.com/icon_thumb/f8548a8d98a27fe73f2558a90f989c5c.png";
    hash = "sha256-b/8ZIvY5cPSgWKbPWDVVGz/oAqNzOwghHgqzXxn251A=";
  });
  installPhase = lib.optionalString (icon != null) ''
    runHook preInstall

    dir="$out/share/icons/hicolor/256x256/apps"
    mkdir -p $dir
    magick ${icon} -resize '256x256!' $dir/${mainProgram}.png    

    runHook postInstall
  '';

  meta = {
    inherit mainProgram;
    inherit (mame-tgm-unwrapped) maintainers;
  };
})
