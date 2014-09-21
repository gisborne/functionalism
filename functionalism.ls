/**
 * User: gisborne
 * Date: 9/15/14
 * Time: 22:20
 */

fns = {}
fn_meta = {}

export getFn = (name) ->
  return fns[name].fn if fns[name]
  void

export getFnMeta = (f) ->
  fn_meta[f]

export define_fn = (id, options, fn) ->
  name = options.name || id
  fns[id] = fns[name] =
    fn: fn
    id: id
    name: name

  fn_meta[fn] =
    name: name
    id:   id
