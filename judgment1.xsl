<?xml version="1.0" encoding="utf-8"?>

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xpath-default-namespace="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:math="http://www.w3.org/1998/Math/MathML"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="html math xs">

<xsl:import href="page.xsl" />
<xsl:import href="judgment0.xsl" />

<xsl:param name="collection" as="xs:string" />
<xsl:param name="year" as="xs:string" />
<xsl:param name="number" as="xs:string" />

<xsl:template name="title">
	<xsl:value-of select="$title" />
</xsl:template>

<xsl:template name="breadcrumbs">
	<a href="/{ $collection }">
		<xsl:value-of select="$collection" />
	</a>
	<span> / </span>
	<a href="/{ $collection }/{ $year }">
		<xsl:value-of select="$year" />
	</a>
	<span> / </span>
	<span>
		<xsl:value-of select="$number" />
	</span>
</xsl:template>

<xsl:template name="content">
	<xsl:apply-templates select="/akomaNtoso/judgment" />
</xsl:template>

<xsl:template name="akomaNtoso">
	<xsl:apply-templates />
</xsl:template>


<!-- highlights -->

<xsl:template match="html:mark">
	<xsl:copy-of select="." />
</xsl:template>

</xsl:transform>
