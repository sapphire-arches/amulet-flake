{ buildPythonPackage
, fetchPypi
, lib
# dependencies
, cython_3
, numpy
, setuptools
, zlib
}:

buildPythonPackage rec {
  pname = "amulet-leveldb";
  version = "1.0.0b5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-n8J8RgcoaQsZ0PkZpQQ5QigzlyikpwHedYU37uf9Kqs=";
  };

  pyproject = true;

  buildInputs = [
    zlib
  ];

  nativeBuildInputs = [
    cython_3
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
  ];
}
