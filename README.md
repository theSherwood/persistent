# persistent

Implements persistent vec, map, set, and multiset. Compiles to native code or webassembly. Vaguely inspired by Clojure's built-ins.

**Disclaimer**: This was written using the Nimskull compiler, which has not reached a stable version and, as of the time of this writing, continues to see rapid changes. There are already several differences between the Nimskull and Nim compilers. As such, if you wish to use any of this code... good luck!

## Usage

```nim
let
  v1 = [0, 1, 2].to_vec
  v2 = v1.push(1)
  v3 = v1.push(1)
doAssert v2 == v3
doAssert v1 != v2
doAssert v1 != v3
```

Refer to the test suite for more.

## Scripts and commands

### Build Native

```sh
./run.sh -tu native
```

OR

```sh
wach -o "src/**" "./run.sh -tu native"
```

### Test Native

```sh
./run.sh -tur native
```

OR

```sh
wach ./run.sh -tur native
```

### Test Wasm in Node

```sh
./run.sh -tur node32
```

OR

```sh
wach -o "src/**" "./run.sh -tur node32"
```

### Test Wasm in Browser

Compile wasm:

```sh
wach -o "src/**" "./run.sh -tu browser32"
```

Start the server:

```sh
dev start
```

Go to http://localhost:3000/

OR

```sh
./run.sh -tur browser32
```

### Benchmark

```sh
./run.sh -bur
```

## State

Note that the types to use are the `ref`s: `VecRef`, `MapRef`, `SetRef`, and `MultisetRef`, not the value types. This is because this implementation was originally intended to support a dynamic type system. So having a `ref` that I could add pointer tags to cuts out one pointer dereference when attempting to access the value.

The vecs are trees with a main branching factor of 32. They do not take the typical approach to persistent vectors described [here](https://dmiller.github.io/clojure-clr-next/general/2023/02/12/PersistentVector-part-2.html). As such, they are not tightly packed and they lack the tail optimization, but in exchange, insertions and deletions and pushing to the front are all fairly fast.

The maps are hash tries. The sets and multisets are built on the maps.

All the collections maintain hashes for fast equality comparisons. 

### TODO

- [ ] transients
- [ ] auto-balance vec trees
- [ ] replace hash tries with HAMT
- [ ] performance tuning
- [ ] add Rope-like persistent strings
