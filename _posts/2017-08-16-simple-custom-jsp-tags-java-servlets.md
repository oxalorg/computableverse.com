---
date: 2017-08-16
title: Simple custom jsp tags in java servlets
slug: simple-custom-jsp-tags-java-servlets
---

4 simple things to do to use our own custom tags in jsp:

1. Link the uri to where your prefix (namespace) is to be found
2. Mention the location where the prefix uri has it's tag
   mappings (taglib.tld file)
3. Mention mappings of tag names and their implementing classes
   in taglib.tld
4. Implement the custom tag class which must be a child of `Tag`
   interface.

hello.jsp
```jsp
<%@ taglib uri="/tags" prefix="myjsp" %>
<html>
    <body>
        <%@ page errorPage="Errors.jsp" %>
        <p> <myjsp:helloWorld /> </p>
    </body>
</html>
```

web.xml
```xml
<web-app>
  <jsp-config>
    <taglib>
        <taglib-uri>/tags</taglib-uri>
        <taglib-location>/WEB-INF/taglib.td</taglib-location>
    </taglib>
  </jsp-config>
</web-app>
```

taglib.tld
```xml
<taglib>
    <tag>
        <name>helloWorld</name>
        <tag-class>com.computableverse.HelloWorld</tag-class>
    </tag>
</taglib>
```

com.computableverse.HelloWorld.java
```java
public class HelloWorld extends TagSupport {
    public int doStartTag() throws JspException {
        try {
            JspWriter out = pageContext.getOut();
            out.println("Hello World!");
        } catch (IOException ioe) {
            throw new JspException("wow");
        }
        return SKIP_BODY;
    }
}
```

## Adding attributes to tags

hello.jsp
```jsp
<p> <myjsp:helloWorld /> </p>
<p> <myjsp:helloWorld by='computableverse'/> </p>
```

taglib.tld
```xml
<taglib>
  <tag>
    <name>helloWorld</name>
    <tag-class>com.computableverse.HelloWorld</tag-class>

    <attribute>
        <name>by</name>
        <required>false</required>
        <rtexprvalue>true</rtexprvalue>
        <type>java.lang.String</type>
    </attribute>
  </tag>
</taglib>
```

com.computableverse.HelloWorld.java
```java
public class HelloWorld extends TagSupport {
    String by = null;
    public int doStartTag() throws JspException {
        try {
            JspWriter out = pageContext.getOut();
            out.println("Hello World!");
            if (by != null) {
                out.print("- by " + by);
            }
        } catch (IOException ioe) {
            throw new JspException("wow");
        }
        return SKIP_BODY;
    }

    public void setBy(String pBy) {
        by = pBy;
    }
}
```

