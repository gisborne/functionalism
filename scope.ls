/**
 * User: gisborne
 * Date: 9/23/14
 * Time: 0:09
 */
require! _: 'prelude-ls'
require! './convertor'

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

  @callFn = (name) ->
    args = Array.prototype.slice.call(arguments, 1)
    f = this.getFn name
    f.apply this, args

  @handle = (r) ->
    url = r.url
    meth = r.method
    res = r.res

    if meth.toLowerCase() == 'put'
      method_name = 'create'
    else #GET
      if url.length > 0 && url[0].toLowerCase() == 'new'
        method_name = 'new'
      else
        method_name = 'list'

    f = this.getFn method_name
    if f
      f.call this, r, (result) ->
        convertor.toType result, 'html', res
    else
      throw new Error 'Action not defined'

  this
