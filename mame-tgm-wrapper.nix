{ stdenvNoCC
, lib
, replaceVars
, runtimeShell
, imagemagick
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
    extraArgs = extraArgs;
  };

  mainProgram = if gameName == null then "tgm-mame" else gameName;

  desktopItem = makeDesktopItem ({
    desktopName = "MAME Tetris The Grandmaster";
    name = "MAME TGM";
    exec = mainProgram;
    icon = mainProgram;
    categories = [ "Game" ];
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
