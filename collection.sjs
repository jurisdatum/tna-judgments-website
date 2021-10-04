
const db = require('db.sjs');

const collection = xdmp.getRequestField('collection');

if (!db.collectionExists(collection)) {
    xdmp.setResponseCode(404, 'Not Found');
    xdmp.setResponseContentType('text/plain');
    "Not Found"
} else {
    const collections = cts.collections();
    const firstYear = db.getFirstYearInCollection(collection);
    const lastYear = db.getLastYearInCollection(collection);
    const total = db.countDocumentsInCollection(collection);
    const docs = db.fetchMostRecentTwentyJudgmentsInCollection(collection);
    xdmp.setResponseContentType('text/html');
    xdmp.xsltInvoke('collection.xsl', null, { collections: collections, collection: collection, 'first-year': firstYear, 'last-year': lastYear, total: total, docs: docs }, { template: 'page' })
}
