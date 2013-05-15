# executive

An easy to use wrapper around `child_process.spawn`, useful for Cakefiles and the like. Pipes `stdout`, `stderr` and `stdin` so you don't have to. Think of it as a streaming `child_process.exec` with a few extra goodies.

## Usage

```javascript
var exec = require('executive');

exec('ls', function(err, out, code) {
    // Done, no need to echo out as it's piped to stdout by default.
});
```

Arguments are parsed out properly for you:
```javascript
var exec = require('executive');

exec('ls -AGF Foo\\ bar', function(err, out, code) {
    // Note the escaped folder name.
});
```

Also supports simple serial execution of commands:
```javascript
var exec = require('executive');

exec(['ls', 'ls', 'ls'], function(err, out, code) {
    // All three ls commands are called in order.
});
```

## Options
A few different options are supported, you can pass them to exec, or in the case
of `quiet` and `interactive` use the useful wrappers in lieu of exec.

### quiet `(default false)`
If you'd prefer not to pipe `stdin`, `stdout`, `stderr` set `quiet` to `false`:
```javascript
exec(['ls', 'ls'], {quiet: true}, function(err, out, code) {
    // Not a peep is heard, and both ls commands will be executed.
});
```

...or slightly more succint:

```javascript
exec.quiet(['ls', 'ls'], function(err, out, code) {
    // both commands executed
});
```

### safe `(default true)`
In the case of a failure, no additional commands will be executed:
```javascript
exec(['ls', 'aaaaa', 'ls'], function(err, out, code) {
    // Only the first command succeeds, the last is never called.
});
```

...but you can also choose to ignore errors by setting `safe` to `false`:

```javascript
exec(['ls', 'aaaaaa', 'ls'], {safe: false}, function(err, out, code) {
    // Both commands execute despite aaaaaa not being a valid executable.
});
```

### interactive `(default false)`
If you need to interact with a program (your favorite text editor for instance)
or watch the output of a long running process (`tail -f`), or just don't care
about checking `stderr` and `stdout`, you can set `interactive` to `true`,
either by using the wrapper or passing it as an option to exec:
```javascript
exec.interactive('vim', function(err, out, code) {
    // Edit your commit message or whatnot
});
```

## Extra credit
The spawned child process object is accessible when you exec a single program
(not available when using the simple serial execution wrapper):

```javascript
var exec = require('executive');

child = exec.quiet('ls');
child.stdout.on('data', function(data) {
    // Do your own thing
});
```

It's especially nice to use in a Cakefile:
```coffeescript
exec = require 'executive'

task 'package', 'Package project', ->
  exec '''
    mkdir -p dist
    rm -rf dist/*
    cp manifest.json dist
    cp -rf assets dist
    cp -rf lib dist
    cp -rf views dist
    zip -r package.zip dist
    rm -rf dist
  '''.split '\n'
```
