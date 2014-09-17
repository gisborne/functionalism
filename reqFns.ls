/**
 * User: gisborne
 * Date: 9/16/14
 * Time: 14:49
 */

require! './conversions'
require! './functionalism'
require! './db'

getFn = functionalism.getFn

export get_path = (parts, req, res, next) ->
  model = parts[1]
  action = parts[2]
  db.get_relation model, (rel) ->
    res.send "Relation not found" unless rel
    f = getFn action
    if f
      f model, rel, req, res, next
    else
      raise new Error 'Action not defined'
