{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "soia";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "FengZeng";
    repo = "soia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OKaBB287Rx+DyLFrSLva/gJzyJAFodoLw7RmBWxlimA=";
  };

  cargoHash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance cross-platform media player with HDR/Dolby Vision, WebDAV/DLNA/SMB streaming, dual subtitles, and browser remote control";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/FengZeng/soia";
    maintainers = with lib.maintainers; [ Dietr1ch ];
    mainProgram = "soia";
  };
})
