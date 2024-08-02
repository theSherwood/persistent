# import std/[math, algorithm, strutils, strformat, sequtils, tables]
import std/[sequtils]
import ../../../../src/vec
import ../common

proc setup_seq_of_pvec_arrs*(sz, it, offset: int): seq[VecRef[int]] =
  var i_off, k: int
  var a: VecRef[int]
  for i in 0..<it:
    i_off = i + offset
    a = [i_off].to_vec
    for j in 1..<sz:
      k = i_off + (j * 17)
      a = a.add(k)
    result.add(a)
template setup_seq_of_pvec_arrs*(sz, it: int): seq[VecRef[int]] = setup_seq_of_pvec_arrs(sz, it, 0)

proc pvec_arr_create*(tr: TaskResult, sz, n: int) =
  var arrs: seq[VecRef[int]] = @[]
  let Start = get_time()
  for i in 0..<n:
    arrs.add([i].to_vec)
  tr.add(get_time() - Start)

proc pvec_arr_push*(tr: TaskResult, sz, n: int) =
  # setup
  var arrs = setup_seq_of_pvec_arrs(sz, n)
  # test
  let Start = get_time()
  for i in 0..<n:
    arrs[i] = arrs[i].push(i)
  tr.add(get_time() - Start)

proc pvec_arr_pop*(tr: TaskResult, sz, n: int) =
  # setup
  var arrs = setup_seq_of_pvec_arrs(sz, n)
  # test
  let Start = get_time()
  for i in 0..<n:
    arrs[i] = arrs[i].pop()[0]
  tr.add(get_time() - Start)

proc pvec_arr_get_existing*(tr: TaskResult, sz, n: int) =
  # setup
  var arrs = setup_seq_of_pvec_arrs(sz, n)
  var vals: seq[int] = @[]
  # test
  let Start = get_time()
  for i in 0..<n:
    vals.add(arrs[i].get((arrs[i].len.float64 / 2.0).int))
  tr.add(get_time() - Start)

proc pvec_arr_get_non_existing*(tr: TaskResult, sz, n: int) =
  # setup
  var arrs = setup_seq_of_pvec_arrs(sz, n)
  var vals: seq[int] = @[]
  # test
  let Start = get_time()
  for i in 0..<n:
    vals.add(arrs[i].getOrDefault(arrs[i].len * 2, 0))
  tr.add(get_time() - Start)

proc pvec_arr_set*(tr: TaskResult, sz, n: int) =
  # setup
  var arrs = setup_seq_of_pvec_arrs(sz, n)
  # test
  let Start = get_time()
  for i in 0..<n:
    arrs[i] = arrs[i].set((arrs[i].len.float64 / 2.0).int, -1)
  tr.add(get_time() - Start)

proc pvec_arr_iter*(tr: TaskResult, sz, n: int) =
  # setup
  var arrs = setup_seq_of_pvec_arrs(sz, n)
  var iters: seq[seq[int]] = @[]
  var vals: seq[int]
  # test
  let Start = get_time()
  for i in 0..<n:
    vals = @[]
    for v in arrs[i].items: vals.add(v)
    iters.add(vals)
  tr.add(get_time() - Start)

proc pvec_arr_equal_true*(tr: TaskResult, sz, n: int) =
  # setup
  var arrs = setup_seq_of_pvec_arrs(sz, n)
  var copies = setup_seq_of_pvec_arrs(sz, n)
  var bools: seq[bool]
  # test
  let Start = get_time()
  for i in 0..<n:
    bools.add(arrs[i] == copies[i])
  tr.add(get_time() - Start)
  doAssert bools.all(proc (b: bool): bool = b)

proc pvec_arr_equal_false*(tr: TaskResult, sz, n: int) =
  # setup
  var arrs = setup_seq_of_pvec_arrs(sz, n)
  var arrs2 = setup_seq_of_pvec_arrs(sz, n, 3)
  var bools: seq[bool]
  # test
  let Start = get_time()
  for i in 0..<n:
    bools.add(arrs[i] == arrs2[i])
  tr.add(get_time() - Start)
  doAssert bools.all(proc (b: bool): bool = b.not)
