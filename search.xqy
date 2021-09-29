xquery version "1.0-ml";

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

let $q := xdmp:get-request-field('q')
let $scope := xdmp:get-request-field('scope', 'full')
let $collection := xdmp:get-request-field('collection')

let $page as xs:integer := let $raw := xdmp:get-request-field('page', '1') return if ($raw castable as xs:integer) then xs:integer($raw) else 1
let $page-size as xs:integer := let $raw := xdmp:get-request-field('page-size', '20') return if ($raw castable as xs:integer) then xs:integer($raw) else 20
let $start as xs:integer := ($page - 1) * $page-size + 1

let $_ := xdmp:log(concat('searching in ', $collection))

let $query :=
    let $query1 := if ($scope = 'party')
        then cts:element-word-query(fn:QName('http://docs.oasis-open.org/legaldocml/ns/akn/3.0', 'party'), $q)
        else cts:word-query($q)
    return if ($collection)
        then cts:and-query(( cts:directory-query(fn:concat('/', $collection, '/'), 'infinity'), $query1 ))
        else $query1

let $options := <options xmlns="http://marklogic.com/appservices/search">
    <extract-document-data xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0">
        <extract-path>//akn:FRBRWork/akn:FRBRname</extract-path>
        <extract-path>//akn:neutralCitation</extract-path>
        <extract-path>//akn:FRBRWork/akn:FRBRdate</extract-path>
    </extract-document-data>
</options>

let $response := search:resolve($query, $options, $start, $page-size)
let $_ := xdmp:log($response)
let $params := map:map() => map:with('q', $q) => map:with('scope', $scope) => map:with('collection', $collection) => map:with('page', $page) => map:with('page-size', $page-size)
let $xslt-options := map:map() => map:with('template', 'page')
return xdmp:xslt-invoke('search.xsl', $response, $params, $xslt-options)
