<%@ page language="java" pageEncoding="UTF-8" %>
<div class="ricmenu">
 <a class="testata" title="<%=lang.translate("ricerca_base") %> (AccessKey: b )" accesskey="b"
	href="<%=contextPath %>/fcsearch"><%=lang.translate("ricerca_base") %></a> |

 <a class="testata" title="<%=lang.translate("ricerca_avanzata") %> (AccessKey: a )" accesskey="a"
	href="<%=contextPath %>/fcsearchm"><%=lang.translate("ricerca_avanzata") %></a> |

 <a class="testata" title="<%=lang.translate("liste_per_autore_titolo_sogg") %> (AccessKey: l )" accesskey="l"
	href="<%=contextPath %>/list/"><%=lang.translate("liste") %></a> |

 <a class="testata" title="<%=lang.translate("nuovo_soggettario") %> (AccessKey: t )" accesskey="t"
	href="http://thes.bncf.firenze.sbn.it/ricerca.php"><%=lang.translate("thesaurus") %></a> |

 <a class="testata" title="<%=lang.translate("navigatore_dewey") %> (AccessKey: d )" accesskey="d"
	href="<%=contextPath %>/deweybrowser/"><%=lang.translate("navigatore_dewey") %></a> | 

 <a class="testata" title="<%=lang.translate("aiuto") %> (AccessKey: h )" accesskey="h"
	href="<%=contextPath %>/help_<%=locale.getLanguage() %>.jsp"><img src="<%=contextPath %>/img/help.gif" alt="aiuto"
	style="padding-right: 2px;" align="middle" border="0"/><%=lang.translate("aiuto") %></a> |

 <a class="testata" title="<%=lang.translate("crediti") %> (AccessKey: r )" accesskey="r"
	href="<%=contextPath %>/crediti.jsp"><%=lang.translate("crediti") %></a> |

 <a class="testata" title="<%=lang.translate("carrello") %> (AccessKey: c )" accesskey="c"
	href="<%=contextPath %>/cart.jsp"><%=lang.translate("carrello") %></a>
</div>
