{ stdenvNoCC
, lib
, replaceVars
, runtimeShell
, makeDesktopItem
, copyDesktopItems
, mame-tgm

, rom ? null
, extraArgs ? []
, desktopItemExtraAttrs ? {}
}:

stdenvNoCC.mkDerivation (finalAttrs: let
  script = replaceVars ./mame-tgm-wrapper.bash {
    inherit runtimeShell;
    mameTgm = lib.getExe mame-tgm;
    extraArgs = extraArgs;
  };

  nameSuffix = if rom != null then lib.getName rom else "tgm";
  mainProgram = "mame-" + nameSuffix;

  desktopItem = makeDesktopItem {
    name = "MAME Tetris The Grandmaster";
    desktopName = "MAME TGM";
    exec = "${mainProgram}";
    categories = [ "Game" ];
  } // desktopItemExtraAttrs;
in {
  pname = "mame-${nameSuffix}-wrapper";
  inherit (mame-tgm) version;

  nativeBuildInputs = [ copyDesktopItems ];
  desktopItems = [ desktopItem ];

  dontUnpack = true;
  buildPhase = ''
    runHook preBuild

    mkdir -p "$out/bin"
    cp "${script}" "$out/bin/${mainProgram}"
    chmod +x "$out/bin/${mainProgram}"

    runHook postBuild
  '';

  meta = {
    inherit mainProgram;
    inherit (mame-tgm) maintainers;
  };
})
