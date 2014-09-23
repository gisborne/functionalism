/**
 * User: gisborne
 * Date: 9/17/14
 * Time: 14:00
 */
require! './db'
require! './functionalism'
require! hstore: 'node-postgres-hstore'

define_fn = functionalism.define_fn
getFn = functionalism.getFn

define_fn '78854229-BE57-48D8-BCDE-EED574560AFA', {name: 'create'}, (model, rel, req, res, next) ->
  q = req.query
  vals = {id: q.id, name: model}
  delete q.id
  delete q._method

  vals['fields'] = hstore.stringify q
  db.quickInsertOne 'predicates', vals, ->
    res.redirect 'new'

export put_handler = (req, res, next) ->
  url = req.path
  url_parts = url.split '/'

  model = url_parts[1]
  db.get_relation model, (rel) ->
    res.send "Relation not found" unless rel

    f = getFn 'create'
    if f
      f model, rel, req, res, next
    else
      throw new Error 'Action not defined'
