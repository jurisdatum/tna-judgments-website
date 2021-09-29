<?xml version="1.0" encoding="utf-8"?>

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xpath-default-namespace="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:math="http://www.w3.org/1998/Math/MathML"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="html math xs">

<xsl:import href="page.xsl" />

<xsl:param name="collection" as="xs:string" />
<xsl:param name="year" as="xs:string" />
<xsl:param name="number" as="xs:string" />

<xsl:strip-space elements="*" />

<xsl:template name="title">
	<xsl:value-of select="/akomaNtoso/judgment/meta/identification/FRBRWork/FRBRname/@value" />
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
	<xsl:apply-templates select="/" />
</xsl:template>

<xsl:template match="judgment">
	<article id="judgment">
		<xsl:apply-templates />
		<xsl:call-template name="footnotes" />
	</article>
</xsl:template>

<xsl:template match="meta" />

<xsl:template name="style">
	<xsl:analyze-string select="/akomaNtoso/judgment/meta/presentation/html:style" regex="(judgment|body) (.+)">
		<xsl:matching-substring>
			<xsl:text>#judgment </xsl:text>
			<xsl:value-of select="regex-group(2)" />
		</xsl:matching-substring>
		<xsl:non-matching-substring>
			<xsl:analyze-string select="." regex="(.+)">
				<xsl:matching-substring>
					<xsl:text>#judgment </xsl:text>
					<xsl:value-of select="regex-group(1)" />
				</xsl:matching-substring>
				<xsl:non-matching-substring>
					<xsl:value-of select="." />
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:non-matching-substring>
	</xsl:analyze-string>
<xsl:text>
#judgment .tab { display: inline-block; width: 0.25in }
#judgment section { position: relative }
#judgment h2 { font-size: inherit; font-weight: normal }
#judgment h2.floating { position: absolute; margin-top: 0 }
#judgment .num { display: inline-block; padding-right: 1em }
#judgment td { position: relative; min-width: 2em; padding-left: 1em; padding-right: 1em }
#judgment td > .num { left: -2em }
#judgment table { margin: 0 auto }
#judgment .fn { vertical-align: super; font-size: small }
#judgment .footnote > p > .marker { vertical-align: super; font-size: small }
</xsl:text>
</xsl:template>

<xsl:template name="class">
	<xsl:attribute name="class">
		<xsl:value-of select="local-name()" />
		<xsl:if test="@class">
			<xsl:text> </xsl:text>
			<xsl:value-of select="@class" />
		</xsl:if>
	</xsl:attribute>
</xsl:template>

<xsl:template match="level | paragraph | blockContainer">
	<section>
		<xsl:call-template name="class" />
		<xsl:apply-templates select="@* except @class" />
		<xsl:if test="num | heading">
			<h2>
				<xsl:if test="not(heading)">
					<xsl:attribute name="class">floating</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="num | heading" />
			</h2>
		</xsl:if>
		<xsl:apply-templates select="* except (num, heading)" />
	</section>
</xsl:template>

<xsl:template match="p | span | a">
	<xsl:element name="{ local-name() }">
		<xsl:apply-templates select="@*" />
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

<xsl:template match="num | heading">
	<span>
		<xsl:call-template name="class" />
		<xsl:apply-templates select="@* except @class" />
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="neutralCitation | courtType | docketNumber | docDate">
	<span>
		<xsl:call-template name="class" />
		<xsl:apply-templates select="@* except @class" />
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="party | judge | lawyer">
	<span>
		<xsl:call-template name="class" />
		<xsl:apply-templates select="@* except @class" />
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="img">
	<xsl:element name="{ local-name() }">
		<xsl:apply-templates select="@*" />
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

<xsl:template match="br">
	<xsl:element name="{ local-name() }">
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

<xsl:template match="date">
	<span>
		<xsl:call-template name="class" />
		<xsl:apply-templates select="@* except @class" />
		<xsl:apply-templates />
	</span>
</xsl:template>


<!-- tables -->

<xsl:template match="table | tr | td">
	<xsl:element name="{ local-name() }">
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>


<!-- markers and attributes -->

<xsl:template match="marker[@name='tab']">
	<span class="tab"> </span>
</xsl:template>

<xsl:template match="@class | @style | @src | @href | @title">
	<xsl:copy />
</xsl:template>

<xsl:template match="@refersTo | @date | @as" />

<xsl:template match="@*" />


<!-- footnotes -->

<xsl:template match="authorialNote">
	<span class="fn">
		<xsl:value-of select="@marker" />
	</span>
</xsl:template>

<xsl:template name="footnotes">
	<xsl:variable name="footnotes" select="//authorialNote" />
	<xsl:if test="$footnotes">
		<hr style="margin-top:2em" />
		<footer>
			<xsl:apply-templates select="$footnotes" mode="footnote" />
		</footer>
	</xsl:if>
</xsl:template>

<xsl:template match="authorialNote" mode="footnote">
	<div class="footnote">
		<xsl:apply-templates />
	</div>
</xsl:template>

<xsl:template match="authorialNote/p[1]">
	<xsl:element name="{ local-name() }">
		<xsl:apply-templates select="@*" />
		<span class="marker">
			<xsl:value-of select="../@marker" />
		</span>
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>


<!-- math -->

<xsl:template match="math:*">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates />
	</xsl:copy>
</xsl:template>


<!-- highlights -->

<xsl:template match="html:mark">
	<xsl:copy-of select="." />
</xsl:template>

</xsl:transform>
