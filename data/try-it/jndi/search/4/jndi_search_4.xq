(: Search a JNDI directory by LDAP filter :)
"jndi:search($directory-context as xs:integer, $dn as xs:string, $filter as xs:string, $scope as xs:string) as node()? — searches using RFC 2254 filter syntax (e.g., '(&amp;(cn=John)(sn=Doe))'); scope: 'object', 'onelevel', or 'subtree'"
