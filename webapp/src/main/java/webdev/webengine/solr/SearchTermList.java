
package webdev.webengine.solr;


import java.util.ArrayList;



public class SearchTermList extends ArrayList<SearchTerm>
{
   private boolean hasOrOperator = false;

 public SearchTermList()
 {
    super();
 }

   @Override
 public boolean add(SearchTerm term)
 {
    boolean ret = super.add(term);
    int op = term.getOperator();
    if (op == SearchTerm.OPERATOR_OR)
       hasOrOperator = true;
    return ret;
 }

 public boolean hasOR()
 {
    return hasOrOperator;
 }

 public boolean hasSearchTerms()
 {
    return (size() > 0);
 }

}//class//
