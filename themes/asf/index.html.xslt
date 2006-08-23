<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:planet="http://planet.intertwingly.net/"
                xmlns="http://www.w3.org/1999/xhtml">
 
  <xsl:template match="atom:feed">
    <html xmlns="http://www.w3.org/1999/xhtml">

      <!-- head -->
      <xsl:text>&#10;&#10;</xsl:text>
      <head>
        <link rel="stylesheet" href="default.css" type="text/css" />
        <title><xsl:value-of select="atom:title"/></title>
        <meta name="generator" content="{atom:generator}" />
        <xsl:if test="atom:link[@rel='self']">
          <link rel="alternate" href="{atom:link[@rel='self']/@uri}"
            title="{atom:title}" type="{atom:link[@rel='self']/@type}" />
        </xsl:if>
        <link rel="shortcut icon" href="/favicon.ico" />
        <script type="text/javascript" src="personalize.js"></script>
      </head>

      <xsl:text>&#10;&#10;</xsl:text>
      <body>
        <xsl:text>&#10;</xsl:text>
        <h1><xsl:value-of select="atom:title"/></h1>

        <xsl:text>&#10;</xsl:text>
        <div id="sidebar">

          <xsl:text>&#10;&#10;</xsl:text>
          <h2>Subscriptions</h2>
          <xsl:text>&#10;</xsl:text>
          <ul>
            <xsl:for-each select="planet:source">
              <xsl:sort select="planet:name"/>
              <xsl:text>&#10;</xsl:text>
              <li>
                <a href="{atom:link[@rel='self']/@href}" title="subscribe">
                  <img src="images/feed-icon-10x10.png" alt="(feed)"/>
                </a>
                <a href="{atom:link[@rel='alternate']/@href}">
                  <xsl:value-of select="planet:name"/>
                </a>
              </li>
            </xsl:for-each>
            <xsl:text>&#10;</xsl:text>
          </ul>

          <xsl:text>&#10;&#10;</xsl:text>
          <h2>Info</h2>

          <dl>
            <dt>Last updated:</dt>
            <dd><span class="date" title="GMT"><xsl:value-of select="atom:updated/@planet:format"/></span></dd>
            <dt>Powered by:</dt>
            <dd><a href="http://intertwingly.net/code/venus/"><img src="images/planet.png" width="80" height="15" alt="Planet" border="0" /></a></dd>
            <dt>Export:</dt>
            <dd>
              <ul>
                <li><a href="opml.xml"><img src="images/opml.png" alt="OPML" /></a></li>
                <li><a href="foafroll.xml"><img src="images/foaf.png" alt="FOAF" /></a></li>
              </ul>
            </dd>
          </dl>

        </div>

        <xsl:text>&#10;&#10;</xsl:text>
        <div id="body">
          <xsl:apply-templates select="atom:entry"/>
          <xsl:text>&#10;&#10;</xsl:text>
        </div>
      </body>
    </html>
  </xsl:template>
 
  <xsl:template match="atom:entry">
    <!-- date header -->
    <xsl:variable name="date" select="substring(atom:updated,1,10)"/>
    <xsl:if test="not(preceding-sibling::atom:entry
      [substring(atom:updated,1,10) = $date])">
      <xsl:text>&#10;&#10;</xsl:text>
      <h2 class="date">
        <xsl:value-of select="substring-before(atom:updated/@planet:format,', ')"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="substring-before(substring-after(atom:updated/@planet:format,', '), ' ')"/>
      </h2>
    </xsl:if>

    <xsl:text>&#10;&#10;</xsl:text>
    <div class="news">

      <xsl:if test="@xml:lang">
        <xsl:attribute name="xml:lang" select="{@xml:lang}"/>
      </xsl:if>

      <!-- entry title -->
      <xsl:text>&#10;</xsl:text>
      <h3>
        <xsl:if test="atom:source/atom:icon">
          <img src="{atom:source/atom:icon}" class="icon"/>
        </xsl:if>
        <a href="{atom:source/atom:link['alternate']/@href}" class="icon">
          <xsl:attribute name="title" select="{atom:source/atom:title}"/>
          <xsl:value-of select="atom:source/planet:name"/>
        </a>
        <xsl:if test="atom:title">
          <xsl:text>&#x2014;</xsl:text>
          <a href="{atom:link[@rel='alternate']/@href}">
            <xsl:if test="atom:title/@xml:lang != @xml:lang">
              <xsl:attribute name="xml:lang" select="{atom:title/@xml:lang}"/>
            </xsl:if>
            <xsl:value-of select="atom:title"/>
          </a>
        </xsl:if>
      </h3>

      <!-- entry content -->
      <xsl:text>&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="atom:content">
          <xsl:apply-templates select="atom:content"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="atom:summary"/>
        </xsl:otherwise>
      </xsl:choose>
  
      <!-- entry footer -->
      <xsl:text>&#10;</xsl:text>
      <div class="permalink">
        <a href="{atom:link[@rel='alternate']/@href}">
          <xsl:choose>
            <xsl:when test="atom:author/atom:name">
              <xsl:text>by </xsl:text>
              <xsl:value-of select="atom:author/atom:name"/>
              <xsl:text> at </xsl:text>
            </xsl:when>
            <xsl:when test="atom:source/atom:author/atom:name">
              <xsl:text>by </xsl:text>
              <xsl:value-of select="atom:source/atom:author/atom:name"/>
              <xsl:text> at </xsl:text>
            </xsl:when>
          </xsl:choose>
          <span class="date" title="GMT">
            <xsl:value-of select="atom:updated/@planet:format"/>
          </span>
        </a>
      </div>
    </div>

  </xsl:template>

  <!-- xhtml content -->
  <xsl:template match="atom:content/xhtml:div | atom:summary/xhtml:div">
    <xsl:copy>
      <xsl:if test="@xml:lang != ancestor::atom:entry/@xml:lang">
        <xsl:attribute name="xml:lang" select="{atom:content/@xml:lang}"/>
      </xsl:if>
      <xsl:attribute name="class">content</xsl:attribute>
      <xsl:copy-of select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- plain text content -->
  <xsl:template match="atom:content/text() | atom:summary/text()">
    <div class="content" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:if test="@xml:lang != ancestor::atom:entry/@xml:lang">
        <xsl:attribute name="xml:lang" select="{atom:summary/@xml:lang}"/>
      </xsl:if>
      <xsl:copy-of select="."/>
    </div>
  </xsl:template>
</xsl:stylesheet>
