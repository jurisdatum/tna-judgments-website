<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

<xsl:output method="html" encoding="utf-8" indent="yes" include-content-type="no" />
<!-- doctype-system="about:legacy-compat" -->

<xsl:param name="q" as="xs:string?" select="()" />
<xsl:param name="collection" as="xs:string?" select="()" />
<xsl:param name="year" as="xs:string?" select="()" />

<xsl:template name="page">
	<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
</xsl:text>
	<html>
        <head>
			<meta charset="utf-8" />
            <title>
                <xsl:call-template name="title" />
            </title>
            <style>
:root { --color: lavender }
body { margin: 0 }

body > header { position: fixed; top: 0; left: 0; width: 100%; z-index: 100; padding: 0 1in 12pt 1in; background-color: var(--color) }
body > header > div { display:flex; width:calc(100% - 2in); justify-content: space-between; align-items: baseline }
#search-form, #lookup-form { margin-bottom: 0 }
#search-form > input[name='q'] { width: 50ch }
#lookup-form > input[name='cite'] { width: 30ch }

body > #content { margin-top: 128px; padding: 0 1in 12pt 1in }
#left-column { }
#middle-column, #right-column { padding-left: 2em }
#left-column > h2, #middle-column > h2, #right-column > h2 { margin-top: 0 } 
a { color: inherit; text-decoration: none }
a:hover { text-decoration: underline }
body > header > div > h1 > a:hover { text-decoration: none }

ul.collections, ul.years, ul.judgments { padding: 0; list-style-type: none }
.collections > li > a, .years > li > a { display: inline-block; padding: 2pt 6pt }
.judgments > li > a { display: inline-block; padding: 3pt 6pt }
.collections > li:hover, .years > li:hover, .judgments > li:hover { background-color: var(--color) }
.collections > li.highlight, .years > li.highlight, .judgments > li.highlight { background-color: var(--color) }
.collections > li > a:hover, .years > li > a:hover, .judgments > li > a:hover { text-decoration: none }
.total { margin-top: 2em; margin-left: 6pt; font-size: smaller }

.search-result > div > a { display: inline-block; padding: 2pt 6pt }
.search-result > div > a:hover { text-decoration: none; background-color: var(--color) }

<xsl:call-template name="style" />
            </style>
        </head>
        <body>
            <header>
                <div>
                    <h1>
                        <a href="/">
                            <xsl:text>UK Judgments</xsl:text>
                        </a>
                    </h1>
                    <xsl:call-template name="search-form" />
                </div>
                <div>
                    <div class="breadcrumbs">
                        <xsl:call-template name="breadcrumbs" />
                    </div>
                    <xsl:call-template name="lookup-form" />
                </div>
            </header>
            <div id="content">
                <xsl:call-template name="content" />
            </div>
        </body>
	</html>
</xsl:template>

<xsl:template name="title">
    <xsl:text>Judgments</xsl:text>
</xsl:template>

<xsl:template name="style" />

<xsl:template name="search-form">
    <form id="search-form" action="/search">
        <input type="text" name="q" value="{ $q }" autofocus="true" placeholder="search terms" />
        <input type="submit" value="Search" />
        <select name="scope">
            <option value="full">Full Text</option>
            <option value="party">Party Name</option>
        </select>
        <select name="collection">
            <option value="">
                <xsl:text>in all documents</xsl:text>
            </option>
            <xsl:if test="$collection"> <!-- might be = '' -->
                <option value="{ $collection }">
                    <xsl:if test="not($year)">
                        <xsl:attribute name="selected" />
                    </xsl:if>
                    <xsl:text>in </xsl:text>
                    <xsl:value-of select="$collection" />
                </option>
                <xsl:if test="$year">
                    <option value="{ $collection }/{ $year }" selected="">
                        <xsl:text>in </xsl:text>
                        <xsl:value-of select="$collection" />
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$year" />
                    </option>
                </xsl:if>
            </xsl:if>
        </select>
    </form>
</xsl:template>

<xsl:template name="breadcrumbs">
    <xsl:text>&#160;</xsl:text>
</xsl:template>

<xsl:template name="lookup-form">
    <form id="lookup-form" action="/lookup">
        <input type="text" name="cite" placeholder="neutral citation" />
        <input type="submit" value="Lookup" />
    </form>
</xsl:template>


<xsl:template name="content">
    <xsl:call-template name="two-columns" />
</xsl:template>

<xsl:template name="two-columns">
    <div style="display:flex">
        <div id="left-column">
            <xsl:call-template name="left-column" />
        </div>
        <div id="right-column">
            <xsl:call-template name="right-column" />
        </div>
    </div>
</xsl:template>

<xsl:template name="left-column" />

<xsl:template name="right-column" />

<xsl:template match="/" mode="row">
    <xsl:variable name="uri" as="xs:string" select="akomaNtoso/judgment/meta/identification/FRBRWork/FRBRthis/@value" />
    <xsl:variable name="name" as="xs:string" select="akomaNtoso/judgment/meta/identification/FRBRWork/FRBRname/@value" />
    <xsl:variable name="cite" as="xs:string" select="(akomaNtoso/judgment/header//neutralCitation)[1]" />
    <li>
        <a href="/{ $uri }">
            <xsl:value-of select="$name" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$cite" />
        </a>
    </li>
</xsl:template>

</xsl:stylesheet>
