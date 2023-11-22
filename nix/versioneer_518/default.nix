{ buildPythonPackage
, lib
, fetchPypi
, numpy
, setuptools
}:

buildPythonPackage rec {
  pname = "versioneer-518";
  version = "0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oodgiZdBX0VAGEnRInpCu0G4Cm5KfaV3Zmb4XOb67EE=";
  };

  pyproject = true;

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
  ];
}


