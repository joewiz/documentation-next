xquery version "3.1";

(:~
 : Processing model configuration.
 :
 : Registers the compiled XDITA ODD transform.
 : The transform module is compiled by finish.xq on install.
 :)
module namespace pm-config = "http://www.tei-c.org/tei-simple/pm-config";

import module namespace pm-xdita-web = "http://www.tei-c.org/pm/models/xdita/web"
    at "../transform/xdita-web.xql";

declare variable $pm-config:xdita-web-transform := pm-xdita-web:transform#2;
