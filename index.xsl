<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

<xsl:import href="page.xsl" />

<xsl:param name="collections" as="xs:string+" />
<xsl:param name="total" as="xs:integer" />
<xsl:param name="docs" as="document-node()*" />

<xsl:template name="breadcrumbs">
    <a href="/">/</a>
</xsl:template>

<xsl:template name="left-column">
    <h2>Collections</h2>
    <ul class="collections">
        <xsl:for-each select="$collections">
            <li>
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

<xsl:template name="right-column">
    <h2>Recent judgments</h2>
    <ul class="judgments">
        <xsl:apply-templates select="$docs" mode="row" />
    </ul>
</xsl:template>

</xsl:stylesheet>
