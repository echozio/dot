lib: r: g: b: a:
let
  s = builtins.toString;
  toUnsignedInt = n: lib.toInt (builtins.head (builtins.match "^([0-9]*).*$" (builtins.toString n)));
  toHex = n: builtins.head (builtins.match "^.*(.{2})$" "0${lib.toHexString (toUnsignedInt n)}");
  xr = toHex r;
  xg = toHex g;
  xb = toHex b;
  xa = toHex (a * 255);
in
{
  inherit
    r
    g
    b
    a
    xr
    xg
    xb
    xa
    ;
  rgba = "rgba(${s r},${s g},${s b},${s a})";
  rgbaHex = "rgba(${xr}${xg}${xb}${xa})";
  hex = "${xr}${xg}${xb}";
  hexRgba = "${xr}${xg}${xb}${xa}";
}
