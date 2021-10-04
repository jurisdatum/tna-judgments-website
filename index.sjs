
const db = require('db.sjs');

const collections = cts.collections();
const total = db.countAllDocuments();
const docs = db.fetchMostRecentTwentyJudgments();

xdmp.setResponseContentType('text/html');
xdmp.xsltInvoke('index.xsl', null, { collections: collections, total: total, docs: docs }, { template: 'page' });
