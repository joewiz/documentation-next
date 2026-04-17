(: Translate simple query language expressions to XPath :)
(: Single terms become '. &= term'; quotes become near(); and/or combine terms :)
<results>
  <single-term>
    {simpleql:parse-simpleql("exist")}
  </single-term>
  <and-query>
    {simpleql:parse-simpleql("exist AND xquery")}
  </and-query>
  <or-query>
    {simpleql:parse-simpleql("exist OR basex")}
  </or-query>
  <phrase>
    {simpleql:parse-simpleql('"native XML database"')}
  </phrase>
  <combined>
    {simpleql:parse-simpleql('xquery AND "full text" OR xpath')}
  </combined>
</results>
