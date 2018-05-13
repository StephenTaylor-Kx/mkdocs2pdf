<?xml version="1.0" encoding="UTF-8"?>
<!--
	Title: XSL-FO for Technical Whitepaper from code.kx.com
	Author: Stephen Taylor • stephen@kx.com

	Source is DocBook 5 XML converted by pandoc from MkDocs (Markdown) source files.
	See github.com/kxsystems/docs

	Result is XSL-FO source for RenderX conversion to PDF.

	To do
	=====
	-[x] tables
	-[x] links
	-[x] admonitions
	-[x] Author/s para
	-[x] WP images
	-[x] article images
	-[x] cover-page section
	-[x] table of contents
	-[x] embed metadata
	-[x] A4/US letter choice
	-[ ] admonition icons
	-[x] single-multipage
	-[x] date
	-[-] embed table of contents
	-[x] numbering on orderedlists
	-[ ] FontAwesome icons
	-[x] links within code.kx.com
-->

<xsl:stylesheet version="1.0"
				xmlns:db="http://docbook.org/ns/docbook"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
				xmlns:rx="http://www.renderx.com/XSL/Extensions"
				xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >

    <!-- metadata -->
    <xsl:variable name="article-title" select="/db:article/db:info/db:title"/>
    <xsl:variable name="author-count" select="count(/db:article/db:info/db:authorgroup/db:author)"/>
    <xsl:variable name="author-name">
    	<xsl:choose>
    		<xsl:when test="$author-count=1">
    			<xsl:value-of select="/db:article/db:info/db:authorgroup/db:author[1]"/>
    		</xsl:when>
    		<xsl:when test="$author-count=2">
    			<xsl:value-of select="/db:article/db:info/db:authorgroup/db:author[1]"/>
    			&amp;
    			<xsl:value-of select="/db:article/db:info/db:authorgroup/db:author[2]"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<!-- improve with recursive call-template -->
    			<xsl:value-of select="/db:article/db:info/db:authorgroup/db:author[1]"/>
    			<fo:inline font-style="italic">et al.</fo:inline>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:variable>
    <xsl:variable name="article-keywords" select="/db:article/db:info/db:keywords"/>

    <!-- type and layout -->
    <xsl:variable name="paper-size">A4</xsl:variable>

    <xsl:variable name="display-type">Proxima Nova</xsl:variable>
    <xsl:variable name="body-type">STIX2</xsl:variable>
    <xsl:variable name="code-type">Pragmata Pro</xsl:variable>
    <xsl:variable name="icon-type">Material Icons</xsl:variable>
    <xsl:variable name="kx-blue">#0070cd</xsl:variable>
    <!-- whitepaper graphics  (URLs are relative to XML, not XSL) -->
    <xsl:variable name="big-white-kx">url(../img/kx-cover.png)</xsl:variable>
    <xsl:variable name="diamonds-bl">url(../img/diamond-bottom-left-white.png)</xsl:variable>
    <xsl:variable name="diamonds-tr">url(../img/diamond-white.png)</xsl:variable>
    <xsl:variable name="about-time">url(../img/its-about-time.png)</xsl:variable>
    <!-- Material icons: see template admonition-icons -->

    <!-- site URL: prefix for internal hyperlinks -->
    <xsl:variable name="site-url">http://code.kx.com/q</xsl:variable>

	<!-- An XML compiled from multiple MDs will have multiple H1s -->
	<!-- <xsl:variable name="source" select="count(/db:article/db:section)"/> -->
	<xsl:variable name="h1s" select="/db:article/db:section/db:title"/>
	<xsl:variable name="h2s" select="/db:article/db:section/db:section[@xml:id!='author' and @xml:id!='authors']/db:title"/>
	<xsl:variable name="h3s" select="/db:article/db:section/db:section/db:section/db:title"/>
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

			<!-- PDF embedded metadata -->
			<rx:meta-info>
				<rx:meta-field name="author" value="{$author-name}"/>
				<rx:meta-field name="creator" value="Kx Systems"/>
				<rx:meta-field name="title" value="$article-title"/>
				<!-- <rx:meta-field name="subject" value=""/> -->
				<rx:meta-field name="keywords" value="Kx, Kx Systems, kdb+, {$article-keywords}"/>
			</rx:meta-info>

			<!-- embedded outline -->
<!-- 
			The internal-destination value must be an @id but 
			title elements have their @id generated (for the ToC)
			so enclose each section in a fo:block wrapper and bequeath it the section's @xml:id
 -->			

			<rx:outline>
				<xsl:choose>
					<xsl:when test="$source='single'">
						<xsl:for-each select="$h2s">
							<rx:bookmark internal-destination="{../@xml:id}">
								<rx:bookmark-label><xsl:value-of select="."/></rx:bookmark-label>
							</rx:bookmark>
<!-- 							<xsl:for-each select="db:section/db:title">
								<rx:bookmark internal-destination="{../@xml:id}">
									<rx:bookmark-label><xsl:value-of select="."/></rx:bookmark-label>
								</rx:bookmark>
							</xsl:for-each>
 -->						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="$h1s">
							<rx:bookmark internal-destination="{../@xml:id}">
								<rx:bookmark-label><xsl:value-of select="."/></rx:bookmark-label>
							</rx:bookmark>
<!-- 							<xsl:for-each select="db:section/db:title">
								<rx:bookmark internal-destination="{../@xml:id}">
									<rx:bookmark-label><xsl:value-of select="."/></rx:bookmark-label>
								</rx:bookmark>
							</xsl:for-each>
 -->						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</rx:outline>




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


			<!-- cover page ****************************************************************** -->
			<fo:page-sequence   master-reference="cover-page"
								font-family="{$body-type}"
								initial-page-number="1" language="en" country="gb"
								>
				<fo:flow flow-name="xsl-region-body">
					<!-- diamonds top right -->
					<fo:block-container
						absolute-position="absolute"
						top="0mm" right="0mm"
						width="2in" height="2in"
						>
						<fo:block text-align="right">
							<fo:external-graphic src="{$diamonds-tr}" 
								content-width="40mm"
								scaling="uniform"
								/>
						</fo:block>
					</fo:block-container>

					<!-- diamonds bottom left -->
					<fo:block-container
						absolute-position="absolute"
						bottom="0mm" left="0mm"
						width="2.5in" height="30mm"
						>
						<fo:block>
							<fo:external-graphic src="{$diamonds-bl}"
								content-width="50mm"
								scaling="uniform"
								/>
						</fo:block>
					</fo:block-container>

					<!-- Kx bottom right -->
					<fo:block-container
						absolute-position="absolute"
						bottom="0mm" right="0mm"
						width="4in" height="50mm"
						>
						<fo:block text-align="right">
							<fo:external-graphic src="{$big-white-kx}"
								content-width="75mm"
								/>
						</fo:block>
					</fo:block-container>

					<!-- blue Kx logo -->
					<fo:block-container
						absolute-position="absolute"
						top="35mm" left="15mm"
						>
						<fo:block
							color="{$kx-blue}" 
							font-family="{$display-type}" font-size="60pt" font-weight="bold"
							letter-spacing="-4pt"
							>kx</fo:block>
					</fo:block-container>

					<!-- it’s about time -->
					<fo:block-container
						absolute-position="absolute"
						top="40mm" left="40mm"
						>
						<fo:block>
							<fo:external-graphic src="{$about-time}"/>
						</fo:block>
					</fo:block-container>

					<!-- title -->
					<fo:block-container
						absolute-position="absolute"
						top="80mm" left="35mm"
						>
						<fo:block
							font-family="{$display-type}"
							color="{$kx-blue}" font-size="18pt" font-weight="400"
							>
							Technical Whitepaper
						</fo:block>

						<!-- title -->
						<fo:block margin-top="9pt" font-size="24pt" font-weight="400">
							<xsl:value-of select="$article-title"/>
						</fo:block>
					</fo:block-container>

					<!-- date -->
					<fo:block-container absolute-position="absolute" top="170mm" left="35mm">
						<fo:block line-height="16pt" font-weight="bold">Date</fo:block>
					</fo:block-container>
					<fo:block-container absolute-position="absolute" top="170mm" left="55mm" width="100mm">
						<fo:block line-height="16pt" text-align="left">
							<xsl:value-of select="/db:article/db:info/db:date"/>
						</fo:block>
					</fo:block-container>

					<!-- author -->
					<fo:block-container absolute-position="absolute" top="180mm" left="35mm">
						<fo:block line-height="16pt" font-weight="bold">
							<xsl:choose>
								<xsl:when test="count(db:info/db:authorgroup/db:author)=1">Author</xsl:when>
								<xsl:otherwise>Authors</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:block-container>
					<fo:block-container absolute-position="absolute" top="180mm" left="55mm" width="100mm">
						<fo:block line-height="16pt" text-align="left">
							<xsl:apply-templates select="//db:section[@xml:id='author' or @xml:id='authors']/db:para"/>
						</fo:block>
					</fo:block-container>

					<!-- write something on the cover page -->
					<fo:block><xsl:text>&#160;</xsl:text></fo:block>

				</fo:flow>
			</fo:page-sequence>

			<!-- table of contents ************************************************************** -->
			<fo:page-sequence   master-reference="toc"
								font-family="{$body-type}"
								language="en" country="gb"
								>
				<fo:static-content flow-name="xsl-region-before">
					<xsl:call-template name="page-header"/>
				</fo:static-content>
				<fo:static-content	flow-name="xsl-region-after">
					<xsl:call-template name="page-footer"/>
				</fo:static-content>
				<fo:flow flow-name="xsl-region-body">
					<fo:block break-before="page">
						<fo:block font-size="14pt" text-align="center" 
								  margin-top="36pt" margin-bottom="36pt"
							>Contents</fo:block>
						<xsl:choose>
							<xsl:when test="$source='single'">
								<xsl:for-each select="$h2s"><xsl:call-template name="toc-entry"/></xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$h1s"><xsl:call-template name="toc-entry"/></xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>

			<!-- article content **************************************************************** -->
			<fo:page-sequence   master-reference="standard-page"
								font-family="{$body-type}"
								language="en" country="gb"
								>
				<fo:static-content flow-name="xsl-region-before">
					<xsl:call-template name="page-header"/>
				</fo:static-content>

				<!-- footnotes -->
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" rule-thickness=".5pt" leader-length="50%"/>
					</fo:block>
				</fo:static-content>

				<!-- page footers -->
				<fo:static-content	flow-name="xsl-region-after">
					<xsl:call-template name="page-footer"/>
				</fo:static-content>

				<!-- main text block -->
				<fo:flow flow-name="xsl-region-body">
					<xsl:apply-templates select="db:section">
						<xsl:with-param name="first" select="$source='single'"/>
					</xsl:apply-templates>
				</fo:flow>

			</fo:page-sequence>

		</fo:root>

	</xsl:template>

	<xsl:template name="toc-entry">
		<fo:block margin-bottom="6pt" text-align-last="justify">
			<fo:basic-link internal-destination="{generate-id(.)}">
				<xsl:value-of select="."/><xsl:text> </xsl:text>
				<fo:leader leader-pattern="dots"/><xsl:text> </xsl:text>
				<fo:page-number-citation ref-id="{generate-id(.)}"/>
			</fo:basic-link>
		</fo:block>
	</xsl:template>

	<!-- page header -->
    <xsl:template name="page-header">
		<fo:block text-align-last="justify" font-family="{$display-type}" color="gray">
			<fo:inline font-size="9pt"><xsl:value-of select="$article-title"/></fo:inline>
			<fo:leader leader-pattern="space"/>
			<fo:inline color="{$kx-blue}" font-size="18pt" font-weight="bold" letter-spacing="-2pt">kx</fo:inline>
		</fo:block>
	</xsl:template>
	<!-- page footer -->
	<xsl:template name="page-footer">
		<fo:block color="gray" text-align="right">
			<fo:inline 
				font-family="{$display-type}" font-size="9pt" letter-spacing="2pt"
				><fo:page-number/></fo:inline>
		</fo:block>
	</xsl:template>

	<xsl:template match="db:section">
		<xsl:param name="first" select="false()"/>
		<xsl:param name="depth" select="0"/>
		<xsl:if test="@xml:id!='author' and @xml:id!='authors'">
			<!-- wrapper block as anchor for embedded ToC -->
			<fo:block id="{@xml:id}">
				<xsl:apply-templates>
					<xsl:with-param name="depth" select="$depth+not($first)"/>
				</xsl:apply-templates>
			</fo:block>
		</xsl:if>
	</xsl:template>

		

	<xsl:template match="db:title">
		<xsl:param name="depth"/>
		<xsl:choose>
			<xsl:when test="$depth&lt;2">
				<fo:block id="{generate-id(.)}"
					font-family="{$display-type}"
					font-size="18pt"
					line-height="22pt"
					margin-right="36pt"
					page-break-before="always"
					space-after="60pt"
					text-align="left"
					>
					<xsl:value-of select="."/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$depth=2">
				<fo:block
					font-weight="bold"
					font-size="14pt"
					line-height="17pt"
					margin-right="36pt"
					page-break-after="avoid"
					space-after="6pt"
					space-before="18pt"
					text-align="left"
					>
					<xsl:value-of select="."/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$depth=3">
				<fo:block
					font-size="12pt"
					font-weight="bold"
					line-height="17pt"
					margin-right="36pt"
					page-break-after="avoid"
					space-after="6pt"
					space-before="18pt"
					text-align="left"
					>
					<xsl:value-of select="."/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$depth=4">
				<fo:block
					font-size="10pt"
					line-height="14.5pt"
					margin-right="36pt"
					page-break-after="avoid"
					space-after="6pt"
					space-before="18pt"
					text-align="left"
					>
					<xsl:value-of select="."/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block
					font-family="{$display-type}"
					>
					<xsl:value-of select="$depth"/>. 
					<xsl:value-of select="."/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

 	<!-- blockquote -->
 	<xsl:template match="db:blockquote">
		<!-- if first para begins !!! this is an admonition -->
		<xsl:variable name="beginning" select="normalize-space(*[1])"/>
		<xsl:choose>
			<!-- admonition -->
			<xsl:when test="starts-with($beginning,'!!! ')">
				<xsl:variable name="type-sample" select="substring($beginning,5,3)"/>
				<xsl:variable name="bg-color">
					<xsl:call-template name="admonition-background">
						<xsl:with-param name="admonition-type" select="$type-sample"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="title-text" select="substring-after(concat(substring($beginning,5),' '),' ')"/>
				<fo:block background-color="{$bg-color}" 
					font-size="10.5pt" line-height="13pt"
					margin-bottom="9pt"
					margin-left="0mm" margin-right="0mm"
					page-break-inside="avoid" 
					padding-left="3mm" padding-right="3mm" padding-top="3mm"
					>
					<fo:block margin-bottom="6pt">
						<fo:inline vertical-align="sub">
							<xsl:call-template name="icon">
								<xsl:with-param name="code-point">
									<xsl:call-template name="admonition-icon">
										<xsl:with-param name="admonition-type" select="$type-sample"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</fo:inline>
						<xsl:text> </xsl:text>
				 		<fo:inline font-weight="bold"><xsl:value-of select="$title-text"/></fo:inline>
					</fo:block>
					<xsl:apply-templates select="*[position()&gt;1]"/>
<!-- 
					Watch out: 
					On MkDocs pages, program listings nested within admonitions break the Prism syntax highlighting
					unless marked up in raw HTML, e.g. <pre><code class="language-q">.
					But when converting from Markdown to DocBook5, Pandoc ignores the above raw HTML.
 -->
				</fo:block>
			</xsl:when>
			<!-- regular blockquote -->
			<xsl:otherwise>
		 		<fo:block font-size="10.5pt"
					margin-top="6pt" margin-bottom="6pt" 
					margin-left="5mm"
		 			>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
 	</xsl:template>

 	<xsl:template name="icon">
 		<xsl:param name="code-point"/>
		<fo:inline font-family="{$icon-type}" font-size="14pt">
			<xsl:value-of select="$code-point"/>
		</fo:inline>
	</xsl:template>

 	<xsl:template name="admonition-background">
 		<xsl:param name="admonition-type"/>
 		<xsl:choose>
 			<xsl:when test="$admonition-type='inf'">#EEE</xsl:when>
 			<xsl:when test="$admonition-type='not'">#EEF</xsl:when>
 			<xsl:when test="$admonition-type='tip'">#EFF</xsl:when>
 			<xsl:when test="$admonition-type='war'">#FFE</xsl:when>
 			<xsl:otherwise>#EEE</xsl:otherwise>
 		</xsl:choose>
 	</xsl:template>

	<!-- https://github.com/google/material-design-icons/blob/master/iconfont/codepoints -->
 	<xsl:template name="admonition-icon">
 		<xsl:param name="admonition-type"/>
	 		<xsl:choose>
	 			<xsl:when test="$admonition-type='inf'">&#xE88F;</xsl:when>
	 			<xsl:when test="$admonition-type='not'">&#xE254;</xsl:when>
	 			<xsl:when test="$admonition-type='tip'">&#xE869;</xsl:when>
	 			<xsl:when test="$admonition-type='war'">&#xE925;</xsl:when>
	 			<xsl:otherwise>&#xE001;</xsl:otherwise>
	 		</xsl:choose>
 	</xsl:template>

<!--  		<xsl:call-template name="title-case">
 			<xsl:with-param name="a-string" select="substring-before(concat($title-text,' '),' ')"/>
 		</xsl:call-template>
 	</xsl:template>
 	<xsl:templates name="title-case">
 		<xsl:param name="a-string"/>
 		<xsl:call-template name="uppercase">
 			<xsl:with-param name="a-string" select="substring($a-string,1,1)"/>
		</xsl:call-template><xsl:value-of select="substring($a-string,2)"/>
	</xsl:templates>
 	<xsl:template name="uppercase">
 		<xsl:param name="a-string"/>
 		<xsl:value-of select="translate($a-string,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	</xsl:template>
 -->

	<!-- para -->
	<xsl:template match="db:para">
		<fo:block
			line-height="16pt"
			space-after="9pt"
			text-align="justify"
			>
			<!-- Special case: treat as a heading a para beginning with 'Example:'  -->
			<xsl:if test="substring(normalize-space(),1,8)='Example:'">
				<xsl:attribute name="page-break-after">avoid</xsl:attribute>
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- literallayout -->
	<xsl:template match="db:literallayout">
		<fo:block
			linefeed-treatment="preserve"
			line-height="16pt"
			space-after="9pt"
			text-align="left"
			>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- lists -->
	<xsl:template match="db:itemizedlist">
		<fo:list-block
			provisional-distance-between-starts="0.3cm"
			provisional-label-separation="0.15cm"
			>
			<xsl:apply-templates select="db:listitem">
				<xsl:with-param name="numeric">false</xsl:with-param>
			</xsl:apply-templates>
		</fo:list-block>
	</xsl:template>

	<xsl:template match="db:orderedlist">
		<fo:list-block
			provisional-distance-between-starts=".7cm"
			provisional-label-separation="0.3cm"
			>
			<xsl:apply-templates select="db:listitem">
				<xsl:with-param name="numeric">true</xsl:with-param>
			</xsl:apply-templates>
		</fo:list-block>
	</xsl:template>

	<xsl:template match="db:listitem">
		<xsl:param name="numeric">true</xsl:param>
		<xsl:variable name="label">
			<xsl:choose>
				<xsl:when test="$numeric='true'"><xsl:number format="1"/>.</xsl:when>
				<xsl:otherwise>•</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block line-height="16pt"><xsl:value-of select="$label"/></fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="db:variablelist">
		<xsl:for-each select="db:varlistentry">
			<fo:block><xsl:apply-templates select="db:term"/></fo:block>
			<fo:block margin-left="10mm" page-break-inside="avoid" margin-bottom="3pt">
				<xsl:for-each select="db:listitem">
					<xsl:apply-templates/>
				</xsl:for-each>
			</fo:block>
		</xsl:for-each>
	</xsl:template>

	<!-- term -->
	<xsl:template match="db:term">
		<fo:block page-break-after="avoid" margin-bottom="6pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- programlisting -->
	<xsl:template match="db:programlisting">
		<fo:block
			font-family="{$code-type}" font-size="10pt"
			margin-bottom="12pt"
			margin-left="10pt"
			white-space="pre"
			>
			<xsl:value-of select="."/>
		</fo:block>
	</xsl:template>

	<!-- table -->
	<xsl:template match="db:informaltable">

		<fo:table-and-caption margin-right="36pt" margin-bottom="9pt">
			<fo:table font-size="9pt">
				
				<fo:table-header 
					border-bottom-style="solid" border-bottom-width=".5pt"
					page-break-after="avoid"
					>
					<fo:table-row>
						<xsl:for-each select="db:tgroup/db:thead/db:row/db:entry">
							<fo:table-cell font-style="italic"
								padding-left="5pt" padding-right="5pt" 
								>
								<xsl:variable name="colno" select="position()"/>
								<fo:block linefeed-treatment="preserve">
									<xsl:attribute name="text-align">
										<xsl:value-of select="../../../db:colspec[$colno]/@align"/>
									</xsl:attribute>
									<xsl:apply-templates/>
								</fo:block>
							</fo:table-cell>
						</xsl:for-each>
					</fo:table-row>
				</fo:table-header>

				<fo:table-body>
					<xsl:for-each select="db:tgroup/db:tbody/db:row">
						<fo:table-row page-break-inside="avoid">
							<xsl:for-each select="db:entry">
								<xsl:variable name="colno" select="position()"/>
								<fo:table-cell
									padding-left="5pt" padding-right="5pt" 
									>
									<fo:block linefeed-treatment="preserve">
										<xsl:attribute name="text-align">
											<xsl:value-of select="../../../db:colspec[$colno]/@align"/>
										</xsl:attribute>
										<xsl:apply-templates/>
									</fo:block>
								</fo:table-cell>
							</xsl:for-each>
						</fo:table-row>
					</xsl:for-each>
				</fo:table-body>

			</fo:table>
		</fo:table-and-caption>
	</xsl:template>


	<xsl:template match="db:br">
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

	<!-- IMAGES -->
	<xsl:template match="/db:article/db:section[1]/db:figure">
		<!-- 
		An image immediately following the title of the first section is an ornament,
		not to be printed.
		 -->
 		<xsl:if test="name(preceding-sibling::*[1])!='title'">
 			<xsl:apply-templates select="db:mediaobject"/>
 		</xsl:if>
	</xsl:template>

	<xsl:template match="db:figure">
		<!-- ignore title -->
		<xsl:apply-templates select="db:mediaobject"/>
	</xsl:template>

	<xsl:template match="db:mediaobject">
		<fo:block page-break-after="avoid" text-align="center"><xsl:apply-templates select="db:imageobject"/></fo:block>
		<fo:block font-size="9pt" font-style="italic" margin-bottom="15pt"><xsl:value-of select="db:textobject/db:phrase"/></fo:block>
	</xsl:template>

	<xsl:template match="db:imageobject">
		<fo:external-graphic content-width="scale-down-to-fit" src="url({db:imagedata/@fileref})" width="100%"/>
	</xsl:template>


	<!-- link -->
	<xsl:template match="db:link">
		<xsl:choose>
			<xsl:when test="db:inlinemediaobject">
				<!-- ignore link on image -->
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="href">
					<xsl:choose>
						<xsl:when test="starts-with(@xlink:href,'http')"><xsl:value-of select="@xlink:href"/></xsl:when>
						<xsl:when test="starts-with(@xlink:href,'/')"><xsl:value-of select="concat($site-url,@xlink:href)"/></xsl:when>
						<xsl:otherwise>internal</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$href='internal'">
						<!-- no links within article -->
						‘<xsl:apply-templates/>’
					</xsl:when>
					<xsl:otherwise>
						<fo:basic-link external-destination="url('{$href}')">
							<fo:inline color="{$kx-blue}"><xsl:apply-templates/></fo:inline>
						</fo:basic-link>
						<xsl:variable name="refno"><xsl:number level="any"/></xsl:variable>
						<fo:footnote>
							<fo:inline font-size="8pt" alignment-baseline="hanging"><xsl:value-of select="$refno"/></fo:inline>
							<fo:footnote-body>
								<fo:block font-size="8pt">
									<xsl:value-of select="$refno"/>.
									<xsl:value-of select="$href"/>
								</fo:block>
							</fo:footnote-body>
						</fo:footnote>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
 	</xsl:template>



	<!-- blocks -->
	<xsl:template match="
		db:author
		|db:date
		">
		<fo:block>
			<fo:inline color="green"><xsl:value-of select="name()"/></fo:inline>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- inline styles -->
	<xsl:template match="db:code|db:literal|db:phrase">
		<fo:inline font-family="{$code-type}"><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="db:emphasis">
		<fo:inline font-style="italic"><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="db:i">
		<!-- FontAwesome icons -->
		<xsl:if test="@class='fa fa-hand-o-right'">
			<xsl:call-template name="icon">
				<xsl:with-param name="code-point">&#xE894;</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="db:quote">
		‘<xsl:apply-templates/>’
	</xsl:template>

	<xsl:template match="db:small">
		<fo:inline font-size="10pt"><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="db:strong">
		<fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline>
	</xsl:template>


 	<!-- CATCH-ALL TEMPLATES -->

	<!-- inlines -->
	<xsl:template match="
		db:code
		|db:firstname
		|db:surname
		">
		<fo:inline color="blue"><xsl:value-of select="name()"/></fo:inline>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- containers: ignore -->
	<xsl:template match="
        db:authorgroup
		|db:info
		|db:inlinemediaobject
		|db:textobject
		">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- unmatched -->
	<xsl:template match="*">
		<fo:block color="red">Unmatched: <xsl:value-of select="name()"/></fo:block>
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>