xquery version "1.0-ml";

import module namespace helper = "https://caselaw.nationalarchives.gov.uk/helper" at "./helper.xqy";
declare namespace html1 = "https://caselaw.nationalarchives.gov.uk/html1";

declare variable $uri as xs:string := fn:concat(xdmp:get-request-field('uri'), '.xml');

declare variable $highlight as xs:string? := xdmp:get-request-field('highlight');
declare variable $scope as xs:string := xdmp:get-request-field('scope', 'full');

declare function html1:get-format() as xs:string? {
    let $param := fn:lower-case(xdmp:get-request-field('format', ''))
    return if ($param = ('new', 'old')) then $param else html1:get-format-cookie()
};

declare function html1:get-format-cookie() as xs:string? {
    let $header := fn:string(xdmp:get-request-header('Cookie', ''))
    let $cookies := fn:tokenize($header, ';')
    let $values := for $cookie in $cookies
        let $a := fn:tokenize($cookie, '=')
        return if (fn:normalize-space($a[1]) = 'format') then fn:normalize-space($a[2]) else ()
    return $values[1]
};

let $doc as document-node()? := fn:doc($uri)

return if (fn:empty($doc)) then (
    xdmp:set-response-code(404, 'Not Found'),
    xdmp:set-response-content-type('text/plain'),
    "Not Found"
) else

let $query := if ($scope = 'party') then helper:make-party-query($highlight) else helper:make-q-query($highlight)
let $doc := if (fn:exists($doc) and $highlight) then cts:highlight($doc, $query, <mark xmlns="http://www.w3.org/1999/xhtml">{ $cts:text }</mark>) else $doc

let $match := fn:analyze-string($uri, '^/([a-z]+(/[a-z]+)?)/(\d+)/(\d+)')
let $collection := fn:normalize-space($match/*:match/*:group[@nr=1])
let $year := fn:normalize-space($match/*:match/*:group[@nr=3])
let $number := fn:normalize-space($match/*:match/*:group[@nr=4])
let $params := map:map()
    => map:with('collection', $collection)
    => map:with('year', $year)
    => map:with('number', $number)
    => map:with('standalone', fn:false())
    => map:with('image-base', 'https://judgment-images.s3.eu-west-2.amazonaws.com/')
    => map:with('suppress-links', fn:false())
let $options := map:map() => map:with('template', 'page')
return if (html1:get-format() = 'new') then (
    xdmp:set-response-content-type('text/html'),
    xdmp:add-response-header('Set-Cookie', "format=new; path=/"),
    xdmp:xslt-invoke('judgment3.xsl', $doc, $params, $options)
) else (
    xdmp:set-response-content-type('text/html'),
    xdmp:add-response-header('Set-Cookie', "format=old; path=/"),
    xdmp:xslt-invoke('judgment1.xsl', $doc, $params, $options)
)
