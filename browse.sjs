
const db = require('db.sjs');

const collection = xdmp.getRequestField('collection');
const year = xdmp.getRequestField('year');

if (fn.empty(fn.collection(collection))) {
    xdmp.setResponseCode(404, 'Not Found');
    xdmp.setResponseContentType('text/plain');
    "Not Found"
} else {
    const collections = cts.collections();
    const firstYear = db.getFirstYearInCollection(collection);
    const lastYear = db.getLastYearInCollection(collection);
    const total = db.countDocumentsInCollection(collection, year);
    const docs = db.fetchAllJudgmentsInCollectionWithYear(collection, year);
    xdmp.setResponseContentType('text/html');
    xdmp.xsltInvoke('browse.xsl', null, { collections: collections, collection: collection, year: year, docs: docs, 'first-year': firstYear, 'last-year': lastYear, total: total }, { template: 'page' })
}
