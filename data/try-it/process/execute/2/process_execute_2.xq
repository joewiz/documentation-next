(: Execute an external process and capture stdout, stderr, and exit code :)
(: Options can specify workingDir, environment variables, and stdin lines :)
try {
  process:execute(
    ("ls", "/exist/lib"),
    <options>
      <workingDir>/exist</workingDir>
    </options>
  )
} catch * {
  <execution>
    <exitCode>-1</exitCode>
    <error>process:execute — {$err:description}</error>
  </execution>
}
