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

  @__proto__ = root.scope

  this

