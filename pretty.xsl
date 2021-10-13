<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" />

<xsl:template match="/">
    <html>
        <head>
            <style>
body { font-family: monospace; font-size: 11pt }
.html-comment { color: rgb(35, 110, 37) }
summary::marker { width: 1em; color: gray }
.expandable-children { margin-left: 1em }
.no-children { margin-left: 1em }
.expandable-closing { margin-left: 1em }
.start-tag, .end-tag { color: rgb(136, 18, 128) }
.attribute-name { color: rgb(153, 69, 0) }
.attribute-value { color: rgb(26, 26, 166) }
            </style>
        </head>
        <body>
            <div class="html-comment">
                <xsl:text>&lt;?xml version="1.0" encoding="utf-8"?&gt;</xsl:text>
            </div>
            <xsl:apply-templates />
        </body>
    </html>
</xsl:template>

<xsl:template match="*">
    <div class="no-children">
        <span class="start-tag">
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="name(.)" />
        </span>
        <xsl:apply-templates select="@*" />
        <span class="end-tag">
            <xsl:text>/&gt;</xsl:text>
        </span>
    </div>
</xsl:template>

<xsl:template match="*[node()]">
    <div class="no-children">
        <span class="start-tag">
            <xsl:text>&lt;</xsl:text>
            <xsl:value-of select="name(.)" />
        </span>
        <xsl:apply-templates select="@*" />
        <span class="start-tag">
            <xsl:text>&gt;</xsl:text>
        </span>
        <span class="text">
            <xsl:value-of select="." />
        </span>
        <span class="end-tag">
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="name(.)" />
            <xsl:text>&gt;</xsl:text>
        </span>
    </div>
</xsl:template>

<xsl:template match="*[* or string-length(.) &gt; 50]">
    <div>
        <details open="" class="expandable-body">
            <summary class="expandable-opening">
                <span class="start-tag">
                    <xsl:text>&lt;</xsl:text>
                    <xsl:value-of select="name(.)" />
                </span>
                <xsl:apply-templates select="@*" />
                <span class="start-tag">
                    <xsl:text>&gt;</xsl:text>
                </span>
            </summary>
            <div class="expandable-children">
                <xsl:apply-templates />
            </div>
            <span class="expandable-closing">
                <span class="end-tag">
                    <xsl:text>&lt;/</xsl:text>
                    <xsl:value-of select="name(.)" />
                    <xsl:text>&gt;</xsl:text>
                </span>
            </span>
        </details>
    </div>
</xsl:template>

<xsl:template match="@*">
    <xsl:text> </xsl:text>
    <span class="attribute-name">
        <xsl:value-of select="name(.)" />
        <xsl:text>=</xsl:text>
        <xsl:text>"</xsl:text>
    </span>
    <span class="attribute-value">
        <xsl:value-of select="." />
    </span>
    <span class="attribute-name">
        <xsl:text>"</xsl:text>
    </span>
</xsl:template>

<xsl:template match="text()">
    <xsl:if test="normalize-space(.)">
        <xsl:value-of select="." />
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
