
package webdev.webengine.solr;


import java.util.regex.Matcher;
import java.util.regex.Pattern;


public final class SearchTerm
{
    private static final String RANGEQUERY_REGEX = "\\[(\\*|\\d+)\\sTO\\s(\\*|\\d+)\\]";
    private static final Pattern rangePattern = Pattern.compile(RANGEQUERY_REGEX);

    private String field = null;
    private String text  = null;
    private long[] range = null;
    private boolean facet = false;
    private int operator = OPERATOR_NONE;

    public static final int OPERATOR_NONE = 0;
    public static final int OPERATOR_AND  = 1;
    public static final int OPERATOR_NOT  = 2;
    public static final int OPERATOR_OR   = 3;

    public static int getOperatorType(char ch)
    {
        int op = OPERATOR_NONE;
        if      (ch == '+') op = OPERATOR_AND;
        else if (ch == '-') op = OPERATOR_NOT;
        else if (ch == '|') op = OPERATOR_OR;
        return op;
    }

    /**
     * Costruttore che interpreta la stringa come copia "field:value".
     *
     * @param field
     * @param text
     */
    public SearchTerm(String query)
    {
       String[] arr = query.split(":");
       setField(arr[0]);
       setText(arr[1]);
    }


    public SearchTerm(String field, String text)
    {
        setField(field);
        setText(text);
    }

    public SearchTerm(String field, String text, String operator)
    {
        setField(field);
        setText(text);
        setOperator(operator);
    }

    public SearchTerm(String field, String text, char op)
    {
        setField(field);
        setText(text);
        setOperator(op);
    }

    public SearchTerm(String field, String text, int op)
    {
        setField(field);
        setText(text);
        setOperator(op);
    }



    public void setField(String field)
    {
        this.field = field;
        if (field != null)
           facet = this.field.endsWith("_fc");
    }

    public void setText(String text)
    {
        this.text  = text;
        extractLuceneRangeValues(text);

    }

    public void setFacet(boolean flag)
    {
        this.facet = flag;
    }

    public String getField()
    {
        return this.field;
    }

    public String getValue()
    {
        return this.text;
    }

    public boolean isFacet()
    {
        return this.facet;
    }

    public boolean isValid()
    {
        return (this.field != null && this.text != null);
    }

    public boolean isRequired()
    {
        return (operator == OPERATOR_AND);
    }

    public void setOperator(String op)
    {
        if (op != null)
           operator = getOperatorType(op.charAt(0));
    }

    public void setOperator(char op)
    {
        operator = getOperatorType(op);
    }

    public void setOperator(int op)
    {
        switch (op)
        {
            case OPERATOR_AND:
            case OPERATOR_NOT:
            case OPERATOR_OR : operator = op; break;
            default:           operator = OPERATOR_NONE;
        }
    }

    public int getOperator()
    {
        return operator;
    }

    public String getOperatorAsString()
    {
        String op = "";
        if      (operator == OPERATOR_AND) op = "+";
        else if (operator == OPERATOR_NOT) op = "-";
        else     if (operator == OPERATOR_OR)  op = "|";
        return op;
    }


    public String toString()
    {
        return(this.field + ":" + this.text);
    }


    public long getFromValue(long def)
    {
        return (range == null) ? def : range[0];
    }

    public long getToValue(long def)
    {
        return (range == null) ? def : range[1];
    }

    private void extractLuceneRangeValues(String str)
    {
      Matcher m = rangePattern.matcher(str);
      if (m.matches())
      {
         range = new long[2];
         try
         {
            range[0] = Long.parseLong(m.group(1));
            range[1] = Long.parseLong(m.group(2));
         }
         catch(NumberFormatException ex)
         {
             range = null;
             System.err.println("invalid range values: " + m.group(1) + " , " + m.group(2));
         }
      }
    }


}//class//
