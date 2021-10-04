
const uri = xdmp.getRequestField('uri') + '.xml';
const highlight = xdmp.getRequestField('highlight');
const scope = xdmp.getRequestField('scope', 'full');

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
return xdmp.xsltInvoke('judgment1.xsl', doc, params, { template: 'page' });

})()

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
