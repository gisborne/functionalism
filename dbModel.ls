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

  type_wrap_function_names =
    integer:  'INTEGER'
    float:    'FLOAT'

  @getFieldForQuery = (name) ->
    type = @fields[name]
    raise new Error 'unrecognized field name in getFieldForQuery' unless type
    f = type_wrap_function_names[name.toLowerCase()]
    if f
      "name::#f"
    else
      name


  this.defineFn 'C51484BA-E62D-49C6-9227-4ED4C0156FF5', {name: 'sort'}, (r) ->

  this

