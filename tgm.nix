{ stdenvNoCC
, lib
, fetchurl
, replaceVars
, runtimeShell
, makeDesktopItem
, copyDesktopItems
, mame-tgm
}:
{
  tgm = (mame-tgm.override {
    gameName = "tgm";
    extraArgs = [ "-rec" "tgm1.input" "tgmj" ];
    desktopItemExtraAttrs = {
      desktopName = "Tetris The Grandmaster";
      name = "TGM";
      comment = "The first TGM game";
    };
    icon = fetchurl {
      url = "https://tetris.wiki/images/5/57/Arika_tgm1_title.jpg";
      hash = "sha256-BRIlnsf2Z7pvYwa7cVHQWmzW+iu+cZ9mPsJCjNLrXSY=";
    };
  });
  tap = (mame-tgm.override {
    gameName = "tap";
    extraArgs = [ "-rec" "tap.input" "tgm2p" ];
    desktopItemExtraAttrs = {
      desktopName = "Tetris The Absolute The Grand Master 2 PLUS";
      name = "TAP";
      comment = "The second TGM game";
    };
    icon = fetchurl {
      url = "https://tetris.wiki/images/5/51/Arika_tap_title.jpg";
      hash = "sha256-grTzXRrWnAic2hBhOT5MrxYiu9Y4hoIV3kOdbJLwY/c=";
    };
  });
}
