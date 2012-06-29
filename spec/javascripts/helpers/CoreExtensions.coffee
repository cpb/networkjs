exports.calling = (i, a, v...) ->
    ->
      i[a](v...)

exports.except = (obj, except...) ->
  exclude = (key) ->
    except.some (x) ->
      x == key

  ret = {}
  for own key, value of obj
    unless exclude key
      ret[key] = value

  ret

