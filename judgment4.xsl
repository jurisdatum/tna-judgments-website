<?xml version="1.0" encoding="utf-8"?>

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xpath-default-namespace="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:math="http://www.w3.org/1998/Math/MathML"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="html math xs">

<xsl:import href="judgment2.xsl" />

<xsl:output method="html" encoding="utf-8" indent="yes" include-content-type="no" />

<xsl:variable name="title" as="xs:string?">
	<xsl:sequence select="/akomaNtoso/judgment/meta/identification/FRBRWork/FRBRname/@value" />
</xsl:variable>

<xsl:template match="/">
	<html>
		<head>
			<meta charset="utf-8" />
			<title>
				<xsl:value-of select="$title" />
			</title>
			<link rel="stylesheet" href="https://caselaw.nationalarchives.gov.uk/static/css/main.css" />
		</head>
		<body>
			<xsl:apply-templates />
		</body>
	</html>
</xsl:template>

</xsl:transform>
