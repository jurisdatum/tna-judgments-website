xquery version "1.0-ml";

declare variable $uri as xs:string := fn:concat(fn:substring-before(xdmp:get-request-field('uri'), '/data.xml'), '.xml');
declare variable $pretty as xs:boolean := fn:lower-case(xdmp:get-request-field('pretty', 'false')) = 'true';

let $doc := fn:doc($uri)

return
if (fn:empty($doc)) then (
    xdmp:set-response-code(404, 'Not Found'),
    xdmp:set-response-content-type('text/plain'),
    'Not Found'
) else if ($pretty) then (
    xdmp:set-response-content-type('application/xml'),
    xdmp:xslt-invoke('add-stylesheet.xsl', $doc)
) else (
    xdmp:set-response-content-type('application/xml'),
    $doc
)
