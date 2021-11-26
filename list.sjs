
const db = require('db.sjs');

const collection = xdmp.getRequestField('collection');

const path = '/' + ( collection ? collection + '/' : '' );

const query = cts.directoryQuery(path, 'infinity');

const uris = cts.uris('', [], query);

const ids = Sequence.from(uris, { mapFn: function(uri) { return uri.toString().substring(1, uri.toString().length - 4); }, sequenceLimit: fn.count(uris).toString() });

xdmp.setResponseContentType('application/json');

JSON.stringify(ids.toArray())
