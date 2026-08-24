{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  obs-studio,
  qtbase,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "obs-aitum-multistream";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "Aitum";
    repo = "obs-aitum-multistream";
    tag = version;
    hash = "sha256-naf5PubNWK65izmFo638gf4NPRy0uiOyWPj410LNPlY=";
  };

  passthru.updateScript = nix-update-script { };

  # Fix FTBFS with Qt >= 6.8
  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_qt(COMPONENTS Widgets Core)' 'find_package(Qt6 REQUIRED COMPONENTS Core Widgets)'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    curl
    obs-studio
    qtbase
  ];
  dontWrapQtApps = true;

  cmakeFlags = [
    # Prevent deprecation warnings from failing the build
    (lib.cmakeOptionType "string" "CMAKE_CXX_FLAGS" "-Wno-error=deprecated-declarations")
  ];

  meta = {
    description = "Plugin to stream everywhere from a single instance of OBS";
    homepage = "https://github.com/Aitum/obs-aitum-multistream";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
}
