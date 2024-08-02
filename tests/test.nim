from ../src/test_utils import failures
from ./vec import nil
from ./map import nil
from ./set import nil
from ./multiset import nil

# Run tests
vec.main()
map.main()
set.main()
multiset.main()

when defined(wasm):
  if failures > 0: raise newException(AssertionDefect, "Something failed.")
