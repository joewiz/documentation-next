import { src, dest, series, parallel, watch as gulpWatch } from "gulp";
import { createClient } from "@existdb/gulp-exist";
import replace from "@existdb/gulp-replace-tmpl";
import rename from "gulp-rename";
import zip from "gulp-zip";
import del from "delete";
import { readFileSync } from "node:fs";

const packageJson = JSON.parse(readFileSync("./package.json", "utf-8"));
const { version, license, app } = packageJson;

// template replacements: first value wins
const replacements = [app, { version, license }];

// Connection settings read from .existdb.json automatically
let existClient;
try {
  existClient = createClient();
} catch (e) {
  // client creation may fail if .existdb.json is missing; OK for build-only usage
}

const packageFilename = `docs-${version}.xar`;

const staging = ".build";
const output = "dist";

// Vendor: copy jinn-tap editor assets from node_modules into resources/
// jinn-tap is a web component loaded as an ES module — no bundling needed.

// ==================== //
//    Clean tasks        //
// ==================== //

function clean(cb) {
  del([staging, output], cb);
}
export { clean };

// ==================== //
//    Copy app content   //
// ==================== //

function copyJinnTap() {
  return src([
    "node_modules/@jinntec/jinntap/dist/jinn-tap.es.js",
    "node_modules/@jinntec/jinntap/dist/jinn-tap.es.js.map",
    "node_modules/@jinntec/jinntap/dist/jinn-tap.css",
    "node_modules/@jinntec/jinntap/dist/editor-styles.css",
  ], { encoding: false, allowEmpty: true })
    .pipe(dest("resources/vendor/jinntap"));
}

function copyXarResources() {
  return src([
    "controller.xq",
    "login.html",
    "pre-install.xq",
    "finish.xq",
    "collection.xconf",
    "articles-collection.xconf",
    "icon.png",
    "modules/**/*",
    "templates/**/*",
    "resources/**/*",
    "data/**/*",
    "test/xqs/**/*",
    "README.md",
    "LICENSE",
  ], { encoding: false, allowEmpty: true, base: "." })
    .pipe(dest(staging));
}

// ==================== //
//    Template tasks     //
// ==================== //

function templates() {
  return src("*.tmpl")
    .pipe(replace(replacements, { unprefixed: true }))
    .pipe(rename((path) => { path.extname = ""; }))
    .pipe(dest(staging));
}

// ==================== //
//    XAR packaging      //
// ==================== //

function createXar() {
  return src(`${staging}/**/*`, { encoding: false })
    .pipe(zip(packageFilename))
    .pipe(dest(output));
}

// ==================== //
//    Deploy to eXist    //
// ==================== //

function deployXar() {
  return src(`${output}/${packageFilename}`, { encoding: false }).pipe(
    existClient.install({ packageUri: app.namespace })
  );
}

// ==================== //
//    Composed tasks     //
// ==================== //

const build = series(
  clean,
  copyJinnTap,
  copyXarResources,
  templates,
  createXar
);

const install = series(build, deployXar);

export { build, install };

// default: build + deploy + watch
export default series(build, deployXar, function watchTask() {
  gulpWatch(
    ["modules/**/*", "templates/**/*", "resources/**/*", "controller.xq", "*.xq"],
    series(build, deployXar)
  );
});
