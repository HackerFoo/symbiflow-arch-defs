{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv rec {
  name = "sf-shell";
  targetPkgs = pkgs:
    with pkgs;
    let vtr = stdenv.mkDerivation rec {
          name = "vtr-${version}";
          version = "git";
          src = fetchGit {
            url = "https://github.com/SymbiFlow/vtr-verilog-to-routing.git";
            rev = "1cf4f1b9b2ef3e815f58a770cfad7f0aa209d423";
          };

          doCheck = false;

          buildInputs = [ bison flex cmake ];

          meta = with stdenv.lib; {
            description = "Provides open-source CAD tools for FPGA architecture and CAD research";
            homepage = https://github.com/SymbiFlow/vtr-verilog-to-routing/;
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
        icestorm = pkgs.icestorm.overrideAttrs (oldAttrs: rec {
          src = fetchGit {
            url = "https://github.com/cliffordwolf/icestorm.git";
            rev = "fa1c932452e8efe1dfcc6ff095e3f7130a7906b1"; # 20190311.0112-gfa1c932
          };
        });
        yosys = pkgs.yosys.overrideAttrs (oldAttrs: rec {
          src = fetchGit {
            url = "https://github.com/SymbiFlow/yosys.git";
            rev = "5706e90802fdf51a476e769790f6b5b526c57572"; # yosys-0.8
          };
        });
        textx = python37Packages.buildPythonPackage rec {
          pname = "textX";
          version="1.8.0";

          src = python37Packages.fetchPypi {
            inherit pname version;
            sha256 = "1vhc0774yszy3ql5v7isxr1n3bqh8qz5gb9ahx62b2qn197yi656";
          };

          doCheck = false;
          propagatedBuildInputs = [ python37Packages.arpeggio ];

          meta = with lib; {
            homepage = "https://github.com/textX/textX";
            license = licenses.mit;
            description = "Domain-Specific Languages and parsers in Python made easy";
          };
        };
        fasm = python37Packages.buildPythonPackage rec {
          name = "fasm";
          src = fetchGit {
            url = "https://github.com/SymbiFlow/fasm.git";
            rev = "ddc281a41662bff3efb4a66c5b22307e31e5df44"; # 20190207.1350-gddc281a
          };
          propagatedBuildInputs = [ textx ];
        };
    in [
      vtr
      python37
      git
      cmake
      gcc
      clang
      gnumake
      cmake
      conda
      yosys
      openocd
      libxml2
      libxslt
      git
      wget
      zlib
      binutils
      xxd
      verilog
      sqlite
      nodejs
      pkg-config
      libftdi
      fasm
      icestorm
      gtkwave
      flock
    ] ++ (with python37Packages;
    [
      pip
      virtualenv
      lxml
      progressbar2
      simplejson
      pyserial
      setuptools
      textx
      pytest
      intervaltree
      yapf
      numpy
      tox
    ]);
}).env
