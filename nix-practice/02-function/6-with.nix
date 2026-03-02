let
  f = with builtins; x: typeOf (typeOf x); # buitins.typeOfをかくひつようなし
in
f 10
