{ buildPythonPackage
, lib
, fetchPypi
, amulet-nbt
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "PyMCTranslate";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BW77IMpQM5WbqdM8ZYqcGU6v5fLVF08mG5VwDmiKxUM=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    numpy
    amulet-nbt
  ];
}
