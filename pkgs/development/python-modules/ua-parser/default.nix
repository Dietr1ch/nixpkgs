{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-re2,
  pyyaml,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  ua-parser-builtins,
  ua-parser-rs,
}:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-python";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-l8EBQq5Hqw/Vx4zvWy2QQ1m7mrAiqYNK2x3yUmJj8Xw=";
  };

  build-system = [
    pyyaml
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ua-parser-builtins
  ];

  optional-dependencies = {
    yaml = [ pyyaml ];
    re2 = [ google-re2 ];
    regex = [ ua-parser-rs ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ua_parser" ];

  meta = {
    changelog = "https://github.com/ua-parser/uap-python/releases/tag/${version}";
    description = "Python implementation of the UA Parser";
    homepage = "https://github.com/ua-parser/uap-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
