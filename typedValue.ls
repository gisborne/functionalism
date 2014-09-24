/**
 * User: gisborne
 * Date: 9/23/14
 * Time: 22:43
 */

/*
A value with an attached type
 */

types = {}

export typedValue = (type) ->
  @type = type
  types[type] = this
  this

export type = (name) ->
  result = types[name] || new typedValue name
  result