# nim-curry: Easy currying library for Nim
You can curry functions by simply putting `{.curry.}`.

## Example
```nim
import nim_curry

proc f(foo, bar = 100; baz: float): float {.curry.} =
  return (foo + bar).float * baz

echo f(10)(20)(2.5) # => 75.0
echo f()(2)(0.1)    # => 10.2
echo f()()(0.0)     # =>  0.0

```
