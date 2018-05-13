mkdocs2pdf
==========

Scripts for generating Kx Technical Whitepapers as PDFs from Markdown source files (MDs) for Material for [MkDocs](http://mkdocs.org) documentation site [code.kx.com](http://code.kx.com/q/wp/) with [Material theme](https://squidfunk.github.io/mkdocs-material/).

Overview
--------

The source for a Technical Whitepaper is one or more Markdown files. 

The main process is `make_pdf.sh`, which defines the source and output files.

A q preprocessor script:

* assembles a single MD for the article
* removes metadata defining Hero lines
* wraps admonition blocks in blockquote containers

Pandoc reads the MD and writes a DocBook 5 XML file.

An XSL Transform reads the XML and writes a Formatting Objects (FO) file. 

The RenderX XEP program reads the FO and writes a PDF. 

file                  | action
----------------------|----------------------------------------------------
`filtr.q`             | Kdb+ script to write single MD for Pandoc
`make_pdfs.sh`        | Bash shell script to run whole process
`survey.xsl`          | XSL Transform to identify elements in XML
`whitepaper.sh`       | Bash script to run Pandoc, XSLT and XEP
`whitepaper.template` | Pandoc template to include extra metadata
`whitepaper.xsl`      | XSL Transform to write Formatting Objects for XEP
`xep.xml`             | XEP configuration file


Features
--------

* Cover page with images
* Generated table of contents on 2nd page
* Embedded table of contents for PDF viewer navigation
* Embedded metadata for PDF viewer, derived from YAML metadata block
* External hyperlinks are ‘live’ in the PDF, and also printed in footnotes 


Requirements
------------

* [Kdb+](https://kx.com/connect-with-us/download/); I used 3.6, but several earlier versions are likely to work
* [Pandoc](http://pandoc.org)
* XSLT processor: `xsltproc` suffices
* a print formatter driven by FO; I used [RenderX XEP](http://www.renderx.com/tools/xep.html), you might be able to get equivalent results from [Apache FOP](https://xmlgraphics.apache.org/fop/)
* PDF viewer, e.g. web browser, Preview, Adobe Reader


Typefaces
---------

The Kx Technical Whitepapers are set in:

role    | typeface
--------|----------------------
display | [Proxima Nova](https://www.marksimonson.com/fonts/view/proxima-nova)
body    | [STIX2](http://www.stixfonts.org/)
code    | [Essential PragmataPro](https://www.fsd.it/shop/fonts/pragmatapro/)
icon    | [Material Icons](https://material.io/tools/icons/)

To use these you will need 

* their corresponding fonts installed on your machine, with licences appropriate to your use
* to identify them in the XEP configuration file `xep.xml`, or equivalent for your rendering engine

Alternatively, specify other fonts 

* in `xep.xml`
* in `whitepaper.xsl`


Installation
------------

Install as siblings in a folder, except for `xep.xml`, which goes in your XEP installation. (Or use as a model for editing your own copy.)

Edit `make_pdfs` to refer to your own source file/s. 


Remarks
-------

The Hero lines are harmless in single-source articles, as they are not in Pandoc’s supported metadata and get ignored. In articles sourced from multiple files they have to be removed. 

The Markdown uses a PyMdown extension for admonitions. (See the configuration file `mkdocs.yaml` at [KxSystems/docs](https://github.com/kxsystems/docs/) for extensions in use.) Pandoc doesn’t know it, and in the XML it writes the admonitions are hard to identify. Wrapping them in blockquotes makes it easy for the XSL to identify and process them. 

It’s possible that getting Pandoc to convert Markdown to XHTML (with corresponding modifications to the XSL) would give equivalent or better results. Not explored. 

Kx-copyright images for the cover page have been omitted from the `img` folder. 

The XSL `survey.xsl` is used to identify elements in the XML. A catch-all template in `whitepaper.xsl` flags in red any XML elements for which no template is defined. 

Internal hyperlinks beginning `/` are prefixed with `http://code.kx.com/q`.

A FontAwesome icon (`fa-hand-o-right`) used in the Markdown is replaced by a Material icon. 