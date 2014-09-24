/**
 * User: gisborne
 * Date: 9/24/14
 * Time: 0:05
 */

require! dust: 'dustjs-linkedin'
require! path
require! fs

resolve = path.resolve

templates = {}

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

toForm = (value, res) ->
  renderTemplate 'relation_form', value, (result) ->
    res.send result

toTable = (value, res) ->
  renderTemplate 'relation_table', value, (result) ->
    res.send result

#TODO: Make this a published function?
export toType = (value, target_type, res) ->
  #STUB: We just convert everything to HTML
  if value.type == 'table'
    toTable value, res
  else if value.type == 'form'
    toForm value, res