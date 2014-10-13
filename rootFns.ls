/**
 * User: gisborne
 * Date: 9/22/14
 * Time: 22:22
 */

require! './root'
require! _: 'prelude-ls'
require! './db'
require! './tableValue'
require! './formValue'
require! hstore: 'node-postgres-hstore'

scope = root.scope

types_map =
  'integer':  'number'
  'float':    'number step=any'
  'string':   'text'

getInputType = (t) ->
  types_map[t] || t

getColumnsFromRows = (r) ->
  if r.length > 0
    _.keys r[0].fields
  else
    []

getColumnsNames = (r) ->
    _.keys r

getFormVals = (model, fields, record) ->
  fs = []

  _.each ((k) ->
    unless k == 'id'
      if record
        fs ++= [{name: k, type: getInputType(fields[k]), value: record[k]}]
      else
        fs ++= [{name: k, type: getInputType(fields[k])}]),
    _.keys fields

  if record
    id = record.id

  formValue.create fs, id, model

explodeHash = (h) ->
  _.map ((k) ->
    {key: k, value: h[k]}),
    _.keys h

explodeRowValues = (rs) ->
  _.map ((r) ->
    _.values r.fields), rs


scope.defineFn 'E668EC95-0896-4AD1-8DF6-14ECB59CAB93', {name: 'create'}, (r) ->
  req = r.req
  model = r.model
  q = req.query

  vals = {id: q.id, name: model}
  delete q.id
  delete q._method

  vals['fields'] = hstore.stringify q
  db.quickInsertOne 'predicates', vals, ->
    scope.callFn 'after create' r


scope.defineFn 'D0B16C5A-40DC-40F0-9CE0-F7B692F4598D', {name: 'new'}, (r, handle) ->
  result = getFormVals(r.model_name, @fields)
  handle result


scope.defineFn '6FF4630A-523B-424F-B7FC-FA889C3F6FEF', {name: 'list'}, (r, handle) ->
  db.query r.model_name, r.req, (result) ->
    rs = result.rows
    rows = explodeRowValues rs
    cols = getColumnsFromRows rs
    result = tableValue.create cols, rows
    handle result


scope.defineFn '1F82437F-6776-42BD-940E-826F8CA0AB70', {name: 'after create'}, (r, _) ->
  r.res.redirect "new"