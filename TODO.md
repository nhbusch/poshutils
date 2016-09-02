ToDo
----

* Fix keyboard shortcuts for building in current dir to PsReadLine, F7

Issues
------

We had to patch Invoke-MsBuild which incorrectly constructed registry entry,
see https://github.com/deadlydog/Invoke-MsBuild/pull/6.
Update module when fix has been incorporated.

PsColor adds extra lines when running a command with output. Might have to do with
wrapping Out-Default. It is annoying, so default import is disabled for now.
