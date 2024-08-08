# import std/[math, algorithm, strutils, strformat, sequtils, tables]
# import ../src/[values]
# import nimprof
import ./src/nim/[common]
import ./src/nim/parazoa/arr as para_arr
import ./src/nim/parazoa/map as para_map
import ./src/nim/nim_persistent_vector/arr as pers_arr
import ./src/nim/vec as vec
import ./src/nim/map as map

const RUN_PARAZOA    = true
const RUN_PERSVECTOR = true
const RUN_VEC        = true
const RUN_MAP        = true
const RUN_SANITY     = true

const RUN_MAPS       = true
const RUN_ARRS       = true

proc sanity_check(tr: TaskResult, sz, n: int) =
  var s = 0.0
  let Start = get_time()
  for i in 0..<n:
    s += i.float64
    if tr.runs.len > 1000000: echo s
    if tr.runs.len > 10000000: echo s
  tr.add(get_time() - Start)

proc output_results() =
  write_row("\"key\",\"sys\",\"desc\",\"runs\",\"minimum\",\"maximum\",\"mean\",\"median\"")
  for tr in csv_rows:
    tr.to_row.write_row

const VEC        = "vec"
const MAP        = "map"
const PARAZOA    = "parazoa"
const PERSVECTOR = "persvector"
const IMPERATIVE = "imperative"

proc run_benchmarks() =
  warmup()
  if RUN_SANITY:
    bench("sanity_check", "--", sanity_check, 0, 5000000)
    bench("sanity_check", "--", sanity_check, 0, 50000)
    bench("sanity_check", "--", sanity_check, 0, 500)

  # value benchmarks
  block:
    for it in [10, 100, 1000]:
      if RUN_MAPS:
        if RUN_PARAZOA:
          bench("map_create", PARAZOA, parazoa_map_create, 0, it)
        if RUN_MAP:
          bench("map_create", MAP, pmap_create, 0, it)

      if RUN_ARRS:
        if RUN_VEC:
          bench("arr_create", VEC, pvec_arr_create, 0, it)
        if RUN_PERSVECTOR:
          bench("arr_create", PERSVECTOR, persvector_arr_create, 0, it)
        if RUN_PARAZOA:
          bench("arr_create", PARAZOA, parazoa_arr_create, 0, it)

      for sz in [1, 10, 100, 1000]:
        if it < 100 and sz < 100: continue
        if it > 100 and sz >= 100: continue
        if it >= 100 and sz > 100: continue
        # echo "it: ", it, " sz: ", sz

        if RUN_MAPS:
          if RUN_MAP:
            bench("map_add_entry", MAP, pmap_add_entry, sz, it)
            bench("map_add_entry_multiple", MAP, pmap_add_entry_multiple, sz, it)
            bench("map_overwrite_entry", MAP, pmap_overwrite_entry, sz, it)
            bench("map_del_entry", MAP, pmap_del_entry, sz, it)
            bench("map_merge", MAP, pmap_merge, sz, it)
            bench("map_has_key_true", MAP, pmap_has_key_true, sz, it)
            bench("map_has_key_false", MAP, pmap_has_key_false, sz, it)
            bench("map_get_existing", MAP, pmap_get_existing, sz, it)
            bench("map_get_non_existing", MAP, pmap_get_non_existing, sz, it)
            bench("map_iter_keys", MAP, pmap_iter_keys, sz, it)
            bench("map_iter_values", MAP, pmap_iter_values, sz, it)
            bench("map_iter_entries", MAP, pmap_iter_entries, sz, it)
            bench("map_equal_true", MAP, pmap_equal_true, sz, it)
            bench("map_equal_false", MAP, pmap_equal_false, sz, it)

          if RUN_PARAZOA:
            bench("map_add_entry", PARAZOA, parazoa_map_add_entry, sz, it)
            bench("map_add_entry_multiple", PARAZOA, parazoa_map_add_entry_multiple, sz, it)
            bench("map_overwrite_entry", PARAZOA, parazoa_map_overwrite_entry, sz, it)
            bench("map_del_entry", PARAZOA, parazoa_map_del_entry, sz, it)
            bench("map_merge", PARAZOA, parazoa_map_merge, sz, it)
            bench("map_has_key_true", PARAZOA, parazoa_map_has_key_true, sz, it)
            bench("map_has_key_false", PARAZOA, parazoa_map_has_key_false, sz, it)
            bench("map_get_existing", PARAZOA, parazoa_map_get_existing, sz, it)
            bench("map_get_non_existing", PARAZOA, parazoa_map_get_non_existing, sz, it)
            bench("map_iter_keys", PARAZOA, parazoa_map_iter_keys, sz, it)
            bench("map_iter_values", PARAZOA, parazoa_map_iter_values, sz, it)
            bench("map_iter_entries", PARAZOA, parazoa_map_iter_entries, sz, it)
            bench("map_equal_true", PARAZOA, parazoa_map_equal_true, sz, it)
            bench("map_equal_false", PARAZOA, parazoa_map_equal_false, sz, it)

        if RUN_ARRS:
          if RUN_VEC:
            bench("arr_push", VEC, pvec_arr_push, sz, it)
            bench("arr_pop", VEC, pvec_arr_pop, sz, it)
            bench("arr_get_existing", VEC, pvec_arr_get_existing, sz, it)
            bench("arr_get_non_existing", VEC, pvec_arr_get_non_existing, sz, it)
            bench("arr_set", VEC, pvec_arr_set, sz, it)
            bench("arr_iter", VEC, pvec_arr_iter, sz, it)
            bench("arr_equal_true", VEC, pvec_arr_equal_true, sz, it)
            bench("arr_equal_false", VEC, pvec_arr_equal_false, sz, it)

          if RUN_PERSVECTOR:
            bench("arr_push", PERSVECTOR, persvector_arr_push, sz, it)
            bench("arr_pop", PERSVECTOR, persvector_arr_pop, sz, it)
            bench("arr_get_existing", PERSVECTOR, persvector_arr_get_existing, sz, it)
            # bench("arr_get_non_existing", PERSVECTOR, persvector_arr_get_non_existing, sz, it)
            bench("arr_set", PERSVECTOR, persvector_arr_set, sz, it)
            bench("arr_iter", PERSVECTOR, persvector_arr_iter, sz, it)
            # bench("arr_equal_true", PERSVECTOR, persvector_arr_equal_true, sz, it)
            # bench("arr_equal_false", PERSVECTOR, persvector_arr_equal_false, sz, it)

          if RUN_PARAZOA:
            bench("arr_push", PARAZOA, parazoa_arr_push, sz, it)
            bench("arr_pop", PARAZOA, parazoa_arr_pop, sz, it)
            bench("arr_get_existing", PARAZOA, parazoa_arr_get_existing, sz, it)
            bench("arr_get_non_existing", PARAZOA, parazoa_arr_get_non_existing, sz, it)
            bench("arr_set", PARAZOA, parazoa_arr_set, sz, it)
            bench("arr_iter", PARAZOA, parazoa_arr_iter, sz, it)
            bench("arr_equal_true", PARAZOA, parazoa_arr_equal_true, sz, it)
            bench("arr_equal_false", PARAZOA, parazoa_arr_equal_false, sz, it)

run_benchmarks()
output_results()
