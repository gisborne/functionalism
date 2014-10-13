/**
 * User: gisborne
 * Date: 9/21/14
 * Time: 13:57
 *
 * Root scope. Also may be used as prototype for other scopes
 */

require! method_override: 'method-override'
require! bodyParser: 'body-parser'
require! path
require! _: 'prelude-ls'

require! './db'
require! scp: './scope'
export scope = new scp.scope

require! './rootFns'
require! './request'

getMethod = (req) ->
  if (method = req.query['_method']) && method.match(/put/i)
    'put'
  else
    req.method

getScope = db.getModelScope


export rootHandle = (req, res, next) ->
  method = getMethod req

  url = req._parsedUrl.pathname #TODO find an official alternative
  url_parts = url.split '/' |> _.tail #We throw away the inevitable blank before the opening /
  handle method, url_parts, req, res, next

#GET '/' is probably the only case of this
defaultHandle = (r) ->
    r.res.send 'foo ' + r.req.url #ToDo What do we do with GET '/'?

#Polish request details up for standard handle call
handle = (method, url, req, res, next) ->
  next_scope_name = _.head url
  r = request.create(
    method: method
    req:    req
    res:    res
    next:   next
  )

  if next_scope_name !== ''
    r.url = _.tail url

    next_scope = getScope next_scope_name
    next_scope.handle r, -> #method, scope, rest_url, req, res,  -> #next line is the "next" handler
      throw new Error 'Unrecognized scope name: ' + next_scope_name
  else
    defaultHandle r #This is usually GET '/'