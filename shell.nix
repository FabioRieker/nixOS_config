{pkgs ? import <nixpkgs> {}}: 
pkgs.mkShell {
  buildInputs = with pkgs; [
    nil
    nixfmt-rfc-style
    nix-diff
    nix-tree
    nixops
    deploy-rs
    git
    gh
  ];

  shellHook = ''
    echo "NixOS Dev Shell"
    echo "Run: sudo nixos-rebuild switch --flake .#nixos"
  '';
}
