xquery version "3.1";

(:~
 : XQSuite tests for the documentation-next app.
 :
 : Tests article structure validation, TOC generation, function module
 : categorization, and search integration.
 :)
module namespace tests = "http://exist-db.org/apps/docs/tests";

import module namespace docs = "http://exist-db.org/apps/docs/docs"
    at "../../modules/docs.xqm";
import module namespace fundocs = "http://exist-db.org/apps/docs/fundocs"
    at "../../modules/fundocs.xqm";
import module namespace nav = "http://exist-db.org/apps/docs/nav"
    at "../../modules/nav.xqm";
import module namespace config = "http://exist-db.org/apps/docs/config"
    at "../../modules/config.xqm";

declare namespace test = "http://exist-db.org/xquery/xqsuite";
declare namespace db = "http://docbook.org/ns/docbook";
declare namespace xqdoc = "http://www.xqdoc.org/1.0";

(: ─── Test fixtures ─────────────────────────────────────────────────── :)

declare variable $tests:sample-article := document {
    <article xmlns="http://docbook.org/ns/docbook"
             xmlns:xlink="http://www.w3.org/1999/xlink" version="5.0">
        <info>
            <title>Test Article</title>
            <date>1Q26</date>
            <keywordset>
                <keyword>getting-started</keyword>
            </keywordset>
        </info>
        <para>Introductory paragraph.</para>
        <sect1 xml:id="first-section">
            <title>First Section</title>
            <para>Content of first section.</para>
            <sect2 xml:id="first-subsection">
                <title>First Subsection</title>
                <para>Content of first subsection.</para>
            </sect2>
        </sect1>
        <sect1 xml:id="second-section">
            <title>Second Section</title>
            <para>Content of second section.</para>
        </sect1>
    </article>
};

(: ─── Article structure tests ───────────────────────────────────────── :)

(:~ All DocBook sections should have an xml:id for anchoring :)
declare
    %test:name("All article sections have xml:id attributes")
    %test:assertEmpty
function tests:missing-section-ids() {
    for $section in collection($config:data-root || "/articles")
        //(db:sect1 | db:sect2 | db:sect3)
    where empty($section/@xml:id)
    return
        util:document-name($section) || ": missing xml:id on <" ||
        local-name($section) || "> '" || $section/db:title/string() || "'"
};

(:~ Every article should have an info/title :)
declare
    %test:name("All articles have titles")
    %test:assertEmpty
function tests:articles-have-titles() {
    for $article in collection($config:data-root || "/articles")/db:article
    where empty($article/db:info/db:title) or
          normalize-space($article/db:info/db:title) = ""
    return
        util:document-name($article) || ": missing or empty title"
};

(: ─── TOC generation tests ──────────────────────────────────────────── :)

(:~ TOC should have two entries for the sample article :)
declare
    %test:name("TOC generates correct number of entries")
    %test:assertEquals(2)
function tests:toc-entry-count() {
    array:size(docs:toc($tests:sample-article/db:article))
};

(:~ TOC entries should have correct IDs :)
declare
    %test:name("TOC entries use xml:id for anchors")
    %test:assertEquals("first-section")
function tests:toc-first-id() {
    let $toc := docs:toc($tests:sample-article/db:article)
    return $toc?1?id
};

(:~ TOC subsections are nested correctly :)
declare
    %test:name("TOC subsections are nested under parent")
    %test:assertEquals(1)
function tests:toc-children-count() {
    let $toc := docs:toc($tests:sample-article/db:article)
    return array:size($toc?1?children)
};

(: ─── Function documentation tests ──────────────────────────────────── :)

(:~ XQDoc data should have been generated on install :)
declare
    %test:name("XQDoc data exists after installation")
    %test:assertTrue
function tests:xqdoc-data-exists() {
    exists(collection($config:functions-data)/xqdoc:xqdoc)
};

(:~ Module categorization should identify W3C functions :)
declare
    %test:name("W3C modules are categorized correctly")
    %test:assertEquals("w3c")
function tests:categorize-w3c() {
    fundocs:categorize("http://www.w3.org/2005/xpath-functions", "java:org.exist...")
};

(:~ Extension modules are categorized correctly :)
declare
    %test:name("Extension modules are categorized correctly")
    %test:assertEquals("extension")
function tests:categorize-extension() {
    fundocs:categorize("http://exist-db.org/xquery/util", "java:org.exist...")
};

(:~ Application modules are categorized correctly :)
declare
    %test:name("Application modules are categorized correctly")
    %test:assertEquals("application")
function tests:categorize-application() {
    fundocs:categorize("http://myapp.org/modules/util", "/db/apps/myapp/modules/util.xqm")
};

(:~ Module listing should return categories :)
declare
    %test:name("Module listing returns non-empty categories")
    %test:assertTrue
function tests:module-listing-not-empty() {
    array:size(fundocs:list-modules(())) > 0
};

(: ─── Navigation tests ──────────────────────────────────────────────── :)

(:~ Breadcrumb for functions should start with Documentation :)
declare
    %test:name("Function breadcrumb starts with Documentation")
    %test:assertEquals("Documentation")
function tests:breadcrumb-starts-with-docs() {
    let $bc := nav:breadcrumb("functions", (), ())
    return $bc?1?title
};

(:~ Breadcrumb for a specific function includes prefix :)
declare
    %test:name("Function detail breadcrumb includes prefix")
    %test:assertEquals("fn")
function tests:breadcrumb-includes-prefix() {
    let $bc := nav:breadcrumb("functions", "fn", "concat")
    return $bc?3?title
};

(:~ Article breadcrumb includes Articles segment :)
declare
    %test:name("Article breadcrumb includes Articles")
    %test:assertEquals("Articles")
function tests:breadcrumb-articles() {
    let $bc := nav:breadcrumb("articles", (), ())
    return $bc?2?title
};

(: ─── Search integration tests ──────────────────────────────────────── :)

(:~ Empty search returns empty array :)
declare
    %test:name("Empty search query returns no results")
    %test:assertEquals(0)
function tests:empty-search() {
    array:size(fundocs:search(""))
};

(:~ Article search with empty query returns empty :)
declare
    %test:name("Empty article search returns no results")
    %test:assertEquals(0)
function tests:empty-article-search() {
    array:size(docs:search(""))
};
