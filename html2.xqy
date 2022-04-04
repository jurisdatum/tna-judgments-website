xquery version "1.0-ml";

declare variable $uri as xs:string := fn:concat(xdmp:get-request-field('uri'), '.xml');

declare variable $doc as document-node()? := fn:doc($uri);

if (fn:exists($doc)) then (
    xdmp:set-response-content-type('text/html'),
    xdmp:xslt-invoke('judgment2.xsl', $doc)

) else (
    xdmp:set-response-code(404, 'Not Found'),
    xdmp:set-response-content-type('text/plain'),
    "Not Found"
)
