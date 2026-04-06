<div class="docs-layout">
    <div class="docs-content">
        <nav class="breadcrumb" aria-label="Breadcrumb">
            [% for $crumb in $breadcrumb?* %]
            [% if exists($crumb?url) %]
            <a href="[[ $crumb?url ]]">[[ $crumb?title ]]</a>
            <span class="breadcrumb-sep" aria-hidden="true">/</span>
            [% else %]
            <span aria-current="page">[[ $crumb?title ]]</span>
            [% endif %]
            [% endfor %]
        </nav>

        <h1>Documentation Administration</h1>

        <section class="admin-section">
            <h2>Regenerate Function Documentation</h2>
            <p>Rescan all installed XQuery modules and regenerate the function
               documentation index. This is useful after installing new packages
               or updating eXist-db.</p>
            <button type="button" class="btn btn-primary" id="regenerate-btn"
                    data-url="[[ $app-base ]]/api/xqdoc/regenerate">Regenerate</button>
            <div id="regenerate-status"></div>
        </section>

        <section class="admin-section">
            <h2>Convert Articles: DocBook to XDITA</h2>
            <p>Convert DocBook articles to XDITA (Lightweight DITA) format.
               Converted files are stored alongside the originals as
               <code>{slug}.xdita.xml</code>.</p>
            <div class="admin-actions">
                <button type="button" class="btn btn-primary" id="convert-all-btn"
                        data-url="[[ $app-base ]]/api/articles/convert?slug=all">Convert All</button>
            </div>
            <div id="convert-status"></div>
            <table class="admin-table" id="article-format-table">
                <thead>
                    <tr>
                        <th>Article</th>
                        <th>Format</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    [% for $article in $all-articles?* %]
                    <tr>
                        <td><a href="[[ $app-base ]]/articles/[[ $article?slug ]]/">[[ $article?title ]]</a></td>
                        <td>[[ $article?format ]]</td>
                        <td>
                            [% if $article?format = "docbook" %]
                            <button type="button" class="btn btn-sm convert-btn"
                                    data-url="[[ $app-base ]]/api/articles/convert?slug=[[ $article?slug ]]"
                                    data-slug="[[ $article?slug ]]">Convert</button>
                            [% else %]
                            <span class="badge">XDITA</span>
                            [% endif %]
                        </td>
                    </tr>
                    [% endfor %]
                </tbody>
            </table>
        </section>

        <section class="admin-section">
            <h2>Edit XDITA Article</h2>
            <p>Select an XDITA article to edit in the browser. Changes are saved
               directly to the database.</p>
            <div class="editor-controls">
                <select id="article-selector">
                    <option value="">-- Select article --</option>
                    [% for $article in $all-articles?* %]
                    [% if $article?format = "xdita" %]
                    <option value="[[ $article?slug ]]">[[ $article?title ]]</option>
                    [% endif %]
                    [% endfor %]
                </select>
                <button type="button" class="btn btn-primary" id="save-article-btn" disabled="disabled">Save</button>
                <span id="editor-status"></span>
            </div>
            <div id="editor-container" class="editor-container">
                <jinn-tap id="xdita-editor"
                    schema="[[ $app-base ]]/resources/xdita-schema.json">
                </jinn-tap>
            </div>
        </section>
    </div>
</div>
