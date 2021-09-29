
const db = require('db.sjs');

const collection = xdmp.getRequestField('collection');

const query = cts.directoryQuery('/' + collection + '/', 'infinity');

const docs = cts.search(query);

const uris = Sequence.from(docs, function(doc) { return fn.documentUri(doc).toString(); });

const ids = Sequence.from(uris, function(uri) { return uri.substring(1, uri.length - 4); });

xdmp.setResponseContentType('application/json');

JSON.stringify(ids.toArray())
