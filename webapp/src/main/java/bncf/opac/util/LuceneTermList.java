
package bncf.opac.util;


import java.util.ArrayList;



public class LuceneTermList extends ArrayList<LuceneTerm>
{
   private boolean hasOrOperator = false;

 public LuceneTermList()
 {
    super();
 }

 public boolean add(LuceneTerm term)
 {
    boolean ret = super.add(term);
    int op = term.getOperator();
    if (op == LuceneTerm.OPERATOR_OR)
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
