{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

# https://github.com/manuels/wireguard-p2p
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wireguard-p2p";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "manuels";
    repo = "wireguard-p2p";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9yM84MmBt8REGOjzcKhQ2oYZEASmuAFMUlPObcCnI04=";
  };

  # FIXME: Wait for https://github.com/manuels/wireguard-p2p/issues/15
  cargoHash = "sha256-GK6ytH/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = " A tool for setting up WireGuard connections from peer to peer";
    mainProgram = "wireguard-p2p";
    homepage = "https://github.com/manuels/wireguard-p2p";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      Dietr1ch
    ];
    platforms = lib.platforms.linux;
  };
})
