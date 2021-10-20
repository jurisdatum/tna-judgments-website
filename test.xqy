xquery version "1.0-ml";

import module namespace schematron = "http://marklogic.com/xdmp/schematron" at "/MarkLogic/schematron/schematron.xqy";

declare variable $uri as xs:string := fn:concat('/', xdmp:get-request-field('uri'), '.xml');
declare variable $raw as xs:boolean := xdmp:get-request-field('raw', 'false') = 'true';

let $doc := fn:doc($uri)

let $schema := <schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" defaultPhase="publication" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0">

<ns prefix="akn" uri="http://docs.oasis-open.org/legaldocml/ns/akn/3.0" />

<phase id="preservation">
    <active pattern="court-pattern" />
    <active pattern="date-pattern" />
    <active pattern="cite-pattern" />
    <active pattern="name-pattern" />
</phase>

<phase id="publication">
    <active pattern="court-pattern" />
    <active pattern="date-pattern" />
    <active pattern="cite-pattern" />
    <active pattern="name-pattern" />
    <active pattern="party-pattern" />
</phase>

<pattern id="court-pattern">
    <rule context="akn:meta">
        <assert test="exists(akn:proprietary/*:court)">There is no court</assert>
        <report test="exists(akn:proprietary/*:court)" id="court" role="info">The court is <value-of select="akn:proprietary/*:court"/></report>
    </rule>
</pattern>

<pattern id="date-pattern">
    <rule context="akn:FRBRWork">
        <assert test="exists(akn:FRBRdate)">There is no date</assert>
        <report test="exists(akn:FRBRdate)" id="date" role="info">The date is <value-of select="akn:FRBRdate/@date"/></report>
    </rule>
</pattern>

<pattern id="cite-pattern">
    <rule context="akn:header">
        <let name="cites" value="descendant::akn:neutralCitation" />
        <assert test="exists($cites)">There is no neutral citation</assert>
        <report test="exists($cites)" id="cite" role="info">The neutral citation is <value-of select="$cites[1]"/></report>
    </rule>
</pattern>

<pattern id="name-pattern">
    <rule context="akn:FRBRWork">
        <assert test="exists(akn:FRBRname)">There is no case name</assert>
        <report test="exists(akn:FRBRname)" id="case-name" role="info">The case name is <value-of select="akn:FRBRname/@value"/></report>
    </rule>
</pattern>

<pattern id="party-pattern">
    <rule context="akn:header">
        <let name="parties" value="descendant::akn:party" />
        <let name="roles" value="distinct-values($parties/@as)" />
        <let name="title" value="descendant::akn:docTitle" />
        <assert test="count($roles) ge 2 or exists(descendant::akn:docTitle)">There are not two parties or a docTitle</assert>
    </rule>
    <rule context="akn:party">
    	<report test="true()" id="party" role="info">One party is <value-of select="."/> (<value-of select="substring(@as, 2)"/>)</report>
    </rule>
    <rule context="akn:docTitle">
    	<report test="true()" id="doc-title" role="info">The docTitle is <value-of select="."/></report>
    </rule>
</pattern>

<pattern id="judge-pattern">
    <rule context="akn:header">
        <let name="judges" value="descendant::akn:judge" />
        <report test="empty($judges)" role="warning">There are no judges</report>
    </rule>
    <rule context="akn:judge">
        <report test="true()" id="judge" role="info">One judge is <value-of select="."/></report>
    </rule>
</pattern>

</schema>

let $params := map:map()
    => map:with('phase', '#ALL')
    => map:with('generate-fired-rule', fn:false())
    (: => map:with('validate-schema', fn:false()) :)

let $schematron := schematron:compile($schema, $params)

let $svrl := schematron:validate($doc, $schematron)

return if ($raw) then $svrl else
    let $components := fn:tokenize(xdmp:get-request-field('uri'),'/')
    let $params := map:map()
        => map:with('collection', fn:string-join(fn:subsequence($components, 1, fn:count($components) - 2), '/'))
        => map:with('year', $components[fn:last() - 1])
        => map:with('number', $components[fn:last()])
    return xdmp:xslt-invoke('test.xsl', $svrl, $params)
