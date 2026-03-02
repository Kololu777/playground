let
  f = {a, b} @ x: {
    sum = a + b;
    whole = x;
  };
in
  f
  # { sum = 3; whole = { a = 1; b = 2; }; }


