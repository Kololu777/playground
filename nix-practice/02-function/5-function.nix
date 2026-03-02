let
  f =
    {
      name,
      age ? 20,
    }:
    "${name} is ${toString age}";
in
f { name = "ko"; }
