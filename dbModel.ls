/**
 * User: gisborne
 * Date: 9/21/14
 * Time: 15:37
 */

require! './root'

getFn = root.getFn

export dbModel = (name, fields) ->
  @fields = fields
  @name = name

  @handle = (meth, _, url, req, res, next) ->
    if meth == 'PUT'
      method_name = 'create'
    else #GET
      if url.length > 0 && url[0] == 'new'
        method_name = 'new'
      else
        method_name = 'list'

    f = this.getFn method_name
    if f
      f @name, @fields, req, res, next
    else
      throw new Error 'Action not defined'

  @__proto__ = root.scope

  this

