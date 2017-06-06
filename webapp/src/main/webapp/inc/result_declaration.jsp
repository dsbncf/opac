<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="bncf.opac.Constants"%>
<%!

   private boolean debug = true;

   //Liste contenenti rispettivamente: nomi dei filtri di tipo keywords e nome
   //dei filtri di tipo range
   String[] k = { "cid", "keywords", "dewey_cod", "vid" };
   List labelKeywords = Arrays.asList(k);
   String[] r = { "anno1", "dataagg" };
   List labelRange = Arrays.asList(r);


   private String formatTxt(String str)
   {
      if (str == null)
         return "";
      return str;
   }


   private String formatTxt(int nt)
   {
      if (nt == 0)
         return "";
      return nt + "";
   }


   private String formatTxt(Object obj)
   {
      if (obj == null)
         return "";
      return obj.toString();
   }


   private String delControlChar(String str)
   {
      if (str == null)
         return null;
      return str.replaceAll("\\\u0098", "").replaceAll("\\\u009C", "");
   }

   private void dbg(String msg)
   {
      if (debug)
         System.out.println(msg);
   }


   private boolean isEmpty(String str)
   {
      return ((str == null) || str.equals(""));
   }


   private boolean isNotEmpty(String str)
   {
      return ((str != null) && !str.equals(""));
   }


   private String getSearchRequestPath(HttpServletRequest request)
   {
      return (String)request.getAttribute("ricerca");
   }

   /**
    * costruisce l'URL base per un nuovo request URL.
    */
   private StringBuilder getURLBase(HttpServletRequest request)
   {
      StringBuilder sb = new StringBuilder();
      sb.append(request.getContextPath());
      sb.append("/").append(getSearchRequestPath(request));
      return sb;
   }


   private String getCleanQueryString(HttpServletRequest request)
   {
      StringBuilder sb = new StringBuilder();
      Map map = request.getParameterMap();
      Iterator<Map.Entry<String, String[]>> iter = map.entrySet().iterator();
      while (iter.hasNext())
      {
         Map.Entry<String, String[]> entry = iter.next();
         String entryName = entry.getKey();

         //if (entryName.equals("start"))
         //   continue;

         for (String value : entry.getValue())
         {
            if (isNotEmpty(value) && !entryName.equals("dosearch"))
            {
               if (sb.length() > 0)
                  sb.append("&");
               try
               {
                  value = URLEncoder.encode(value, "UTF-8");
               }
               catch(Exception ex){}
               sb.append(entryName).append("=").append(value);
            }
         }
      }

      //Eliminazione finale del parametro start se nella stringa
      return sb.toString().replaceAll("/[0-9]*$", "");
   }


   /**
    * Aggiunge un parametro al querystring.
    */
   private String getURL(HttpServletRequest request, int start, String fieldName, String fieldValue)
   {
      // dbg("getURL> " + fieldName + " = " + fieldValue);
      StringBuilder sb = getURLBase(request);
      if (start>0)
        sb.append("/").append(start);
      sb.append("?");
      String qs = getCleanQueryString(request);
      // dbg("getURL> clean queryString = " + qs);
      qs = replaceOrAppend(qs, fieldName, fieldValue).toString();
      sb.append(qs);
      return sb.toString();
   }


   /** Elimina copia chiave / valore dai parametri della url per la ricerca
    *
    * @param request HttpServletRequest
    * @param start Offset lista. In realta' non dovrebbe essere mai utile passare lo start,
                   e forse mai usato veramente.
    * @param fieldName Nome della chiave (parametro) da eliminare
    * @param fieldValue Valore della chiave (parametro) da eliminare
    */
   private String getCleanURL(HttpServletRequest request, int start,
                              String fieldName, String fieldValue)
   {
      boolean isKeywords = (labelKeywords.contains(fieldName) || fieldName.indexOf("_kw") == fieldName.length() - 3);
      boolean isRange = labelRange.contains(fieldName);
      dbg("fieldName: " + fieldName + " - isKeywords: " + isKeywords + " - isRange: " + isRange);

      return getCleanURL(request, fieldName, fieldValue, isKeywords, isRange);
   }


   /** Elimina copia chiave / valore dai parametri della url per la ricerca
    *
    * La funzione tratta in modo speciale le keywords e i parametri range, perche' i primi
    * sono sempre composti da due parametri: sf e sv numerati (sf1, sf2, ecc), mentre i secondi
    * sono sempre composti da un to e un from (per esempio anno_to e anno_from).
    * Eliminando una keywords o un parametro di tipo range, occorre eliminare quindi due parametri
    * dalla querystring e non uno solo, e i due parametri non hanno necessariamente il nome del
    * field stesso.
    *
    * @param request HttpServletRequest
    * @param fieldName Nome della chiave (parametro) da eliminare
    * @param fieldValue Valore della chiave (parametro) da eliminare
    * @param isKeywords Indica se il parametro e' una keyword, ovvero se e' "keyword" oppure "sf"||"sv", con un numero
    * @param isRange Indica se il parametro fa parte di un range (from/to)
    */
   private String getCleanURL(HttpServletRequest request, String fieldName,
                              String fieldValue, boolean isKeywords,
                              boolean isRange)
   {
      StringBuilder sb = getURLBase(request);
      // dbg("getCleanURL> URLBase:" + sb.toString());

      Map map = request.getParameterMap();
      // dbg("getCleanURL> map:" + map.size());

      //dbg("getCleanURL> field: " + fieldName + " = " + fieldValue);

      if ((fieldName == null) || (fieldValue == null) || (map.size() == 0))
      {
         return sb.toString();
      }

      StringBuilder q = new StringBuilder();
      Iterator<Map.Entry<String, String[]>> iter = map.entrySet().iterator();
      while (iter.hasNext())
      {
         Map.Entry<String, String[]> entry = iter.next();
         String entryName = entry.getKey();
         String values[] = entry.getValue();

         //dbg("getCleanURL> entry: " + entryName + " = " + values[0]);

         if ((values == null) || (values.length == 0) || values[0].trim().equals(""))
            continue;

         //if (entryName.equals("start"))
         //   continue;

         if ((!isKeywords) && (!isRange))
         {
            if (entryName.equals(fieldName))
               continue;
         }
         if (isKeywords)
         {
            int pi = 0; //parameterIndex
            //dbg("getCleanURL> initial pi " + pi);

            for (int i = 0; i < Constants.DEF_SEARCHTERMSMAX; i++)
            {
               //dbg("getCleanURL> control index: " + i);
               if (map.containsKey("sf" + i))
               {
                  String mapKey[] = (String[]) map.get("sf" + i);
                  //dbg("getCleanURL> map contains key: sf" + i + ", value: " + mapKey);
                  if (mapKey[0].equals(fieldName))
                  {
                     pi = i;
                     //dbg("getCleanURL> pi: " + i);
                     break;
                  }
               }
            }

            if (entryName.equals("sf"+pi) || entryName.equals("sv"+pi))
                continue;

         }
         if (isRange)
         {
            if (entryName.equals(fieldName + "_to") || entryName.equals(fieldName + "_from"))
               continue;
         }


         String val = null;
         try
         {
            val = URLEncoder.encode(values[0], "UTF-8");
         }
         catch(Exception ex){}
         if (val != null)
         {
            q.append((q.length() == 0) ? "?" : "&");
            q.append(entryName).append("=").append(val);
            //dbg("getCleanURL 2> entry: " + entryName + " = " + val);
         }
      }
      sb.append(q);
      //dbg("getCleanURL> returning url: " + sb.toString());
      return sb.toString();
   }


   /**
    * gestione parametro start per il cambio dell'offset nella lista.
    */
   private String getURL(HttpServletRequest request, long start)
   {
      dbg("getURL>urlbase"+getURLBase(request).toString());
      StringBuilder sb = new StringBuilder(getURLBase(request).toString().replaceAll("(/([0-9]*)){0,1}$",""));
      if (start>0)
        sb.append("/"+start);
      String qs = getCleanQueryString(request);
      sb.append("?").append(qs);
      return sb.toString();
   }


   /**
    * gestione parametro per l'espansione della facet box a sx.
    */
   private String getURL(HttpServletRequest request, String showAll)
   {
      StringBuilder sb = getURLBase(request);
      String qs = getCleanQueryString(request);
      sb.append("?").append(replaceOrAppend(qs, "exp", showAll));
      return sb.toString();
   }


   /**
    * rimpiazza o appende parametro nella querystring.
    */
   private StringBuilder replaceOrAppend(String queryString, String paramName,
                                         String paramValue)
   {
      StringBuilder sb = new StringBuilder();
      if ((queryString == null) || queryString.equals(""))
      {
         sb.append(paramName).append("=").append(paramValue);
      }
      else
      {
         Pattern pattern = Pattern.compile(paramName + "=[^&]*");
         Matcher matcher = pattern.matcher(queryString);
         if (matcher.find())
            sb.append(matcher.replaceAll(paramName + "=" + paramValue));
         else
            sb.append(queryString).append("&").append(paramName).append("=").append(paramValue);
      }
      return sb;
   }


   /**
    * prepara una stringa per una url: effettua un url encoding e sostituisce gli slash con -.
    */
   private String encodeOffertaUrl(String strng)
   {
      try
      {
         if (strng != null)
            return URLEncoder.encode(strng.replace("/", "-"), "UTF-8");
      }
      catch(Exception ex){}

      return strng;
   }

%>
