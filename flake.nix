{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    inherit
      (import nixpkgs {system = "x86_64-linux";})
      callPackage
      gnome
      gnugrep
      man
      lib
      writeShellApplication
      ;
    testedManPage = "${gnugrep}/share/man/man1/egrep.1.gz";
    typicalLinuxManExe = "/usr/bin/man";
  in {
    apps = {
      x86_64-linux = let
        grepTest = manExe: {
          type = "app";
          program = "${lib.getExe (writeShellApplication {
            name = "${manExe}-grep-test";
            text = "${manExe} ${testedManPage} | ${lib.getExe gnugrep} -- --help";
          })}";
        };
        geditRender = manExe: {
          type = "app";
          program = "${lib.getExe (writeShellApplication {
            name = "${manExe}-gedit-render";
            text = "${manExe} ${testedManPage} | ${lib.getExe gnome.gedit} -";
          })}";
        };
        nixpkgsMan = lib.getExe man;
        typicalLinuxMan = "/usr/bin/man";
      in {
        nixpkgsManGrepTest = grepTest nixpkgsMan;
        nonNixManGrepTest = grepTest typicalLinuxManExe;

        nixpkgsManGeditRender = geditRender nixpkgsMan;
        nonNixManGeditRender = geditRender typicalLinuxManExe;
      };
    };
  };
}
