
/**
 * User: gisborne
 * Date: 9/23/14
 * Time: 22:49
 */
require! './typedValue'

tv = (fields, rows) ->
  @fields = fields
  @rows = rows

  this

#So we can have a dynamic proto
export create = (fields, rows) ->
  result = new tv fields, rows
  result.__proto__ = typedValue.type 'table'
  result