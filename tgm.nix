{ stdenvNoCC
, lib
, fetchurl
, replaceVars
, runtimeShell
, makeDesktopItem
, copyDesktopItems
, mame-tgm-wrapped
}:
{
  tgm = (mame-tgm-wrapped.override {
    gameName = "tgm";
    extraArgs = [ "-rec" "tgm1.input" "tgmj" ];
    desktopItemExtraAttrs = {
      name = "Tetris The Grandmaster";
      desktopName = "TGM";
      comment = "The first TGM game";
    };
    icon = fetchurl {
      url = "https://tetris.wiki/images/5/57/Arika_tgm1_title.jpg";
      hash = "sha256-BRIlnsf2Z7pvYwa7cVHQWmzW+iu+cZ9mPsJCjNLrXSY=";
    };
  });
  tap = (mame-tgm-wrapped.override {
    gameName = "tap";
    extraArgs = [ "-rec" "tap.input" "tgm2p" ];
    desktopItemExtraAttrs = {
      name = "Tetris The Grandmaster";
      desktopName = "TAP";
      comment = "The second TGM game";
    };
    icon = fetchurl {
      url = "https://tetris.wiki/images/5/51/Arika_tap_title.jpg";
      hash = "sha256-grTzXRrWnAic2hBhOT5MrxYiu9Y4hoIV3kOdbJLwY/c=";
    };
  });
}
