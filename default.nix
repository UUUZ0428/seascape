# https://github.com/input-output-hk/haskell.nix/blob/79c2c631c3938093e7a7704bee3c7e094ee198e1/test/ghc-options/cabal.nix
let hn = import (builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz);
in
  { pkgs ? import (builtins.fetchTarball "https://github.com/input-output-hk/nixpkgs/archive/3d623a406cec9052ae0a16a79ce3ce9de11236bb.tar.gz") {
      config = hn.config;
      overlays = hn.overlays ++ [ (self: super: {
        icuuc = self.icu;
        icui18n = self.icu;
        icudata = self.icu;
      }) ];
    }
  , haskellCompiler ? "ghc865"
  }:
  pkgs.haskell-nix.cabalProject {
    src = pkgs.haskell-nix.haskellLib.cleanGit { src = ./.; };
    ghc = pkgs.buildPackages.haskell-nix.compiler.${haskellCompiler};
    modules = [ {
      packages.seascape.enableExecutableProfiling = true;
      enableLibraryProfiling = true;
    } ];
  }
