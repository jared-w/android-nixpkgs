{ stdenv
, lib
, mkGeneric
, makeWrapper
, runCommand
, srcOnly
, autoPatchelfHook
, alsaLib
, dbus
, expat
, fontconfig
, freetype
, gperftools
, libGL
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrender
, libXtst
, libcxx
, libpulseaudio
, libudev0-shim
, libunwind
, libuuid
, libxkbcommon
, ncurses5
, nss
, nspr
, sqlite
, qtbase
, qtimageformats
, qtsvg
, qtwayland
, qtwebengine
, vulkan-loader
, wrapQtAppsHook
, zlib
}:
let
  ldLibraryPath = lib.makeLibraryPath [
    libudev0-shim
    vulkan-loader
  ];

  systemLibs = [
    "libc++.so"
    "libc++.so.1"
    "libtcmalloc_minimal.so.4"
    "libunwind.so.8"
    "libunwind-x86_64.so.8"
    "qt/lib/libfreetype.so.6"
    "qt/lib/libsoftokn3.so"
    "qt/lib/libsqlite3.so"
    "qt/lib/libxkbcommon.so"
    "qt/lib/libxkbcommon.so.0"
    "qt/lib/libxkbcommon.so.0.0.0"
    "vulkan/libvulkan.so"
    "vulkan/libvulkan.so.1"
  ];

in
mkGeneric (lib.optionalAttrs stdenv.isLinux {
  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    alsaLib
    dbus.lib
    expat
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrender
    libXtst
    libcxx
    libpulseaudio
    libuuid
    libunwind
    libxkbcommon
    ncurses5
    nss
    nspr
    qtbase
    qtimageformats
    qtsvg
    qtwayland
    qtwebengine
    vulkan-loader
    zlib
  ];

  dontStrip = true;
  dontPatchELF = true;
  dontMoveLib64 = true;
  dontWrapQtApps = true;

  qtWrapperArgs = [
    ''--set ANDROID_QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase}/lib/qt-${qtbase.qtCompatVersion}/plugins/platforms''
  ];

  postUnpack = ''
    addAutoPatchelfSearchPath "$out/lib64"
  '';

  postFixup = ''
    wrapQtApp "$out/emulator"
  '';
} // {
  passthru.installSdk = ''
    for exe in emulator emulator-check mksdcard; do
      ln -s $pkgBase/$exe $out/bin/$exe
    done
  '';
})
