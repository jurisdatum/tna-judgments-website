
declare variable $url as xs:string := xdmp:get-request-field('url');

let $host as xs:string := 'https://attachments.judgments.tna.jurisdatum.com'
let $url as xs:string := fn:replace($url, '/attachment/', '/')
return (   
xdmp:set-response-code(302, 'Found'),
xdmp:add-response-header('Location', fn:concat($host, $url))
)
