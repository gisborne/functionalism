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

pgTypes = pg.types

constring = "postgres://gisborne:@localhost/functional"

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
      raise new Error e if e

      handle r

rowForInsert = (vals) ->
  _.values(vals) * ',' + "\n"

export quick_insert = (name, vals, succeed) ->

  with_connection (err, client) ->
    raise new Error e if e

    stream = client.copyFrom "COPY #name (#{ks * ', '} FROM STDIN WITH CSV"
    stream.on 'error', ->
      raise new Error e

    _.each ((h) ->
        stream.write rowForInsert(h)),
      vals
    stream.end

export get_relation = (name, handle) ->
  params_query "SELECT fields FROM relations WHERE name = $1", [name], handle



/* required for hstore module */
quick_query "SELECT oid FROM pg_type WHERE typname = 'hstore'", (r) ->
  export hstore_oid = r.rows[0].oid
  pgTypes.setTypeParser hstore_oid, hstore.parse