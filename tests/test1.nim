# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import curry
test "can curry":
  proc add(a, b: int): int {.curry.} =
    a + b
  check add(10)(27) == 37
test "default value":
  proc test(a, b: int; c: char = ','; d = " "): string {.curry.} =
    $a & $c & d & $b & $c & d & $(a + b)
  check test(12)(38)(':')("") == "12:38:50"
  check test(3)(12)()() == "3, 12, 15"
