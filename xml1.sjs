const uri = xdmp.getRequestField('uri').replace(/\/data\.xml$/, '.xml');
const doc = cts.doc(uri);
var response;
if (doc) {
    xdmp.setResponseContentType('application/xml');
    response = doc;
} else {
    xdmp.setResponseCode(404, 'Not Found');
    xdmp.setResponseContentType('text/plain');
    response = "Not Found";
}
response;
