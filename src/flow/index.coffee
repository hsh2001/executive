import {isArray, isObject, isString} from 'es-is'

import exec     from '../exec'
import execSync from '../execSync'
import parallel from './parallel'
import serial   from './serial'


# Execute array of commands, with serial execution by default
array = (exec, arr, opts, cb) ->
  if opts.parallel
    parallel exec, arr, opts, cb
  else
    serial exec, arr, opts, cb


# Execute string representing commands
string = (exec, str, opts, cb) ->
  arr = (str.split '\n').filter (c) -> c != ''
  array exec, arr, opts, cb


# Execute object of commands
object = (exec, obj, opts, cb) ->
  ret  = Object.assign {}, obj
  cmds = ([k,v] for k,v of obj)

  # Synchronous command execution, neither parallel nor serial matter
  if opts.sync
    for [k, cmd] in cmds
      serial exec, cmds, opts, (err, stdout, stderr, status) ->


# Execute commands using either serial or parallel control flow and return
# result to cb
export default (cmds, opts, cb) ->
  # Use sync exec if necessary
  exec_ = if opts.sync then execSync else exec

  if isString cmds
    return string exec_, cmds, opts, cb
  if isObject cmds
    return object exec_, cmds, opts, cb
  if isArray cmds
    return array exec_, cmds, opts, cb

  throw new Error "Unable to return results for cmds = #{JSON.stringify cmds}"
