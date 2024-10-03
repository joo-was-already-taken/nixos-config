{
  startDelimiter ? "{{",
  endDelimiter ? "}}",
}:

with builtins; rec {
  compile = str: []; # TODO

  render = template: values:
    let
      templateElemToStr = elem:
        let
          toStr = {}: "";
        in
          if isAttrs elem then toStr elem
          else if isString elem then elem
          else throw "Expected list of strings and attribute sets, got ${typeOf elem}";
    in
      concatStringSep "" (map templateElemToStr template);

  fromString = values: str: render (compile str) values;

  fromFile = values: fileName: fromString values (readFile fileName);
}
