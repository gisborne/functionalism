/**
 * User: gisborne
 * Date: 9/24/14
 * Time: 0:17
 */

require! './typedValue'

fv = (fields, id, model) ->
  @fields = fields
  @id = id
  @model = model

  this

#So we can have a dynamic proto
export create = (fields, id, model) ->
  result = new fv fields, id, model
  result.__proto__ = typedValue.type 'form'
  result