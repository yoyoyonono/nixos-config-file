self: super:

let
  qemuAppleSiliconOverride = import ./qemu-applesilicon.nix;
in {
  qemu-applesilicon = qemuAppleSiliconOverride {
    inherit (super) qemu fetchFromGitHub meson lzfse lib nettle;
  };
}
