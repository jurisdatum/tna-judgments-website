<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:search="http://marklogic.com/appservices/search"
    xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
    exclude-result-prefixes="xs search akn">

<xsl:import href="page.xsl" />

<xsl:param name="q" as="xs:string?" />
<xsl:param name="party" as="xs:string?" />
<xsl:param name="collection" as="xs:string?" />
<xsl:param name="court" as="xs:string?" />
<xsl:param name="judge" as="xs:string?" />
<xsl:param name="from" as="xs:date?" />
<xsl:param name="to" as="xs:date?" />
<xsl:param name="order" as="xs:string?" />
<xsl:param name="page" as="xs:integer" />
<xsl:param name="page-size" as="xs:integer" />

<xsl:variable name="all-collections" as="xs:string+">
    <xsl:sequence select="'ewca/civ'" />
    <xsl:sequence select="'ewca/crim'" />
    <xsl:sequence select="'ewcop'" />
    <xsl:sequence select="'ewfc'" />
    <xsl:sequence select="'ewhc/admin'" />
    <xsl:sequence select="'ewhc/admlty'" />
    <xsl:sequence select="'ewhc/ch'" />
    <xsl:sequence select="'ewhc/comm'" />
    <xsl:sequence select="'ewhc/costs'" />
    <xsl:sequence select="'ewhc/fam'" />
    <xsl:sequence select="'ewhc/ipec'" />
    <xsl:sequence select="'ewhc/pat'" />
    <xsl:sequence select="'ewhc/qb'" />
    <xsl:sequence select="'ewhc/tcc'" />
</xsl:variable>

<xsl:template match="search:response">
    <xsl:call-template name="page" />
</xsl:template>

<xsl:template name="title">
    <xsl:text>Search</xsl:text>
</xsl:template>

<xsl:template name="breadcrumbs">
    <a href="/">/</a>
    <span>search</span>
</xsl:template>

<xsl:template name="left-column">
    <h2>Search</h2>
    <form action="/search">
        <p>
            <div>Full text:</div>
            <div>
                <input name="q" value="{ $q }" placeholder="Full text" />
            </div>
        </p>
        <p>
            <div>Party:</div>
            <div>
                <input name="party" value="{ $party }" placeholder="Party name" />
            </div>
        </p>
        <p>
            <div>Collection:</div>
            <div>
                <select name="collection" style="width:114pt">
                    <option value="">any</option>
                    <xsl:for-each select="$all-collections">
                        <option value="{.}">
                            <xsl:if test="$collection = .">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:value-of select="." />
                        </option>
                    </xsl:for-each>
                </select>
            </div>
        </p>
        <p>
            <div>Court:</div>
            <div>
                <select name="court" style="width:114pt">
                    <option value="">any</option>
                    <optgroup label="Court of Appeal">
                        <option value="EWCA-Criminal">
                            <xsl:if test="$court = 'EWCA-Criminal'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Court of Appeal (Crim)</xsl:text>
                        </option>
                        <option value="EWCA-Civil">
                            <xsl:if test="$court = 'EWCA-Civil'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Court of Appeal (Civil)</xsl:text>
                        </option>
                    </optgroup>
                    <optgroup label="High Court">
                        <option value="EWHC">
                            <xsl:if test="$court = 'EWHC'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>High Court of Justice</xsl:text>
                        </option>
                    <optgroup label="Queen's Bench Division">
                        <option value="EWHC-QBD">
                            <xsl:if test="$court = 'EWHC-QBD'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Queen's Bench Division</xsl:text>
                        </option>
                        <option value="EWHC-QBD-Admin">
                            <xsl:if test="$court = 'EWHC-QBD-Admin'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Administrative Court</xsl:text>
                        </option>
                        <option value="EWHC-QBD-Planning">
                            <xsl:if test="$court = 'EWHC-QBD-Planning'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Planning Court</xsl:text>
                        </option>
                        <option value="EWHC-QBD-BusinessAndProperty">
                            <xsl:if test="$court = 'EWHC-QBD-BusinessAndProperty'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Business &amp; Propty Cts</xsl:text>
                        </option>
                        <option value="EWHC-QBD-Commercial">
                            <xsl:if test="$court = 'EWHC-QBD-Commercial'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Commercial Court</xsl:text>
                        </option>
                        <option value="EWHC-QBD-Admiralty">
                            <xsl:if test="$court = 'EWHC-QBD-Admiralty'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Admiralty Court</xsl:text>
                        </option>
                        <option value="EWHC-QBD-TCC">
                            <xsl:if test="$court = 'EWHC-QBD-TCC'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Tech &amp; Construction</xsl:text>
                        </option>
                        <option value="EWHC-QBD-Commercial-Financial">
                            <xsl:if test="$court = 'EWHC-QBD-Commercial-Financial'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Financial List</xsl:text>
                        </option>
                        <option value="EWHC-QBD-Commercial-Circuit">
                            <xsl:if test="$court = 'EWHC-QBD-Commercial-Circuit'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Circuit Commercial Ct</xsl:text>
                        </option>
                    </optgroup>
                    <optgroup label="Chancery Division">
                        <option value="EWHC-Chancery">
                            <xsl:if test="$court = 'EWHC-Chancery'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Chancery Division</xsl:text>
                        </option>
                        <option value="EWHC-Chancery-Business">
                            <xsl:if test="$court = 'EWHC-Chancery-Business'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Business List</xsl:text>
                        </option>
                        <option value="EWHC-Chancery-InsolvencyAndCompanies">
                            <xsl:if test="$court = 'EWHC-Chancery-InsolvencyAndCompanies'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Insolvency &amp; Companies</xsl:text>
                        </option>
                        <option value="EWHC-Chancery-Patents">
                            <xsl:if test="$court = 'EWHC-Chancery-Patents'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Patents Court</xsl:text>
                        </option>
                        <option value="EWHC-Chancery-IPEC">
                            <xsl:if test="$court = 'EWHC-Chancery-IPEC'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Intellectual Propty Ent.</xsl:text>
                        </option>
                        <option value="EWHC-Chancery-Appeals">
                            <xsl:if test="$court = 'EWHC-Chancery-Appeals'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Chancery Appeals</xsl:text>
                        </option>
                    </optgroup>
                    <optgroup label="Family Division">
                        <option value="EWHC-Family">
                            <xsl:if test="$court = 'EWHC-Family'">
                                <xsl:attribute name="selected" />
                            </xsl:if>
                            <xsl:text>Family Division</xsl:text>
                        </option>
                    </optgroup>
                    <option value="EWHC-SeniorCourtsCosts">
                        <xsl:if test="$court = 'EWHC-SeniorCourtsCosts'">
                            <xsl:attribute name="selected" />
                        </xsl:if>
                        <xsl:text>Snr Courts Costs Office</xsl:text>
                    </option>
                    </optgroup>
                    <option value="EWCOP">
                        <xsl:if test="$court = 'EWCOP'">
                            <xsl:attribute name="selected" />
                        </xsl:if>
                        <xsl:text>Court of Protection</xsl:text>
                    </option>
                    <option value="EWFC">
                        <xsl:if test="$court = 'EWFC'">
                            <xsl:attribute name="selected" />
                        </xsl:if>
                        <xsl:text>Family Court</xsl:text>
                    </option>
                </select>
            </div>
        </p>
        <p>
            <div>Judge:</div>
            <div>
                <input name="judge" value="{ $judge }" placeholder="Judge name" />
            </div>
        </p>
        <p>
            <div>From date:</div>
            <div>
                <input type="date" name="from" value="{ $from }" placeholder="Date from" />
            </div>
        </p>
        <p>
            <div>To date:</div>
            <div>
                <input type="date" name="to" value="{ $to }" placeholder="Date to" />
            </div>
        </p>
        <p>
            <div>Order by:</div>
            <div>
                <select name="order" style="width:114pt">
                    <option value="relevance">
                        <xsl:if test="$order = 'relevance'">
                            <xsl:attribute name="selected" />
                        </xsl:if>
                        <xsl:text>Relevance</xsl:text>
                    </option>
                    <option value="date">
                        <xsl:if test="$order = 'date'">
                            <xsl:attribute name="selected" />
                        </xsl:if>
                        <xsl:text>Date (ascending)</xsl:text>
                    </option>
                    <option value="-date">
                        <xsl:if test="$order = '-date'">
                            <xsl:attribute name="selected" />
                        </xsl:if>
                        <xsl:text>Date (descending)</xsl:text>
                    </option>
                </select>
            </div>
        </p>
        <p>
            <input type="submit" value="Search" />
        </p>
    </form>
</xsl:template>

<xsl:template name="right-column">
    <div style="display:flex;justify-content:space-between;padding-bottom:1em">
        <div class="pills">
            <xsl:call-template name="pills" />
        </div>
        <xsl:if test="exists(search:result)">
            <div style="text-align:right">
                <form action="/search" style="display:inline-block">
                    <xsl:if test="$q">
                        <input type="hidden" name="q" value="{ $q }" />
                    </xsl:if>
                    <xsl:if test="$party">
                        <input type="hidden" name="party" value="{ $party }" />
                    </xsl:if>
                    <xsl:if test= "$collection">
                        <input type="hidden" name="collection" value="{ $collection }" />
                    </xsl:if>
                    <xsl:if test="$court">
                        <input type="hidden" name="court" value="{ $court }" />
                    </xsl:if>
                    <xsl:if test="$judge">
                        <input type="hidden" name="judge" value="{ $judge }" />
                    </xsl:if>
                    <xsl:if test="exists($from)">
                        <input type="hidden" name="from" value="{ $from }" />
                    </xsl:if>
                    <xsl:if test="exists($to)">
                        <input type="hidden" name="to" value="{ $to }" />
                    </xsl:if>
                    <xsl:if test="$order">
                        <input type="hidden" name="order" value="{ $order }" />
                    </xsl:if>
                    <input type="hidden" name="page" value="{ $page - 1 }" />
                    <xsl:if test="$page-size ne 20">
                        <input type="hidden" name="page-size" value="{ $page-size }" />
                    </xsl:if>
                    <input type="submit" value="&lt; Previous">
                        <xsl:if test="$page eq 1">
                            <xsl:attribute name="disabled" />
                        </xsl:if>
                    </input>
                </form>
                <span style="display:inline-block;margin-left:1ch">
                    <xsl:text>Page </xsl:text>
                    <xsl:value-of select="$page" />
                </span>
                <form action="/search" style="display:inline-block;margin-left:1ch">
                    <xsl:if test="$q">
                        <input type="hidden" name="q" value="{ $q }" />
                    </xsl:if>
                    <xsl:if test="$party">
                        <input type="hidden" name="party" value="{ $party }" />
                    </xsl:if>
                    <xsl:if test= "$collection">
                        <input type="hidden" name="collection" value="{ $collection }" />
                    </xsl:if>
                    <xsl:if test="$court">
                        <input type="hidden" name="court" value="{ $court }" />
                    </xsl:if>
                    <xsl:if test="$judge">
                        <input type="hidden" name="judge" value="{ $judge }" />
                    </xsl:if>
                    <xsl:if test="exists($from)">
                        <input type="hidden" name="from" value="{ $from }" />
                    </xsl:if>
                    <xsl:if test="exists($to)">
                        <input type="hidden" name="to" value="{ $to }" />
                    </xsl:if>
                    <xsl:if test="$order">
                        <input type="hidden" name="order" value="{ $order }" />
                    </xsl:if>
                    <input type="hidden" name="page" value="{ $page + 1 }" />
                    <xsl:if test="$page-size ne 20">
                        <input type="hidden" name="page-size" value="{ $page-size }" />
                    </xsl:if>
                    <input type="submit" value="Next &gt;">
                        <xsl:if test="count(search:result) lt $page-size">
                            <xsl:attribute name="disabled" />
                        </xsl:if>
                    </input>
                </form>
            </div>
        </xsl:if>
    </div>
    <xsl:apply-templates select="." mode="content" />
</xsl:template>

<xsl:template name="pills">
    <xsl:if test="$q">
        <xsl:call-template name="pill">
            <xsl:with-param name="param" select="'q'" />
            <xsl:with-param name="label" select="'full'" />
            <xsl:with-param name="value" select="$q" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$party">
        <xsl:call-template name="pill">
            <xsl:with-param name="param" select="'party'" />
            <xsl:with-param name="label" select="'party'" />
            <xsl:with-param name="value" select="$party" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$collection">
        <xsl:call-template name="pill">
            <xsl:with-param name="param" select="'collection'" />
            <xsl:with-param name="label" select="'collection'" />
            <xsl:with-param name="value" select="$collection" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$court">
        <xsl:call-template name="pill">
            <xsl:with-param name="param" select="'court'" />
            <xsl:with-param name="label" select="'court'" />
            <xsl:with-param name="value" select="$court" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$judge">
        <xsl:call-template name="pill">
            <xsl:with-param name="param" select="'judge'" />
            <xsl:with-param name="label" select="'judge'" />
            <xsl:with-param name="value" select="$judge" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="exists($from)">
        <xsl:call-template name="pill">
            <xsl:with-param name="param" select="'from'" />
            <xsl:with-param name="label" select="'from'" />
            <xsl:with-param name="value" select="$from" />
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="exists($to)">
        <xsl:call-template name="pill">
            <xsl:with-param name="param" select="'to'" />
            <xsl:with-param name="label" select="'to'" />
            <xsl:with-param name="value" select="$to" />
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="pill">
    <xsl:param name="param" />
    <xsl:param name="label" />
    <xsl:param name="value" />
    <span class="pill">
        <b>
            <xsl:value-of select="$label" />
            <xsl:text>:</xsl:text>
        </b>
        <span>
            <xsl:value-of select="$value" />
        </span>
        <a>
            <xsl:attribute name="href">
                <xsl:sequence select="'/search'" />
                <xsl:variable name="components" as="xs:string*">
                    <xsl:if test="$q and $param != 'q'">
                        <xsl:sequence select="concat( 'q=', encode-for-uri($q) )" />
                    </xsl:if>
                    <xsl:if test="$party and $param != 'party'">
                        <xsl:sequence select="concat( 'party=', encode-for-uri($party) )" />
                    </xsl:if>
                    <xsl:if test="$collection and $param != 'collection'">
                        <xsl:sequence select="concat( 'collection=', encode-for-uri($collection) )" />
                    </xsl:if>
                    <xsl:if test="$court and $param != 'court'">
                        <xsl:sequence select="concat( 'court=', encode-for-uri($court) )" />
                    </xsl:if>
                    <xsl:if test="$judge and $param != 'judge'">
                        <xsl:sequence select="concat( 'judge=', encode-for-uri($judge) )" />
                    </xsl:if>
                    <xsl:if test="exists($from) and $param != 'from'">
                        <xsl:sequence select="concat( 'from=', encode-for-uri(string($from)) )" />
                    </xsl:if>
                    <xsl:if test="exists($to) and $param != 'to'">
                        <xsl:sequence select="concat( 'to=', encode-for-uri(string($to)) )" />
                    </xsl:if>
                    <xsl:if test="$order">
                        <xsl:sequence select="concat( 'order=', encode-for-uri($order) )" />
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="exists($components)">
                    <xsl:sequence select="'?'" />
                    <xsl:sequence select="string-join($components, '&amp;')" />
                </xsl:if>
            </xsl:attribute>
            <xsl:text>⨉</xsl:text>
        </a>
    </span>
</xsl:template>

<xsl:template match="search:response" mode="content">
    <xsl:apply-templates />
    <xsl:if test="empty(search:result)">
        <p>No results match your query.</p>
    </xsl:if>
</xsl:template>

<xsl:template match="search:result">
    <section class="search-result" data-uri="{ substring-before(@uri, '.xml') }">
        <div>
            <a href="{ substring-before(@uri, '.xml') }?highlight={ $q }">
                <span>
                    <xsl:value-of select="search:extracted/akn:FRBRname/@value" />
                </span>
                <xsl:text>, </xsl:text>
                <span>
                    <xsl:value-of select="search:extracted/akn:neutralCitation[1]" />
                </span>
            </a>
        </div>
        <xsl:if test="exists(search:snippet/search:match/node())">
            <ul class="snippets">
                <xsl:apply-templates />
            </ul>
        </xsl:if>
    </section>
</xsl:template>

<xsl:template match="search:snippet">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="search:match">
    <xsl:if test="exists(child::node())">
        <li class="snippet">
            <xsl:apply-templates />
        </li>
    </xsl:if>
</xsl:template>

<xsl:template match="search:highlight">
    <mark>
        <xsl:apply-templates />
    </mark>
</xsl:template>

<xsl:template match="search:extracted" />

<xsl:template match="search:metrics" />

</xsl:stylesheet>
