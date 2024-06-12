{ buildPythonPackage
, fetchPypi
, lib
  # dependencies
, amulet-leveldb
, amulet-nbt
, cython
, mutf8
, numpy
, platformdirs
, portalocker
, pymctranslate
, setuptools
, versioneer_518
, python-lz4
}:

buildPythonPackage rec {
  pname = "amulet-core";
  version = "1.9.22";

  src = fetchPypi {
    inherit version;
    pname = "amulet_core";
    sha256 = "sha256-JGvMuweuY/obvXBTb1a8H2EEDEOPrMZaygXm8kd0uR8=";
  };

  pyproject = true;

  nativeBuildInputs = [
    cython
    setuptools
    versioneer_518
  ];

  dependencies = [
    amulet-leveldb
    amulet-nbt
    mutf8
    numpy
    platformdirs
    python-lz4
    portalocker
    pymctranslate
    versioneer_518
  ];

  patches = [
    ./loosen-platformdirs.patch
  ];

  # doCheck = false;

  pythonImportCheck = [ "amulet" ];

  meta = with lib; {
    description = "A Python 3 library to read and write data from Minecraft's various save formats.";
    homepage = "https://github.com/Amulet-Team/Amulet-Core";
  };
}
