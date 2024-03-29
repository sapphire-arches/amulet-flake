{ buildPythonPackage
, lib
, fetchPypi
, cython_3
, numpy
, versioneer_518
, setuptools
}:

buildPythonPackage rec {
  pname = "amulet-nbt";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SUTCUN5y8B4kd3HrkA++Zz/ugqWk4lpJ4Ehh6fN4KY8=";
  };

  pyproject = true;

  nativeBuildInputs = [
    cython_3
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    versioneer_518
  ];

  patches = [
    # ./fix-amulet-nbt-build.patch
  ];
}

