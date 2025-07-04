{
  lib,
  fetchFromGitHub,
  stdenv,
  zlib,
  ninja,
  meson,
  pkg-config,
  cmake,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "libspng";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "randy408";
    repo = "libspng";
    rev = "v${version}";
    sha256 = "sha256-BiRuPQEKVJYYgfUsglIuxrBoJBFiQ0ygQmAFrVvCz4Q=";
  };

  # disable two tests broken after libpng update
  # https://github.com/randy408/libspng/issues/276
  postPatch = ''
    cat tests/images/meson.build | grep -v "'ch1n3p04'" | grep -v "'ch2n3p08'" > tests/images/meson.build-patched
    mv tests/images/meson.build-patched tests/images/meson.build
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  mesonBuildType = "release";

  mesonFlags = [
    # this is required to enable testing
    # https://github.com/randy408/libspng/blob/bc383951e9a6e04dbc0766f6737e873e0eedb40b/tests/README.md#testing
    "-Ddev_build=true"
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeCheckInputs = [
    cmake
  ];

  buildInputs = [
    zlib
    libpng
  ];

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
  ];

  meta = with lib; {
    description = "Simple, modern libpng alternative";
    homepage = "https://libspng.org/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ humancalico ];
    platforms = platforms.all;
  };
}
