
const db = require('db.sjs');

const cite = xdmp.getRequestField('cite', '').replace(/\s+/g, ' ').trim();
xdmp.log('lookup: cite = ' + cite);

function parseCite() {
    var re;
    re = new RegExp('^\\[?(\\d{4})\\]? (UKSC|UKPC) (\\d+)?$', 'i');
    match = cite.match(re);
    if (match)
        return '/' + match[2].toLowerCase() + '/' + match[1] + '/' + match[3];

    re = new RegExp('^\\[?(\\d{4})\\]? (EWCA) \\(?(Civ|Crim)\\)? (\\d+)$', 'i');
    var match = cite.match(re);
    if (match)
        return '/' + match[2].toLowerCase() + '/' + match[3].toLowerCase() + '/' + match[1] + '/' + match[4];

    re = new RegExp('^\\[?(\\d{4})\\]? (EWHC) (\\d+) \\(?(Admin|Admlty|Ch|Comm|Costs|Fam|IPEC|Pat|QB|TCC)\\)?$', 'i');
    match = cite.match(re);
    if (match)
        return '/' + match[2].toLowerCase() + '/' + match[4].toLowerCase() + '/' + match[1] + '/' + match[3];

    re = new RegExp('^\\[?(\\d{4})\\]? (EWCOP|EWFC) (\\d+)?$', 'i');
    match = cite.match(re);
    if (match)
        return '/' + match[2].toLowerCase() + '/' + match[1] + '/' + match[3];

    return null;
}

const uri = parseCite(cite);
xdmp.log('lookup: uri = ' + uri);

var response;
if (uri) {
    const doc = cts.doc(uri + '.xml');
    if (doc) {
        xdmp.setResponseContentType('text/html');
        const params = db.parseURI(uri);
        xdmp.log('lookup: params = ' + JSON.stringify(params));
        response = xdmp.xsltInvoke('judgment1.xsl', doc, params, { template: 'page' });
    } else {
        xdmp.setResponseCode(404, 'Not Found');
        xdmp.setResponseContentType('text/plain');
        response = "Not Found";
    }
} else {
    xdmp.setResponseCode(400, 'Bad Request');
    xdmp.setResponseContentType('text/plain');
    response = "Bad Request";
}
