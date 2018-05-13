<?xml version="1.0" encoding="UTF-8"?>
<!--
	Title: XSL-FO for Technical Whitepaper from code.kx.com
	Author: Stephen Taylor • stephen@kx.com

	Source is DocBook 5 XML converted by pandoc from MkDocs (Markdown) source files.
	See github.com/kxsystems/docs

	SURVEY: this version to identify all DocBook 5 elements in the XML

	Result is XSL-FO source for RenderX conversion to PDF.

	To do
	=====
	-[-] tables
	-[x] links
	-[ ] admonition continuation paras
	-[x] Author/s para
	-[x] WP images
	-[-] article images
	-[ ] .foo
	-[x] cover-page section
	-[x] table of contents
	-[-] metadata
	-[x] A4/US letter choice
	-[ ] admonition icons
	-[x] single-multipage
	-[x] date
	-[ ] embedded table of contents
-->

<xsl:stylesheet version="1.0"
				xmlns:db="http://docbook.org/ns/docbook"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
				xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >

    <xsl:variable name="article-title" select="/db:article/db:info/db:title"/>

    <xsl:variable name="paper-size">A4</xsl:variable>
    <!-- typefaces -->
    <xsl:variable name="display-type">Proxima Nova</xsl:variable>
    <xsl:variable name="body-type">STIX2</xsl:variable>
    <xsl:variable name="code-type">Pragmata Pro</xsl:variable>
    <xsl:variable name="kx-blue">#0070cd</xsl:variable>
    <!-- whitepaper graphics  (URLs are relative to XML, not XSL) -->
    <xsl:variable name="big-white-kx">url(../img/kx-cover.png)</xsl:variable>
    <xsl:variable name="diamonds-bl">url(../img/diamond-bottom-left-white.png)</xsl:variable>
    <xsl:variable name="diamonds-tr">url(../img/diamond-white.png)</xsl:variable>
    <xsl:variable name="about-time">url(../img/its-about-time.png)</xsl:variable>

	<!-- An XML compiled from multiple MDs will have multiple H1s -->
	<!-- <xsl:variable name="source" select="count(/db:article/db:section)"/> -->
	<xsl:variable name="h1s" select="/db:article/db:section/db:title"/>
	<xsl:variable name="h2s" select="/db:article/db:section/db:section/db:title"/>

	<xsl:variable name="source">
		<xsl:choose>
			<xsl:when test="count($h1s)=1">single</xsl:when>
			<xsl:otherwise>multiple</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

    <xsl:template match="db:article">

    	<xsl:variable name="page-width">
    		<xsl:choose>
    			<xsl:when test="$paper-size='A4'">210mm</xsl:when>
    			<xsl:when test="$paper-size='US Letter'">8.5in</xsl:when>
    		</xsl:choose>
    	</xsl:variable>
    	<xsl:variable name="page-height">
    		<xsl:choose>
    			<xsl:when test="$paper-size='A4'">297mm</xsl:when>
    			<xsl:when test="$paper-size='US Letter'">11in</xsl:when>
    		</xsl:choose>
    	</xsl:variable>

    	<fo:root>

    		<!-- page layout -->
    		<fo:layout-master-set>
    			<fo:simple-page-master  master-name="cover-page"
					    				page-width="{$page-width}" page-height="{$page-height}"
    				>
					<fo:region-body 	margin-top="0"	margin-bottom="0"
										margin-left="0"	margin-right="0"
										background-color="#eeeded"
										/>
				</fo:simple-page-master>
    			<fo:simple-page-master  master-name="toc"
					    				page-width="{$page-width}" page-height="{$page-height}"
										margin-top="30pt" 	margin-bottom="30pt"
										margin-left="45pt" 	margin-right="45pt"
										>
					<fo:region-body 	margin-top="48pt"	margin-bottom="32pt"
										margin-left="60pt"	margin-right="60pt"
										/>
					<fo:region-before	extent="30pt"/>
					<fo:region-after	extent="30pt"/>
				</fo:simple-page-master>
    			<fo:simple-page-master  master-name="standard-page"
					    				page-width="{$page-width}" page-height="{$page-height}"
										margin-top="30pt" 	margin-bottom="30pt"
										margin-left="45pt" 	margin-right="45pt"
										>
					<fo:region-body 	margin-top="48pt"	margin-bottom="32pt"
										margin-left="40pt"	margin-right="40pt"
										/>
					<fo:region-before	extent="30pt"/>
					<fo:region-after	extent="30pt"/>
				</fo:simple-page-master>
			</fo:layout-master-set>


			<!-- article content **************************************************************** -->
			<fo:page-sequence   master-reference="standard-page"
								font-family="{$body-type}"
								language="en" country="gb"
								>
				<fo:static-content flow-name="xsl-region-before">
					<!-- <xsl:call-template name="page-header"/> -->
				</fo:static-content>

				<!-- main text block -->
				<fo:flow flow-name="xsl-region-body">
					<xsl:apply-templates/>
				</fo:flow>

			</fo:page-sequence>

		</fo:root>

	</xsl:template>

	<!-- blocks -->
	<xsl:template match="
		db:author
		|db:date
		|db:figure
		|db:itemizedlist
		|db:listitem
		|db:literallayout
		|db:mediaobject
		|db:orderedlist
		|db:para
		|db:programlisting
		|db:row
		|db:term
		|db:title
		|db:variablelist
		|db:varlistentry
		|db:authorgroup
		|db:colspec
		|db:i
		|db:imagedatadb
		|db:imageobject
		|db:info
		|db:informaltable
		|db:inlinemediaobject
		|db:section
		|db:tbody
		|db:textobject
		|db:tgroup
		|db:thead
		">
		<fo:block>
			<fo:inline color="green"><xsl:value-of select="name()"/></fo:inline>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- inlines -->
	<xsl:template match="
		">
		<fo:inline color="blue"><xsl:value-of select="name()"/></fo:inline>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- containers -->
	<xsl:template match="
		">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- unmatched -->
	<xsl:template match="*">
		<fo:block color="red">Unmatched: <xsl:value-of select="name()"/></fo:block>
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>