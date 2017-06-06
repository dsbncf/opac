
package bncf.opac.servlet;


import bncf.opac.util.SpellChecker;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// import org.apache.lucene.search.spell.SpellChecker;

import org.apache.lucene.store.Directory;
import org.apache.lucene.store.SimpleFSDirectory;



/**
 * DidYouMean Servlet trova termini simili da indice dedicato.
 * utilizza lo SpellChecker di Lucene contrib.
 */


public class DidYouMeanServlet extends BaseServlet
{
    private final static String DIDYOUMEAN_JSP = "prove/didyoumean.jsp";

    private String       indexLocation = null;
    private Directory    spellIndex   = null;
    private SpellChecker spellChecker = null;


   /**
    * open the spell-checker index.
    *
    * @param servletConfig
    * @throws ServletException
    */
   @Override
   public void init(ServletConfig servletConfig) throws ServletException
   {
      indexLocation = servletConfig.getInitParameter("index-location");
      System.out.println("using SpellChecker index at " + indexLocation);

      try
      {
	 spellIndex = new SimpleFSDirectory(new File(indexLocation));
	 spellChecker = new SpellChecker(spellIndex);
      }
      catch (IOException ex)
      {
	 throw new ServletException(ex);
      }
   }


   /**
    * Process the incoming requests.
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    */
   @Override
   protected void processRequest(HttpServletRequest request,
				 HttpServletResponse response)
       throws IOException, ServletException
   {
      String word = getRequestParameter(request, "word");
      int count = getRequestIntParameter(request, "cnt", 500);
      float accur = getRequestFloatParameter(request, "acc", 0.7F);

      spellChecker.setAccuracy(accur);

      String[] simili = null;
      if ((word != null) && !word.equals(""))
      {
	 simili = spellChecker.suggestSimilar(word, count);
	 request.setAttribute("simili", simili);
      }
      request.getRequestDispatcher(DIDYOUMEAN_JSP).forward(request, response);
   }

} //class//
