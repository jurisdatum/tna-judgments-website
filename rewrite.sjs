
const url = xdmp.getRequestUrl();

url.match(/^\/$/) ? 'index.sjs' :

// url.match(/\.css$/) ? url :

url.match(/^\/search\?/) ?
    'search.xqy' + url.substring(url.indexOf('?')) :

url.match(/^\/lookup\?/) ?
    'lookup.sjs' + url.substring(url.indexOf('?')) :

url.match(/^\/[a-z]+(\/[a-z]+)?$/) ?
    'collection.sjs?collection=' + url.substring(1) :

url.match(/^\/[a-z]+(\/[a-z]+)?\/\d+$/) ?
    'browse.sjs?collection=' + url.substring(1, url.lastIndexOf('/')) + '&year=' + url.substring(url.lastIndexOf('/') + 1) :

url.match(/^\/[a-z]+(\/[a-z]+)?(\/\d+)?\/data\.json$/) ?
    'list.sjs?collection=' + url.substring(1, url.length - 10) :

url.match(/^\/[a-z]+(\/[a-z]+)?\/\d+\/\d+$/) ?
    'html1.sjs?uri=' + url :

url.match(/^\/[a-z]+(\/[a-z]+)?\/\d+\/\d+\?/) ?
    'html2.sjs?uri=' + url.substring(0, url.indexOf('?')) + '&' + url.substring(url.indexOf('?') + 1) :

url.match(/^\/[a-z]+\/[a-z]+\/\d+\/\d+\/data\.xml$/) ?
    'xml1.sjs?uri=' + url :

'400.sjs?uri=' + url
