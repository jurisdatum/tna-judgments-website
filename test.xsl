<?xml version="1.0" encoding="utf-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
    exclude-result-prefixes="xs svrl">

<xsl:import href="page.xsl" />

<xsl:param name="collection" as="xs:string" />
<xsl:param name="year" as="xs:string" />
<xsl:param name="number" as="xs:string" />

<xsl:template name="breadcrumbs">
    <a href="/">/</a>
    <xsl:text> </xsl:text>
	<a href="/{ $collection }">
		<xsl:value-of select="$collection" />
	</a>
	<span> / </span>
	<a href="/{ $collection }/{ $year }">
		<xsl:value-of select="$year" />
	</a>
	<span> / </span>
	<a href="/{ $collection }/{ $year }/{ $number }">
		<xsl:value-of select="$number" />
    </a>
	<span> / test</span>
</xsl:template>

<xsl:template match="svrl:schematron-output">
    <xsl:call-template name="page" />
</xsl:template>

<xsl:template name="content">
    <h2 style="margin-left:6pt">Schematron output</h2>
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="svrl:failed-assert">
    <p>
        <xsl:apply-templates />
    </p>
</xsl:template>

<xsl:template match="svrl:successful-report">
    <p>
        <xsl:apply-templates />
    </p>
</xsl:template>

<xsl:template match="@role">
    <xsl:attribute name="class">
        <xsl:value-of select="." />
    </xsl:attribute>
</xsl:template>

<xsl:template match="svrl:text">
    <span>
        <xsl:choose>
            <xsl:when test="parent::svrl:failed-assert">
                <xsl:attribute name="style">background-color:#f4cccc;padding:3pt 6pt</xsl:attribute>
            </xsl:when>
            <xsl:when test="parent::svrl:successful-report/@role = 'warning'">
                <xsl:attribute name="style">background-color:#fce5cd;padding:3pt 6pt</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="style">padding:3pt 6pt</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates />
    </span>
</xsl:template>

<xsl:template match="svrl:diagnostic-reference" />

</xsl:transform>
