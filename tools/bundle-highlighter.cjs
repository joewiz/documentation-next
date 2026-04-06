/**
 * Bundle CM6/Lezer syntax highlighter into a single IIFE for the browser.
 *
 * Produces resources/js/highlight-bundle.js exposing a global
 * `highlightCode` function that highlights <code> elements using
 * CM6's parser + highlightTree (same approach as eXide and Notebook).
 *
 * Supports: xquery, xml, html, json, javascript, java, shell/bash,
 *           dockerfile/docker, yaml, nginx
 */
const esbuild = require("esbuild");
const path = require("path");

const entryContents = `
import { highlightTree, classHighlighter } from '@lezer/highlight';
import { StreamLanguage } from '@codemirror/language';
import { xml } from '@codemirror/lang-xml';
import { json } from '@codemirror/lang-json';
import { html } from '@codemirror/lang-html';
import { javascript } from '@codemirror/lang-javascript';
import { xQuery } from '@codemirror/legacy-modes/mode/xquery';
import { java as javaMode } from '@codemirror/legacy-modes/mode/clike';
import { shell } from '@codemirror/legacy-modes/mode/shell';
import { dockerFile } from '@codemirror/legacy-modes/mode/dockerfile';
import { yaml } from '@codemirror/legacy-modes/mode/yaml';
import { nginx } from '@codemirror/legacy-modes/mode/nginx';

function getLanguage(lang) {
    switch (lang) {
        case 'xquery':
            return StreamLanguage.define(xQuery).language;
        case 'xml':
        case 'xslt':
        case 'xconf':
            return xml().language;
        case 'json':
            return json().language;
        case 'html':
        case 'xhtml':
            return html().language;
        case 'javascript':
        case 'js':
            return javascript().language;
        case 'java':
            return StreamLanguage.define(javaMode).language;
        case 'shell':
        case 'bash':
        case 'sh':
            return StreamLanguage.define(shell).language;
        case 'dockerfile':
        case 'docker':
            return StreamLanguage.define(dockerFile).language;
        case 'yaml':
        case 'yml':
            return StreamLanguage.define(yaml).language;
        case 'nginx':
            return StreamLanguage.define(nginx).language;
        default:
            // Try content sniffing
            return null;
    }
}

/**
 * Highlight a DOM element's text content using CM6's Lezer parser.
 * Replaces the element's children with highlighted <span> elements.
 *
 * @param {HTMLElement} el - element containing code text
 * @param {string} lang - language identifier
 */
function highlightElement(el, lang) {
    const text = el.textContent;
    if (!text || text.length === 0) return;
    if (text.length > 500000) return; // skip huge blocks

    const language = getLanguage(lang);
    if (!language) return;

    const tree = language.parser.parse(text);
    const parts = [];
    let pos = 0;

    highlightTree(tree, classHighlighter, (from, to, classes) => {
        if (from > pos) {
            parts.push(document.createTextNode(text.slice(pos, from)));
        }
        const span = document.createElement('span');
        span.className = classes;
        span.textContent = text.slice(from, to);
        parts.push(span);
        pos = to;
    });

    if (pos < text.length) {
        parts.push(document.createTextNode(text.slice(pos)));
    }

    if (parts.length > 0) {
        el.textContent = '';
        for (const part of parts) {
            el.appendChild(part);
        }
    }
}

globalThis.highlightCode = { highlightElement, getLanguage };
`;

esbuild
    .build({
        stdin: {
            contents: entryContents,
            resolveDir: path.resolve(__dirname, ".."),
            loader: "js",
        },
        bundle: true,
        format: "iife",
        platform: "browser",
        target: ["es2018"],
        outfile: path.resolve(__dirname, "../resources/js/highlight-bundle.js"),
        minify: true,
        logLevel: "info",
    })
    .catch(() => process.exit(1));
