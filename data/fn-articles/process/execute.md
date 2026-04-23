---
query: |
  let $options := <option>
    <workingDir>/tmp</workingDir>
  </option>
  return process:execute(("ls", "-l"), $options)
---

The eXist-db `process` module enables admin users to execute system commands on the machine where eXist is running.
[`process:execute`]({docs}/functions/process/execute) receives the command as a sequence of strings, plus optional `<option>` XML.

**Note:** For security reasons, only users in the `dba` group may call this function.

## Working Directory

```xquery
let $options := <option>
  <workingDir>/etc</workingDir>
</option>
return process:execute(("ls", "-l"), $options)
```

Lists the files in `/etc` in long format. The default working directory (if not specified) is the eXist-db home directory.

## Environment Variables

To pass environment variables to the process:

```xquery
let $options := <option>
  <environment>
    <env name="DATA" value="/path/to/data"/>
  </environment>
</option>
return process:execute(("sh", "-c", "echo $DATA"), $options)
```

## Wildcards / globbing

Shell wildcard expansion requires calling `sh -c`:

```xquery
let $options := <option>
  <workingDir>/tmp</workingDir>
</option>
return process:execute(("sh", "-c", "ls *.xml"), $options)
```

**Note:** `process:execute(("ls", "*.xml"), $options)` returns an error — wildcards must be expanded by the shell.

## stdin

```xquery
let $options := <option>
  <stdin>
    <line>One</line>
    <line>Two</line>
  </stdin>
</option>
return process:execute(("wc", "-l"), $options)
```

`wc -l` counts lines of the stdin input and returns `2`.
