{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "plantuml-server";
  version = "1.2025.2";

  src = fetchurl {
    url = "https://github.com/plantuml/plantuml-server/releases/download/v${version}/plantuml-v${version}.war";
    hash = "sha256-Qwaqt2Tlc5ruo0nnhepBXHOHVPqwcIP2Ec6GL+EyGTU=";
  };

  dontUnpack = true;

  postInstall = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/plantuml.war"
  '';

  passthru.tests = {
    inherit (nixosTests) plantuml-server;
  };

  meta = with lib; {
    description = "Web application to generate UML diagrams on-the-fly";
    homepage = "https://plantuml.com/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [
      truh
      anthonyroussel
    ];
  };
}
