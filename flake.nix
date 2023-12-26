{
  description = "A Nix-flake-based Nix development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      pname = "cht.sh";
      my-buildInputs = with pkgs; [ curl tmux fzf ];
      script = (pkgs.writeScriptBin pname (builtins.readFile ./cht.sh)).overrideAttrs(old : {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in rec
    {
    defaultPackage = packages.chtsh;
    packages.chtsh = pkgs.symlinkJoin {
      name = pname;
      paths = [script] ++ my-buildInputs;
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/${pname} --prefix PATH : $out/bin";
    };
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          shellcheck
          nodePackages.bash-language-server
          nil
        ];
      };
    });
}
