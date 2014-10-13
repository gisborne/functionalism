/**
 * User: gisborne
 * Date: 9/25/14
 * Time: 14:24

 Wraps up all the req, res etc that we get from Express or we keep handing around
 */

export request = ->
  @clone = ->
    result = {
      req: @req
      res: @res
      scope: @scope
      method: @method
      url:    @url
    }
    result.__proto__ = @__proto__

    result

  @call_next = ->
    @next(@req, @res)

export create = (obj) ->
  obj.__proto__ = request.prototype
  obj