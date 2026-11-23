{ lib
, rustPlatform
, fetchFromGitHub
, nodejs
, npmHooks
, pkg-config
, openssl
, ...
}:

rustPlatform.buildRustPackage rec {
  pname = "alephgrid";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "alephgrid";
    repo = "alephgrid";
    rev = "v${version}";
    hash = "sha256-jn2OvDtbv/jix2CLxKPRrdG3HB8+29KcFD3E/Dqd204=";
  };

  cargoHash = "sha256-olEp0A8lo9A5RaTvf2MnatVvInQ4+ZynOB6TCHm3iOk=";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Build the web frontend first, which the Rust binary embeds.
  preBuild = ''
    pushd web
    npm install
    npm run build
    popd
  '';

  # Skip tests that may require network or external services.
  # doCheck = false;

  meta = with lib; {
    description = "Open-source, self-hosted spreadsheet for billions of rows with SQL and Excel-style formulas";
    homepage = "https://github.com/alephgrid/alephgrid";
    license = lib.licenses.asl20;

    platforms = platforms.unix;
    maintainers = with lib.maintainers; [
      Dietr1ch
    ];
  };
}
