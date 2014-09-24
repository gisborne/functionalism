/**
 * user: gisborne
 * date: 9/13/14
 * time: 16:11
 */
require! pg
require! hstore: 'node-postgres-hstore'
require! Q: q
require! path
require! _: 'prelude-ls'
require! stringify: 'csv-stringify'
require! dbM: './dbModel'

dbModel = dbM.dbModel

pgTypes = pg.types

constring = "postgres://gisborne:@localhost/functional"

#memoizing
model_scopes = {}

with_connection = (handler) ->
  deferred = Q.defer()

  pg.connect constring, (err, client, done) ->
    handler err, client

    done
    deferred.resolve()
  deferred.promise

export params_query = (q, params, handle) ->
  with_connection (err, client) ->
    client.query q, params, (e, r) ->
      raise new Error e if e

      handle r

export quick_query = (q, handle) ->
  with_connection (err, client) ->
    client.query q, (e, r) ->
      throw new Error e if e

      handle r

export getRelation = (name, handle) ->
  params_query "SELECT fields FROM relations WHERE name = $1", [name], handle

export quickInsert = (name, vals, succeed) ->
  with_connection (e, client) ->
    throw new Error e if e
    ks = _.keys vals
    stream = client.copyFrom "COPY predicates (id, fields) FROM STDIN WITH CSV"
    stream.on 'error', (error) ->
      throw new Error error

    stringify _.values(vals), (err, output) ->
      raise new Error if e

      stream.write output

    stream.end
    succeed()

export quickInsertOne = (name, vals, succeed) ->
  with_connection (e, client) ->
    ks = _.keys vals

    insert_placeholders = (_.map ((x) -> "$#{x}"), [1 to ks.length]) * ','
    sql = "INSERT INTO #name(#{ks * ','}) values(#insert_placeholders)"
    client.query sql, _.values(vals), (e, r) ->
      throw new Error e if e
      succeed()

export query = (model, req, handler) ->
  quick_query "SELECT * FROM predicates WHERE name = '#model'", handler


#Create a scope object for a model declared in our database
#We use model_scopes to memoize
export getModelScope = (name) ->
  handle: (method, parent_scope, url, req, res, next) ->
    if (model = model_scopes[name])
      model.handle method, parent_scope, url, req, res, next
    else
      getRelation name, (r) ->
        if r.rows.length > 0
          model = new dbModel name, r.rows[0].fields
          model_scopes[name] = model
          model.handle method, parent_scope, url, req, res, next
        else
          next method, parent_scope, url, req, res, next

/* required for hstore module */
quick_query "SELECT oid FROM pg_type WHERE typname = 'hstore'", (r) ->
  export hstore_oid = r.rows[0].oid
  pgTypes.setTypeParser hstore_oid, hstore.parse