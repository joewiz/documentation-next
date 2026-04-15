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

        <section class="admin-section" id="xdita-editor-section">
            <h2>Edit Article</h2>
            <p>Use the <strong>Edit Article</strong> button on any article page to open
               the editor. The article will load automatically below.</p>
            <div class="editor-controls">
                <button type="button" class="btn btn-primary" id="save-article-btn" disabled="disabled">Save</button>
                <span id="editor-status"></span>
            </div>
            <div id="editor-container" class="editor-container">
                <jinn-tap id="xdita-editor"
                    schema="[[ $app-base ]]/resources/xdita-schema.json">
                </jinn-tap>
            </div>
        </section>

        <section class="admin-section">
            <h2>Editorial Tools</h2>
            <p>The following tools are pending review and will be integrated here
               once ready. See
               <a href="https://github.com/joewiz/documentation-next/issues/1">issue #1</a>
               for details.</p>
            <ul>
                <li><strong>Diagnostics</strong> — article health and link checker
                    (originally <code>diagnostics.html</code>)</li>
                <li><strong>Editorial View</strong> — article status dashboard
                    (originally <code>editorial-view.html</code>)</li>
            </ul>
        </section>
    </div>
</div>
