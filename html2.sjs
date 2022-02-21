
const uri = xdmp.getRequestField('uri') + '.xml';
const highlight = xdmp.getRequestField('highlight');
const scope = xdmp.getRequestField('scope', 'full');
const format = getFormat();

(function() {

var doc = cts.doc(uri);
if (!doc) {
    xdmp.setResponseCode(404, 'Not Found');
    xdmp.setResponseContentType('text/plain');
    return "Not Found";
}

if (highlight)
    doc = highlightDocument(doc, highlight, scope);

const match = uri.match(/^\/([a-z]+(\/[a-z]+)?)\/(\d+)\/(\d+)/);
const params = { collection: match[1], year: match[3], number: match[4] };
xdmp.setResponseContentType('text/html');
if (format === 'new')
    xdmp.addResponseHeader('Set-Cookie', "format=new; path=/");
else if (format === 'old')
    xdmp.addResponseHeader('Set-Cookie', "format=old; path=/");
if (format === 'new')
    return xdmp.xsltInvoke('judgment3.xsl', doc, params, { template: 'page' });
else
    return xdmp.xsltInvoke('judgment1.xsl', doc, params, { template: 'page' });

})();

function highlightDocument(doc, highlight, scope) {
    const doc2 = new NodeBuilder();
    const query = scope === 'party' ? cts.elementWordQuery(fn.QName('http://docs.oasis-open.org/legaldocml/ns/akn/3.0', 'party'), highlight) : cts.wordQuery(highlight);
    cts.highlight(doc, query, function (builder, text) {
        builder.startElement('mark', 'http://www.w3.org/1999/xhtml');
        builder.addText(text);
        builder.endElement();
    }, doc2);
    return doc2.toNode();
}

function getFormat() {
    const param = xdmp.getRequestField('format', '').toLowerCase();
    if (param === 'old')
        return param;
    if (param === 'new')
        return param;
    return getFormatCookie();
}

function getFormatCookie() {
    let header = xdmp.getRequestHeader('Cookie', '').toString();
    let cookies = header.split(';');
    const x = (previous, current) => {
        const a = current.split('=', 2);
        if (a[0].trim() === 'format')
            return a[1].trim();
        return previous;
    };
    return cookies.reduce(x, null);
}
