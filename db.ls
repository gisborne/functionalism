/**
 * user: gisborne
 * date: 9/13/14
 * time: 16:11
 */
require! pg
require! hstore: 'node-postgres-hstore'
require! Q: q
require! path
pgTypes = pg.types

constring = "postgres://gisborne:@localhost/functional"

export params_query = (q, params, handle) ->
  deferred = Q.defer()

  pg.connect constring, (err, client, done) ->
    client.query q, params, (e, r) ->
      console.error e; return if e
      done
      handle r
      deferred.resolve()
  deferred.promise


export quick_query = (q, handle) ->
  deferred = Q.defer()

  pg.connect constring, (err, client, done) ->
    client.query q, [], (e, r) ->
      console.error e if e
      done
      handle r
      deferred.resolve()
  deferred.promise

export get_relation = (name, handle) ->
  params_query "SELECT fields FROM relations WHERE name = $1", [name], handle



quick_query "SELECT oid FROM pg_type WHERE typname = 'hstore'", (r) ->
  export hstore_oid = r.rows[0].oid
  pgTypes.setTypeParser hstore_oid, hstore.parse