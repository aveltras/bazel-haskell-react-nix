let
  githubTarball = owner: repo: rev:
    builtins.fetchTarball {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    };

in args@{ overlays ? [ ], commit ? "48d63e924a2666baf37f4f14a18f19347fbd54a2", ... }:
import (githubTarball "NixOS" "nixpkgs" commit) (args // { overlays = [
    # make desired GHC version the default package set for haskell
    (self: super: {
      # to see the versions of the packages currently in use
      # visit https://raw.githubusercontent.com/NixOS/nixpkgs/${NIXPKGS_COMMIT_HERE}/pkgs/development/haskell-modules/hackage-packages.nix
      haskellPackages = super.haskell.packages.ghc921.override {
        overrides = hself: hsuper: {};
      };

      ghcid = self.haskell.lib.justStaticExecutables self.haskellPackages.ghcid;
      hlint = self.haskell.lib.justStaticExecutables self.haskellPackages.hlint;
      ormolu = self.haskell.lib.justStaticExecutables self.haskellPackages.ormolu;

      ghc = super.haskellPackages.ghcWithPackages (p: with p; [
        aeson
      ]);
    })
  ] ++ overlays; })
