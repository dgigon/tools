<%@ page contentType="text/html;charset=UTF-8" language="java"
%><?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="org.jahia.services.content.nodetypes.NodeTypeRegistry" %>
<%@ page import="javax.jcr.nodetype.NodeType"%>
<%@ page import="javax.jcr.nodetype.NodeTypeIterator" %>
<%@ page import="org.apache.commons.collections.IteratorUtils" %>
<%@ page import="org.jahia.services.content.JCRContentUtils" %>
<%@ page import="java.util.Comparator"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>Installed Definitions Browser</title>
    <link type="text/css" href="css/jquery.fancybox-1.3.4.css" rel="stylesheet"/>
    <style type="text/css" title="currentStyle">
        @import "css/demo_page.css";
        @import "css/demo_table_jui.css";
        @import "css/le-frog/jquery-ui-1.8.13.custom.css";
    </style>
    <script type="text/javascript" src="javascript/jquery.min.js"></script>
    <script type="text/javascript" src="javascript/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="javascript/jquery.fancybox-1.3.4.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            $('.defFileLink').fancybox({
                        'hideOnContentClick': false,
                        'scrolling' : 'yes',
                        'width' : 640,
                        'height' : 480,
                        'autoDimensions' : false
                    });
            $('#moduleTable').dataTable({
                        "bLengthChange": true,
                        "iDisplayLength":50,
                        "aLengthMenu": [
                            [50, 100, 150, -1],
                            [50, 100, 150, "All"]
                        ],
                        "bFilter": true,
                        "bSort": true,
                        "bInfo": false,
                        "bAutoWidth": true,
                        "bStateSave" : false,
                        "sPaginationType": "full_numbers",
                        "bJQueryUI": true
                    });
        });
    </script>
</head>
<%
    final NodeTypeRegistry nodeTypeRegistry = NodeTypeRegistry.getInstance();
    List<String> systemIds = nodeTypeRegistry.getSystemIds();
    Collections.sort(systemIds);
    pageContext.setAttribute("systemIds", systemIds);
%>
<body id="dt_example">
<%@ include file="gotoIndex.jspf" %>
<table id="moduleTable" class="display">
    <thead>
    <tr>
        <th>N°</th>
        <th>System ID</th>
        <th>Types</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${systemIds}" var="pkg" varStatus="pstatus">
        <%
            NodeTypeIterator nodeTypes = nodeTypeRegistry.getNodeTypes((String) pageContext.getAttribute("pkg"));
            List ntList = IteratorUtils.toList(nodeTypes);
            Collections.sort(ntList, JCRContentUtils.NODE_TYPE_NAME_COMPARATOR);
            pageContext.setAttribute("nodeTypes", ntList);
        %>
        <tr class="gradeA">
            <td align="center">${pstatus.count}</td>
            <td><a name="${pkg}" href="modulesBrowser.jsp?#${pkg}">${pkg}</a></td>
                <%--<td>${pkg.description}</td>--%>
                <%--<td>${pkg.rootFolderPath}</td>--%>
                <%--<td>${pkg.moduleType}</td>--%>
            <td>
                <ol>
                    <c:forEach items="${nodeTypes}" var="dep">
                        <c:set var="defFileName" value="${fn:replace(dep.name,':','_')}"/>
                        <li><a href="#${defFileName}" class="defFileLink">${dep.name}</a></li>
                        <div style="display:none;">
                            <div id="${defFileName}">
                                <h3>${dep.name}</h3>
                                <c:if test="${functions:length(dep.declaredSupertypes) > 0}">
                                    <p>
                                        Supertypes:
                                    </p>
                                    <ul>
                                        <c:forEach items="${dep.declaredSupertypes}" var="supertype">
                                            <li><a href="#${fn:replace(supertype.name,':','_')}"
                                                   class="defFileLink">${supertype.name}</a></li>
                                        </c:forEach>
                                    </ul>
                                </c:if>
                                <c:if test="${functions:length(dep.propertyDefinitions)>0}">
                                    <p>
                                        Properties:
                                    </p>
                                    <ul>
                                        <c:forEach items="${dep.propertyDefinitions}" var="propDef">
                                            <c:if test="${propDef.declaringNodeType.name eq dep.name}">
                                                <c:set var="propType" value="${propDef.requiredType}"/>
                                                <% pageContext.setAttribute("propTypeName", javax.jcr.PropertyType.nameFromValue((Integer)pageContext.getAttribute("propType"))); %>
                                                <li>${propDef.name} (${propTypeName})</li>
                                            </c:if>
                                        </c:forEach>
                                    </ul>
                                </c:if>
                                <c:if test="${functions:length(dep.subtypes)>0}">
                                    <p>
                                        Sub types:
                                    </p>
                                    <ul>
                                        <c:forEach items="${dep.subtypes}" var="supertype">
                                            <li><a href="#${fn:replace(supertype.name,':','_')}"
                                                   class="defFileLink">${supertype.name}</a></li>
                                        </c:forEach>
                                    </ul>
                                </c:if>
                                <c:if test="${functions:length(dep.childNodeDefinitions)>0}">
                                    <p>
                                        Children:
                                    </p>
                                    <ul>
                                        <c:forEach items="${dep.childNodeDefinitions}" var="supertype">
                                            <li><a href="#${fn:replace(supertype.name,':','_')}"
                                                   class="defFileLink">${supertype.name}</a></li>
                                        </c:forEach>
                                    </ul>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </ol>
            </td>
                <%--            <td>
                    <ol>
                        <c:forEach items="${pkg.definitionsFiles}" var="defFile">
                            <%
                                JahiaTemplatesPackage aPackage = (JahiaTemplatesPackage) pageContext.getAttribute(
                                        "pkg");
                                String file = aPackage.getFilePath() + File.separator + pageContext.getAttribute("defFile");
                                String s = FileUtils.readFileToString(new File(file));
                                pageContext.setAttribute("defFileName", UUID.randomUUID());
                                pageContext.setAttribute("defFileContent", s);
                            %>
                            <li><a href="#${defFileName}" class="defFileLink">${defFile}</a>

                                <div style="display: none;">
                                    <div id="${defFileName}">
    <pre>
            ${defFileContent}
    </pre>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ol>
                </td>--%>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>