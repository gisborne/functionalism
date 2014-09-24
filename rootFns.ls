/**
 * User: gisborne
 * Date: 9/22/14
 * Time: 22:22
 */

require! './root'
require! dust: 'dustjs-linkedin'
require! fs
require! _: 'prelude-ls'
require! path
require! './db'

scope = root.scope
resolve = path.resolve

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

  t = dust.compile f, name
  dust.loadSource t

getTemplate = (name) ->
  templates['name'] || getTemplateFromFile name

export renderTemplate = (name, vals, res) ->
  vals.template = name + '.dust'
  getTemplate name + '.dust'
  getTemplate 'layout.dust'
  dust.render 'layout.dust', vals, (err, out) ->
    throw new Error err if err
    res out

getFormVals = (model, fields, record) ->
  result = {fields: []}

  _.each ((k) ->
    unless k == 'id'
      if record
        result.fields ++= [{name: k, type: getInputType(fields[k]), value: record[k]}]
      else
        result.fields ++= [{name: k, type: getInputType(fields[k])}]),
    fields

  if record
    id = record.id

  result.id = id
  result.model = model

  result

getColumnsFromRows = (r) ->
  if r.length > 0
    _.keys r[0].fields
  else
    []

getColumnsNames = (r) ->
    _.keys r

keyValue = (chunk, context, bodies) ->
  items = context.current()

  for key in items
    ctx = {"key" : key, "value" : items[key]};
    chunk = chunk.render(bodies.block, context.push(ctx));

  chunk

scope.defineFn 'D0B16C5A-40DC-40F0-9CE0-F7B692F4598D', {name: 'new'}, (model, fields, req, res, next) ->
  fields = getColumnsNames fields
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

scope.defineFn '6FF4630A-523B-424F-B7FC-FA889C3F6FEF', {name: 'list'}, (model, fields, req, res, next) ->
  db.query model, req, (r) ->
    rs = r.rows
    rows = explodeRowValues rs
    cols = getColumnsFromRows rs
    context = {columns: cols, rows: rows}
    renderTemplate 'relation_table', context, (result) ->
      res.send result