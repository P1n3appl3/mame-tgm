{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, SDL
, gtk2
, gnome2
, libGL
, libGLU
, testers
, runCommand
}:

stdenv.mkDerivation (finalAttrs: let
  mainProgram = "mametgm" + (
    lib.optionalString stdenv.hostPlatform.is64bit "64"
  );
in {
  pname = "shmupmametgm";
  version = "2.1";
  src = fetchFromGitHub {
    owner = "MaryHal";
    repo = "shmupmametgm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y5crVgbLkuSPp0D0FEtJWAc44cEuFwh9XJE0F2MmRM8=";
  };

  outputs = ["out" "doc" "web"];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL gtk2 gnome2.GConf libGL libGLU ];

  makeFlags = [
    "SUBTARGET=tgm"
    "NOWERROR=1"
  ] ++ lib.optional stdenv.hostPlatform.is64bit "PTR64=1";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv ${mainProgram} $out/bin

    mkdir -p $web
    mv fumen_encode* $web/

    mkdir -p $doc
    mv docs/* $doc

    runHook postInstall
  '';

  passthru = let package = finalAttrs.finalPackage; in {
    tests.smoke = testers.testVersion {
      inherit package;
      command = "${finalAttrs.meta.mainProgram} -h";
      version = "v0.137"; # MAME version
    };

    defaultConfig = runCommand (package.name + "-default-config") {} ''
      ${lib.getExe package} -createconfig
      mv mame.ini $out
    '';
  };

  meta = {
    # description = "";
    # longDescription = '''';
    # homepage = "";
    # changelog
    # license
    maintainers = with lib.maintainers; [
      rrbutani
      { name = "Julia Ryan"; github = "P1n3appl3"; githubId = 9326885; }
    ];
    inherit mainProgram;
    # platforms
  };
})
