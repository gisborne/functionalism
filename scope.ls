/**
 * User: gisborne
 * Date: 9/23/14
 * Time: 0:09
 */
require! _: 'prelude-ls'

export scope = ->
  @fns = {}

  @getFn = (name) ->
    return @fns[name].fn if @fns[name]
    void

  @getFnMeta = (f) ->
    @fn_meta[f]

  @defineFn = (id, options, fn) ->
    @fns      ||= {}
    @fn_meta  ||= {}

    name = options.name || id
    @fns[id] = @fns[name] =
      fn: fn
      id: id
      name: name

    @fn_meta[fn] =
      name: name
      id:   id

  @call = (name) ->
    args = Array.prototype.slice.call(arguments, 1)
    f = this.getFn name
    f.apply args
  this
