xquery version "1.0-ml";

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare namespace akn = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0";
declare namespace uk = "https://caselaw.nationalarchives.gov.uk";

declare function uk:get-request-int($name as xs:string, $default as xs:integer) as xs:integer {
    let $raw := xdmp:get-request-field($name)
    return if ($raw castable as xs:integer) then xs:integer($raw) else $default
};
declare function uk:get-request-date($name as xs:string) as xs:date? {
    let $raw := xdmp:get-request-field($name)
    return if ($raw castable as xs:date) then xs:date($raw) else ()
};

declare variable $q as xs:string? := xdmp:get-request-field('q');
declare variable $party as xs:string? := xdmp:get-request-field('party');
declare variable $collection as xs:string? := xdmp:get-request-field('collection');
declare variable $court as xs:string? := xdmp:get-request-field('court');
declare variable $judge as xs:string? := xdmp:get-request-field('judge');
declare variable $from as xs:date? := uk:get-request-date('from');
declare variable $to as xs:date? := uk:get-request-date('to');
declare variable $order as xs:string? := xdmp:get-request-field('order');
declare variable $page as xs:integer := uk:get-request-int('page', 1);
declare variable $page-size as xs:integer := uk:get-request-int('page-size', 20);

let $start as xs:integer := ($page - 1) * $page-size + 1

let $params := map:map()
    => map:with('q', $q)
    => map:with('party', $party)
    => map:with('collection', $collection)
    => map:with('court', $court)
    => map:with('judge', $judge)
    => map:with('from', $from)
    => map:with('to', $to)
    => map:with('order', $order)
    => map:with('page', $page)
    => map:with('page-size', $page-size)

let $query1 := if ($q) then cts:word-query($q) else ()
let $query2 := if ($party) then
    cts:or-query((
        cts:element-word-query(fn:QName('http://docs.oasis-open.org/legaldocml/ns/akn/3.0', 'party'), $party),
        cts:element-attribute-word-query(fn:QName('http://docs.oasis-open.org/legaldocml/ns/akn/3.0', 'FRBRname'), fn:QName('', 'value'), $party)
    ))
else ()
let $query3 := if ($collection) then cts:directory-query(fn:concat('/', $collection, '/'), 'infinity') else ()
let $query4 := if ($court) then cts:or-query((
    cts:element-value-query(fn:QName('https:/judgments.gov.uk/', 'court'), $court, ('case-insensitive')),
    cts:element-value-query(fn:QName('https://caselaw.nationalarchives.gov.uk/akn', 'court'), $court, ('case-insensitive'))
)) else ()
let $query5 := if ($judge) then cts:element-word-query(fn:QName('http://docs.oasis-open.org/legaldocml/ns/akn/3.0', 'judge'), $judge) else ()
let $query6 := if (empty($from)) then () else cts:path-range-query('akn:FRBRWork/akn:FRBRdate/@date', '>=', $from)
let $query7 := if (empty($to)) then () else cts:path-range-query('akn:FRBRWork/akn:FRBRdate/@date', '<=', $to)
let $queries := ( $query1, $query2, $query3, $query4, $query5, $query6, $query7 )
let $query := cts:and-query($queries)

let $show-snippets as xs:boolean := exists(( $query1, $query2, $query5 ))

let $sort-order := if ($order = 'date') then
    <sort-order xmlns="http://marklogic.com/appservices/search" direction="ascending">
        <path-index xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0">akn:FRBRWork/akn:FRBRdate/@date</path-index>
    </sort-order>
else if ($order = '-date') then
    <sort-order xmlns="http://marklogic.com/appservices/search" direction="descending">
        <path-index xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0">akn:FRBRWork/akn:FRBRdate/@date</path-index>
    </sort-order>
else
    ()

let $transform-results := if ($show-snippets) then
    <transform-results apply="snippet">
        <preferred-matches>
            <element name="p" ns="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"/>
        </preferred-matches>
    </transform-results>
else
    <transform-results apply="empty-snippet" />

let $search-options := <options xmlns="http://marklogic.com/appservices/search">
    { $sort-order }
    <extract-document-data xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0">
        <extract-path>//akn:FRBRWork/akn:FRBRname</extract-path>
        <extract-path>//akn:neutralCitation</extract-path>
        <extract-path>//akn:FRBRWork/akn:FRBRdate</extract-path>
    </extract-document-data>
    { $transform-results }
</options>

let $results := search:resolve($query, $search-options, $start, $page-size)
let $total as xs:integer := xs:integer($results/@total)
let $pages as xs:integer := if ($total mod $page-size eq 0) then $total idiv $page-size else $total idiv $page-size + 1
let $params := $params => map:with('pages', $pages)

return xdmp:xslt-invoke('search.xsl', $results, $params)
