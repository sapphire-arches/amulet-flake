{ buildPythonPackage
, amulet-nbt
, cython_3
, fetchPypi
, lib
, numpy
, portalocker
, pymctranslate
, setuptools
}:

buildPythonPackage rec {
  pname = "amulet-core";
  version = "1.9.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-n2fes4PdXVny1tUh++mRww8lqZW2xcqWOgYCxGBVSMI=";
  };

  pyproject = true;

  nativeBuildInputs = [
    cython_3
    setuptools
  ];

  propagatedBuildInputs = [
    amulet-nbt
    numpy
    portalocker
    pymctranslate
  ];

  doCheck = false;

  meta = with lib; {
    description = "A Python 3 library to read and write data from Minecraft's various save formats.";
    homepage = "https://github.com/Amulet-Team/Amulet-Core";
  };
}
