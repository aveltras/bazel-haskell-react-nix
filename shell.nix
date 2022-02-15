let
  pkgs = import ./. { };

  easy-hls =
    pkgs.callPackage
      (builtins.fetchTarball { url = "https://github.com/blackheaven/easy-hls-nix/archive/c0fa0e71b6f2d9923d4b965ee29a48d80b859309.tar.gz"; })
      { ghcVersions = [ pkgs.haskellPackages.ghc.version ];
      };
  
in pkgs.mkShell {
  packages = with pkgs; [
    bazel_4
    easy-hls
    ghc
    ghcid
    hlint
    nodejs-17_x
    openjdk11
    ormolu
  ];
}
