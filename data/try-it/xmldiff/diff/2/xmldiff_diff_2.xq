(: Get detailed diff report between two XML nodes :)
let $v1 :=
  <config>
    <setting name="timeout">30</setting>
    <setting name="retries">3</setting>
  </config>
let $v2 :=
  <config>
    <setting name="timeout">60</setting>
    <setting name="retries">3</setting>
  </config>
let $same := xmldiff:diff($v1, $v1)
let $different := xmldiff:diff($v1, $v2)
return
  <results>
    <identical>
      <equivalent>{$same?equivalent}</equivalent>
    </identical>
    <changed>
      <equivalent>{$different?equivalent}</equivalent>
      <message>{$different?message}</message>
    </changed>
  </results>
