(: Render XSL-FO to PDF with custom FOP processor configuration :)
let $fo :=
  <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <fo:layout-master-set>
      <fo:simple-page-master master-name="page"
          page-width="5in" page-height="3in">
        <fo:region-body margin="0.5in"/>
      </fo:simple-page-master>
    </fo:layout-master-set>
    <fo:page-sequence master-reference="page">
      <fo:flow flow-name="xsl-region-body">
        <fo:block font-size="14pt">Custom page size (5×3 inches)</fo:block>
      </fo:flow>
    </fo:page-sequence>
  </fo:root>
let $params :=
  <parameters>
    <param name="title" value="Custom Config Demo"/>
  </parameters>
(: FOP configuration with strict validation disabled :)
let $fop-config :=
  <fop version="1.0">
    <strict-configuration>false</strict-configuration>
    <strict-validation>false</strict-validation>
    <renderers>
      <renderer mime="application/pdf"/>
    </renderers>
  </fop>
let $pdf := xslfo:render($fo, "application/pdf", $params, $fop-config)
return
  <result>
    <size>{string-length(string($pdf))}</size>
    <starts-with-pdf-magic>
      {starts-with(util:binary-to-string($pdf), "%PDF")}
    </starts-with-pdf-magic>
  </result>
