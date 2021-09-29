
exports.parseURI = function (uri) {
    const match = uri.match(/^\/?([a-z]+(\/[a-z]+)?)\/(\d+)\/(\d+)/);
    return { collection: match[1], year: match[3], number: match[4] };
};

const dateRef = cts.pathReference('akn:FRBRWork/akn:FRBRdate/@date', [ 'type=date' ], { akn: 'http://docs.oasis-open.org/legaldocml/ns/akn/3.0' });

const orderByDate = cts.indexOrder(dateRef, ['descending']);

exports.fetch = function(query, order, page, pageSize) {
    order = order || orderByDate;
    page = page || 1;
    pageSize == pageSize || 20;
    const start = (page - 1) * pageSize + 1;
    return fn.subsequence(cts.search(query, order), start, pageSize);
}

exports.fetchMostRecentTwentyJudgments = function() {
    const query = cts.andQuery([]);
    return fn.subsequence(cts.search(query, orderByDate), 1, 20);
}

exports.fetchMostRecentTwentyJudgmentsInCollection = function(collection) {
    const query = cts.collectionQuery([collection]);
    return fn.subsequence(cts.search(query, orderByDate), 1, 20);
}

exports.getFirstYearInCollection = function(collection) {
    const query = cts.collectionQuery([collection]);
    const min = cts.min(dateRef, [], query);
    return fn.yearFromDate(min);
}
exports.getLastYearInCollection = function(collection) {
    const query = cts.collectionQuery([collection]);
    const max = cts.max(dateRef, [], query);
    return fn.yearFromDate(max);
}

exports.fetchAllJudgmentsInCollectionWithYear = function(collection, year) {
    const query = cts.directoryQuery([ '/' + collection + '/' + year + '/' ]);
    return cts.search(query, orderByDate);
};

exports.countAllDocuments = function() {
    const query = cts.andQuery([]);
    return cts.estimate(query);
};

exports.countDocumentsInCollection = function(collection, year) {
    if (year) {
        const query = cts.directoryQuery('/' + collection + '/' + year + '/', '1');
        return fn.count(cts.search(query));
        // return cts.estimate(query);
    } else {
        return fn.count(fn.collection(collection));
        // const query = cts.collectionQuery([collection]);
        // return cts.estimate(query);
    }
};
