<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:search="http://marklogic.com/appservices/search"
    xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
    exclude-result-prefixes="xs search akn">

<xsl:import href="page.xsl" />

<xsl:param name="q" as="xs:string" />
<xsl:param name="scope" as="xs:string" />
<xsl:param name="collection" as="xs:string?" />
<xsl:param name="page" as="xs:integer" select="1" />
<xsl:param name="page-size" as="xs:integer" select="20" />

<xsl:template name="title">
    <xsl:value-of select="$q" />
</xsl:template>

<xsl:template name="breadcrumbs">
    <xsl:choose>
        <xsl:when test="matches($collection, '/\d+$')">
            <xsl:variable name="parts" as="xs:string+" select="tokenize($collection, '/')" />
            <xsl:variable name="parent" as="xs:string" select="string-join($parts[position() lt last()], '/')" />
            <xsl:variable name="year" as="xs:string" select="$parts[last()]" />
            <a href="/{ $parent }">
                <xsl:value-of select="$parent" />
            </a>
            <xsl:text> / </xsl:text>
            <a href="/{ $parent }/{ $year }">
                <xsl:value-of select="$year" />
            </a>
        </xsl:when>
        <xsl:when test="$collection">
            <a href="/{ $collection }">
                <xsl:value-of select="$collection" />
            </a>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>&#160;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="content">
    <div style="display:flex;justify-content:space-between">
        <h2 style="margin-top:0">
            <span>
                <xsl:text>Search results for "</xsl:text>
                <xsl:value-of select="$q" />
                <xsl:text>" (</xsl:text>
                <xsl:value-of select="$scope" />
                <xsl:if test= "$collection">    <!-- might be = '' -->
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$collection" />
                </xsl:if>
                <xsl:text>)</xsl:text>
            </span>
        </h2>
        <div>
            <form action="/search" style="display:inline-block">
                <input type="hidden" name="q" value="{ $q }" />
                <input type="hidden" name="scope" value="{ $scope }" />
                <xsl:if test= "$collection">    <!-- might be = '' -->
                    <input type="hidden" name="collection" value="{ $collection }" />
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
            <form action="/search" style="display:inline-block;margin-left:1em">
                <input type="hidden" name="q" value="{ $q }" />
                <input type="hidden" name="scope" value="{ $scope }" />
                <xsl:if test= "$collection">    <!-- might be = '' -->
                    <input type="hidden" name="collection" value="{ $collection }" />
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
    </div>
    <xsl:apply-templates select="." />
</xsl:template>

<xsl:template match="search:response">
    <xsl:apply-templates />
    <xsl:if test="empty(search:result)">
        <p>No results match your query.</p>
    </xsl:if>
</xsl:template>

<xsl:template match="search:result">
    <section class="search-result" data-uri="{ substring-before(@uri, '.xml') }">
        <div>
            <a href="{ substring-before(@uri, '.xml') }?highlight={ $q }&amp;scope={ $scope }">
                <span>
                    <xsl:value-of select="search:extracted/akn:FRBRname/@value" />
                </span>
                <xsl:text>, </xsl:text>
                <span>
                    <xsl:value-of select="search:extracted/akn:neutralCitation" />
                </span>
            </a>
        </div>
        <ul title="snippets">
            <xsl:apply-templates />
        </ul>
    </section>
</xsl:template>

<xsl:template match="search:snippet">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="search:match">
    <li>
        <xsl:apply-templates />
    </li>
</xsl:template>

<xsl:template match="search:highlight">
    <mark>
        <xsl:apply-templates />
    </mark>
</xsl:template>

<xsl:template match="search:extracted" />

<xsl:template match="search:metrics" />

</xsl:stylesheet>
