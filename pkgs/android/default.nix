# TODO ndk

{ pkgs, lib, libsForQt5 }:

lib.makeScope pkgs.newScope (self: with self; rec {
  fetchandroid = callPackage ./fetch.nix { };
  mkGeneric = callPackage ./generic.nix { };
  mkBuildTools = callPackage ./build-tools.nix { };
  mkCmdlineTools = callPackage ./cmdline-tools.nix { };
  mkEmulator = libsForQt5.callPackage ./emulator.nix { inherit mkGeneric; };
  mkPlatformTools = callPackage ./platform-tools.nix { };
  mkPrebuilt = callPackage ./prebuilt.nix { };
  mkSrcOnly = callPackage ./src-only.nix { };
  mkTools = callPackage ./tools.nix { };
})
