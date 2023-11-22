{ buildPythonPackage
, amulet-nbt
, amulet-leveldb
, cython_3
, fetchPypi
, lib
, numpy
, platformdirs
, portalocker
, pymctranslate
, setuptools
, mutf8
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
    amulet-leveldb
    numpy
    platformdirs
    portalocker
    pymctranslate
    mutf8
  ];

  # doCheck = false;

  pythonImportCheck = [ "amulet" ];

  meta = with lib; {
    description = "A Python 3 library to read and write data from Minecraft's various save formats.";
    homepage = "https://github.com/Amulet-Team/Amulet-Core";
  };
}
