(: List all installed repository packages :)
for $pkg in repo:list()
order by $pkg
return $pkg
