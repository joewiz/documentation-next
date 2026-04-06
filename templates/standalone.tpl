<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>[[ $page-title ]]</title>
    <link rel="icon" href="[[ $app-base ]]/resources/favicon.ico"/>
    [[ $extra-head ]]
</head>
<body>
    <a href="#main-content" class="skip-link">Skip to content</a>

    <header class="site-header">
        <nav class="site-nav" aria-label="Main navigation">
            <a href="[[ $app-base ]]/" class="site-logo">
                eXist-db Documentation
            </a>

            <ul class="site-menu">
                <li><a href="[[ $app-base ]]/articles/">Articles</a></li>
                <li><a href="[[ $app-base ]]/functions/">Functions</a></li>
                <li><a href="[[ $app-base ]]/search">Search</a></li>
            </ul>

            <form class="site-search" action="[[ $app-base ]]/search" method="get">
                <label for="site-search-input" class="visually-hidden">Search</label>
                <input type="search" id="site-search-input" name="q"
                       placeholder="Search functions..."
                       aria-label="Search"/>
            </form>
        </nav>
    </header>

    <main id="main-content">
        [[ $page-content ]]
    </main>

    <footer class="site-footer">
        <p>&copy; 2001&#8211;2026 The eXist-db Authors.
           <a href="https://github.com/eXist-db/exist">Source</a> &#183;
           <a href="https://exist-db.org">exist-db.org</a>
        </p>
    </footer>
</body>
</html>
