{ buildPythonPackage
, lib
, fetchPypi
, amulet-nbt
, cython
, numpy
, portalocker
, pymctranslate
}:

buildPythonPackage rec {
  pname = "amulet-core";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FtFgHWjfao3AnAmiZC8BAG679ak+y+LQXYwSHxUTAJc=";
  };

  nativeBuildInputs = [ cython ];

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
