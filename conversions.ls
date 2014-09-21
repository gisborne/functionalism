/**
 * User: gisborne
 * Date: 9/15/14
 * Time: 22:36
 */

require! dust: 'dustjs-linkedin'
require! './functionalism'
require! fs
require! _: 'prelude-ls'
require! path
require! uuid: 'node-uuid'
require! './db'

define_fn = functionalism.define_fn
resolve = path.resolve
keys = _.keys

types_map =
  'integer' => 'number'
  'float'   => 'number step=any'
  'string'  => 'text'

templates = {}

getInputType = (t) ->
  types_map[t] || t

getTemplateFromFile = (name) ->
  p = resolve __dirname, '../templates/' + name
  if fs.existsSync p
    f = fs.readFileSync p, {encoding: 'utf8'}
  else
    p = resolve __dirname, '../templates/' + name + '.dust'
    if fs.existsSync p
      f = fs.readFileSync p, {encoding: 'utf8'}
    else
      throw new Error 'Template not found' unless f

  templates[name] = dust.compileFn f

export renderTemplate = (name, vals, res) ->
  t = (templates[name] || getTemplateFromFile name)
  t vals, (err, out) ->
    raise new Error err if err
    res out

getFormVals = (model, fields, record) ->
  result = {fields: []}

  _.each ((k) ->
    unless k == 'id'
      if record
        result.fields ++= [{name: k, type: getInputType(fields[k]), value: record[k]}]
      else
        result.fields ++= [{name: k, type: getInputType(fields[k])}]),
    _.Obj.keys(fields)

  if record
    id = record.id
  else
    id = uuid.v4()

  result.id = id
  result.model = model

  result

getColumnsFromRows = (r) ->
  if r.rowCount > 0
    _.keys r.rows[0].fields
  else
    []

getColumnsNamesFromRows = (r) ->
  if r.rowCount > 0
    r.rows[0].fields
  else
    []

keyValue = (chunk, context, bodies) ->
  items = context.current()

  for key in items
    ctx = {"key" : key, "value" : items[key]};
    chunk = chunk.render(bodies.block, context.push(ctx));

  chunk

/*
Convert a relation to a form
*/

define_fn 'D0B16C5A-40DC-40F0-9CE0-F7B692F4598D', {name: 'new'}, (model, rel, req, res, next) ->
  fields = getColumnsNamesFromRows rel
  context = getFormVals model, fields

  renderTemplate 'relation_form', context, (result) ->
    res.send result

explodeHash = (h) ->
  _.map ((k) ->
    {key: k, value: h[k]}),
    _.keys h

explodeRowValues = (rs) ->
  _.map ((r) ->
    _.values r.fields), rs

define_fn '6FF4630A-523B-424F-B7FC-FA889C3F6FEF', {name: 'list'}, (model, rel, req, res, next) ->
  db.query model, req, (r) ->
    rows = explodeRowValues r.rows
    cols = getColumnsFromRows rel
    context = {columns: cols, rows: rows}
    renderTemplate 'relation_table', context, (result) ->
      res.send result

