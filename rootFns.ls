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



scope.defineFn 'D0B16C5A-40DC-40F0-9CE0-F7B692F4598D', {name: 'new'}, (model, fields, req, res, next, handle) ->
  result = getFormVals(model, fields)
  handle result


scope.defineFn '6FF4630A-523B-424F-B7FC-FA889C3F6FEF', {name: 'list'}, (model, fields, req, res, next, handle) ->
  db.query model, req, (r) ->
    rs = r.rows
    rows = explodeRowValues rs
    cols = getColumnsFromRows rs
    result = tableValue.create cols, rows
    handle result