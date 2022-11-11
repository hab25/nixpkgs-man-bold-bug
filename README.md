This repository reproduces a bug in the `man` package of a recent version of `nixpkgs`; see `./flake.lock` for the exact revision. 

The bug is that `man` from nixpkgs is attempting to output bold characters even when its output is a tty, which it should not be doing. This prevents its output from being searched with e.g. `grep`.


---
#### Reproduce the bug

`nix --extra-experimental-features "nix-command flakes" run .\#nixpkgsManGrepTest `

And see that the `grep` test outputs nothing and returns an error, as grep cannot find the `--help` flag inside the tested manpage.

`nix --extra-experimental-features "nix-command flakes" run .\#nixpkgsManGeditRender`

And see that `gedit` renders hardly-readable output, as the bold characters contaminate it.  

---

#### Compare with (likely) correct behaviour
On a non-NixOS system that has a `/usr/bin/man` (e.g. Ubuntu), run

`nix --extra-experimental-features "nix-command flakes" run .\#nonNixManGrepTest`

And see that the `grep` test (likely) correctly outputs the line containing `--help` flag inside the tested manpage

`nix --extra-experimental-features "nix-command flakes" run  .\#nonNixManGeditRender`

And see that `gedit` (likely) renders completely readable output.
