{ buildPythonPackage
, lib
, fetchPypi
, amulet-nbt
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "PyMCTranslate";
  version = "1.2.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-APJRlAEuzjQoYt6NOSlOlUYiVdnQAZ1xAdlSH7pZ434=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    numpy
    amulet-nbt
  ];
}
