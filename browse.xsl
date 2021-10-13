<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

<xsl:import href="page.xsl" />

<xsl:param name="collections" as="xs:string+" />
<xsl:param name="collection" as="xs:string" />
<xsl:param name="year" as="xs:string" />
<xsl:param name="docs" as="document-node()*" />
<xsl:param name="first-year" as="xs:integer" />
<xsl:param name="last-year" as="xs:integer" />
<xsl:param name="total" as="xs:integer" />

<xsl:template name="title">
    <xsl:value-of select="$collection" />
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$year" />
</xsl:template>

<xsl:template name="breadcrumbs">
    <a href="/">/</a>
    <xsl:text> </xsl:text>
	<a href="/{ $collection }">
		<xsl:value-of select="$collection" />
	</a>
	<xsl:text> / </xsl:text>
    <xsl:value-of select="$year" />
</xsl:template>

<xsl:template name="content">
    <xsl:call-template name="three-columns" />
</xsl:template>

<xsl:template name="three-columns">
    <div style="display:flex">
        <div id="left-column">
            <xsl:call-template name="left-column" />
        </div>
        <div id="middle-column">
            <xsl:call-template name="middle-column" />
        </div>
        <div id="right-column">
            <xsl:call-template name="right-column" />
        </div>
    </div>
</xsl:template>

<xsl:template name="left-column">
    <h2>Collections</h2>
    <ul class="collections">
        <xsl:for-each select="$collections">
            <li>
                <xsl:if test=". = $collection">
                    <xsl:attribute name="class">highlight</xsl:attribute>
                </xsl:if>
                <a href="/{ . }">
                    <xsl:value-of select="." />
                </a>
            </li>
        </xsl:for-each>
    </ul>
    <p class="total">
        <xsl:value-of select="$total" />
    </p>
</xsl:template>

<xsl:template name="middle-column">
    <h2>Years</h2>
    <ul class="years">
        <xsl:for-each select="$first-year to $last-year">
            <xsl:sort select="." order="descending" data-type="number" />
            <li>
                <xsl:if test="string(.) = $year">
                    <xsl:attribute name="class">highlight</xsl:attribute>
                </xsl:if>
                <a href="/{ $collection }/{ . }">
                    <xsl:value-of select="." />
                </a>
            </li>
        </xsl:for-each>
    </ul>
</xsl:template>

<xsl:template name="right-column">
    <h2>
        <xsl:text>All judgments in </xsl:text>
        <xsl:value-of select="$collection" />
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$year" />
    </h2>
    <xsl:if test="empty($docs)">
        <p>none</p>
    </xsl:if>
    <ul class="judgments">
        <xsl:apply-templates select="$docs" mode="row" />
    </ul>
</xsl:template>

</xsl:stylesheet>
