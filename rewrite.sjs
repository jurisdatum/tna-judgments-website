
const url = xdmp.getRequestUrl();

url.match(/^\/$/) ? 'index.sjs' :

// url.match(/^\/test\?/) ? 'test.sjs' + url.substring(5):

url == '/search' ?
    'search.xqy' :

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

url.match(/^\/[a-z]+(\/[a-z]+)?\/\d+\/\d+\/data\.xml$/) ?
    'xml1.xqy?uri=' + url :

url.match(/^\/[a-z]+(\/[a-z]+)?\/\d+\/\d+\/data\.xml\?/) ?
    'xml1.xqy?uri=' + url.substring(0, url.indexOf('?')) + '&' + url.substring(url.indexOf('?') + 1) :

url.match(/^\/pretty.xsl$/) ?
    'pretty.xsl' :

url.match(/^\/[a-z]+\/[a-z]+\/\d+\/\d+\/data\.html$/) ?
    'html0.xqy?uri=' + url.substring(0, url.length - 10) :

url.match(/^\/[a-z]+(\/[a-z]+)?\/\d+\/\d+\/test$/) ?
    'test.xqy?uri=' + url.substring(1, url.lastIndexOf('/')) :

url.match(/^\/[a-z]+(\/[a-z]+)?\/\d+\/\d+\/test\/data\.xml$/) ?
    'test.xqy?uri=' + url.substring(1, url.length - 14) + '&raw=true' :

'400.sjs?uri=' + url
