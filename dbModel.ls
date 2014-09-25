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

  this.defineFn 'C51484BA-E62D-49C6-9227-4ED4C0156FF5', {name: 'sort'}, (model, fields, req, res, next, handle) ->

  this

