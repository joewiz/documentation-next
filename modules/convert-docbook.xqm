xquery version "3.1";

(:~
 : DocBook 5.0 to XDITA converter.
 :
 : Converts DocBook article elements to XDITA (Lightweight DITA) topic
 : elements using a recursive typeswitch. Semantics are simplified:
 : DocBook-specific inline elements (tag, guimenuitem, parameter, etc.)
 : all become plain <ph>.
 :
 : External programlisting references (xlink:href) are resolved and
 : inlined before conversion.
 :)
module namespace convert = "http://exist-db.org/apps/docs/convert";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";
import module namespace docs = "http://exist-db.org/apps/docs/docs"
    at "docs.xqm";

declare namespace db = "http://docbook.org/ns/docbook";
declare namespace xlink = "http://www.w3.org/1999/xlink";

(:~
 : Convert a DocBook article to an XDITA topic.
 :
 : @param $article the DocBook article element
 : @param $slug the article slug (used as topic @id)
 : @return XDITA topic element
 :)
declare function convert:docbook-to-xdita(
    $article as element(db:article),
    $slug as xs:string
) as element(topic) {
    (: Step 1: resolve external listings so all code is inline :)
    let $resolved := docs:resolve-listings-public($article)
    return
        <topic id="{ $slug }">
            { convert:info($resolved/db:info) }
            <body>
                {
                    (: Top-level paras before first section :)
                    for $node in $resolved/(db:para | db:note | db:warning |
                        db:important | db:itemizedlist | db:orderedlist |
                        db:variablelist | db:programlisting | db:informalfigure |
                        db:figure | db:table | db:informaltable | db:example)
                    return convert:node($node),
                    (: Sections :)
                    for $sect in $resolved/(db:sect1 | db:section)
                    return convert:section($sect)
                }
            </body>
        </topic>
};

(:~
 : Convert DocBook info metadata to XDITA title + prolog.
 :)
declare %private function convert:info($info as element(db:info)?) {
    if (exists($info)) then (
        <title>{ $info/db:title/string() }</title>,
        if ($info/db:date or $info/db:keywordset/db:keyword) then
            <prolog>
                {
                    if ($info/db:date) then
                        <data name="date" value="{ $info/db:date/string() }"/>
                    else (),
                    for $kw in $info/db:keywordset/db:keyword
                    return
                        <data name="keyword" value="{ $kw/string() }"/>
                }
            </prolog>
        else ()
    )
    else ()
};

(:~
 : Convert a DocBook section (sect1/sect2/sect3/section) to XDITA section.
 :)
declare %private function convert:section($sect as element()) as element(section) {
    <section>
        {
            if ($sect/@xml:id) then
                attribute id { $sect/@xml:id/string() }
            else ()
        }
        {
            if ($sect/db:title) then
                <title>{ convert:inline-content($sect/db:title) }</title>
            else ()
        }
        {
            for $node in $sect/node()
            return
                typeswitch ($node)
                    case element(db:title) return ()  (: already handled :)
                    case element(db:sect1) return convert:section($node)
                    case element(db:sect2) return convert:section($node)
                    case element(db:sect3) return convert:section($node)
                    case element(db:section) return convert:section($node)
                    default return convert:node($node)
        }
    </section>
};

(:~
 : Convert a single DocBook node to its XDITA equivalent.
 : Main dispatch function for block-level content.
 :)
declare %private function convert:node($node as node()) as node()* {
    typeswitch ($node)
        (: Block elements :)
        case element(db:para) return
            <p>{ convert:inline-content($node) }</p>
        case element(db:programlisting) return
            <pre>
                {
                    if ($node/@language) then
                        attribute outputclass { $node/@language/string() }
                    else ()
                }
                { $node/text() }
            </pre>
        case element(db:synopsis) return
            <pre>
                {
                    if ($node/@language) then
                        attribute outputclass { $node/@language/string() }
                    else ()
                }
                { $node/text() }
            </pre>

        (: Lists :)
        case element(db:itemizedlist) return
            <ul>
                { for $li in $node/db:listitem return convert:listitem($li) }
            </ul>
        case element(db:orderedlist) return
            <ol>
                { for $li in $node/db:listitem return convert:listitem($li) }
            </ol>
        case element(db:procedure) return
            <ol>
                { for $step in $node/db:step return convert:listitem($step) }
            </ol>

        (: Definition lists :)
        case element(db:variablelist) return
            <dl>
                {
                    if ($node/db:title) then
                        <p><b>{ $node/db:title/string() }</b></p>
                    else (),
                    for $entry in $node/db:varlistentry
                    return convert:varlistentry($entry)
                }
            </dl>

        (: Admonitions :)
        case element(db:note) return
            <note type="note">
                { for $child in $node/(db:para | db:title | db:itemizedlist | db:orderedlist | db:programlisting)
                  return convert:node($child) }
            </note>
        case element(db:warning) return
            <note type="warning">
                { for $child in $node/(db:para | db:title | db:itemizedlist | db:orderedlist | db:programlisting)
                  return convert:node($child) }
            </note>
        case element(db:important) return
            <note type="notice">
                { for $child in $node/(db:para | db:title | db:itemizedlist | db:orderedlist | db:programlisting)
                  return convert:node($child) }
            </note>
        case element(db:caution) return
            <note type="caution">
                { for $child in $node/(db:para | db:title | db:itemizedlist | db:orderedlist | db:programlisting)
                  return convert:node($child) }
            </note>

        (: Figures and images :)
        case element(db:figure) return
            <fig>
                {
                    if ($node/db:title | $node/db:info/db:title) then
                        <title>{ ($node/db:title, $node/db:info/db:title)[1]/string() }</title>
                    else ()
                }
                { convert:mediaobject($node//db:imagedata) }
            </fig>
        case element(db:informalfigure) return
            <fig>
                { convert:mediaobject($node//db:imagedata) }
            </fig>
        case element(db:mediaobject) return
            convert:mediaobject($node//db:imagedata)
        case element(db:inlinemediaobject) return
            convert:mediaobject($node//db:imagedata)

        (: Tables (CALS → simpletable) :)
        case element(db:table) return
            convert:table($node)
        case element(db:informaltable) return
            convert:table($node)

        (: Example :)
        case element(db:example) return
            <section>
                {
                    if ($node/@xml:id) then
                        attribute id { $node/@xml:id/string() }
                    else ()
                }
                {
                    if ($node/db:title | $node/db:info/db:title) then
                        <title>{ ($node/db:title, $node/db:info/db:title)[1]/string() }</title>
                    else ()
                }
                {
                    for $child in $node/*[not(self::db:title | self::db:info)]
                    return convert:node($child)
                }
            </section>

        (: Sections nested inside blocks :)
        case element(db:sect1) return convert:section($node)
        case element(db:sect2) return convert:section($node)
        case element(db:sect3) return convert:section($node)
        case element(db:section) return convert:section($node)

        (: Skip non-content elements :)
        case element(db:info) return ()
        case element(db:title) return ()

        (: Text and other :)
        case text() return $node
        case comment() return ()
        case processing-instruction() return ()

        (: Unknown elements — try to process children :)
        default return
            for $child in $node/node()
            return convert:node($child)
};

(:~
 : Convert inline content (children of a para, title, etc.)
 :)
declare %private function convert:inline-content($parent as element()) as node()* {
    for $node in $parent/node()
    return convert:inline($node)
};

(:~
 : Convert inline-level DocBook elements to XDITA.
 :)
declare %private function convert:inline($node as node()) as node()* {
    typeswitch ($node)
        case text() return $node

        (: Emphasis :)
        case element(db:emphasis) return
            if ($node/@role = "bold") then
                <b>{ convert:inline-content($node) }</b>
            else
                <i>{ convert:inline-content($node) }</i>

        (: Simplified inline elements — all become <ph> :)
        case element(db:code) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:literal) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:tag) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:parameter) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:guimenuitem) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:guibutton) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:guilabel) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:command) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:filename) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:function) return
            <ph>{ convert:inline-content($node) }</ph>
        case element(db:productname) return
            <ph>{ convert:inline-content($node) }</ph>

        (: Links :)
        case element(db:link) return
            if ($node/@xlink:href) then
                <xref href="{ $node/@xlink:href/string() }" scope="external">
                    { convert:inline-content($node) }
                </xref>
            else if ($node/@linkend) then
                <xref href="#{ $node/@linkend/string() }" scope="local">
                    { convert:inline-content($node) }
                </xref>
            else
                <xref href="{ $node/string() }" scope="external">
                    { convert:inline-content($node) }
                </xref>
        case element(db:xref) return
            if ($node/@linkend) then
                <xref href="#{ $node/@linkend/string() }" scope="local"/>
            else if ($node/@xlink:href) then
                <xref href="{ $node/@xlink:href/string() }" scope="external"/>
            else ()

        (: Inline code in programlisting context :)
        case element(db:programlisting) return
            <ph>{ $node/text() }</ph>

        (: Footnotes :)
        case element(db:footnote) return
            (: Flatten footnote content inline :)
            for $child in $node/db:para/node()
            return convert:inline($child)

        (: Fallback — process children :)
        default return
            for $child in $node/node()
            return convert:inline($child)
};

(:~
 : Convert a listitem or step to XDITA li.
 :)
declare %private function convert:listitem($item as element()) as element(li) {
    <li>
        {
            for $child in $item/node()
            return convert:node($child)
        }
    </li>
};

(:~
 : Convert a varlistentry to XDITA dlentry.
 :)
declare %private function convert:varlistentry($entry as element(db:varlistentry)) as element(dlentry) {
    <dlentry>
        <dt>{ convert:inline-content($entry/db:term) }</dt>
        {
            for $li in $entry/db:listitem
            return
                <dd>
                    { for $child in $li/node() return convert:node($child) }
                </dd>
        }
    </dlentry>
};

(:~
 : Convert imagedata to XDITA image element.
 :)
declare %private function convert:mediaobject($imagedata as element(db:imagedata)*) as element(image)* {
    for $img in $imagedata
    return
        <image href="{ $img/@fileref/string() }">
            {
                if ($img/@width) then
                    attribute width { $img/@width/string() }
                else ()
            }
        </image>
};

(:~
 : Convert a CALS table to XDITA simpletable.
 :)
declare %private function convert:table($table as element()) as node()* {
    if ($table/db:title | $table/db:info/db:title) then
        <p><b>{ ($table/db:title, $table/db:info/db:title)[1]/string() }</b></p>
    else (),
    let $tgroup := ($table/db:tgroup, $table)[1]
    return
        <simpletable>
            {
                for $row in $tgroup/db:thead/db:row
                return
                    <sthead>
                        { for $cell in $row/db:entry
                          return <stentry>{ convert:inline-content($cell) }</stentry> }
                    </sthead>
            }
            {
                for $row in $tgroup/db:tbody/db:row
                return
                    <strow>
                        { for $cell in $row/db:entry
                          return <stentry>{ convert:inline-content($cell) }</stentry> }
                    </strow>
            }
            {
                (: Tables without explicit thead/tbody :)
                for $row in $tgroup/db:row
                return
                    <strow>
                        { for $cell in $row/db:entry
                          return <stentry>{ convert:inline-content($cell) }</stentry> }
                    </strow>
            }
        </simpletable>
};
