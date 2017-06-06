
package webdev.webengine.solr;


import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;


/**
 *
 * @author ds
 */
public class FacetInfo extends ArrayList<FacetEntry>
{
     public static final int SORT_BY_RANK = 0; // default
     public static final int SORT_BY_NAME = 1;
     public static final int SORT_ASC = 0; // default
     public static final int SORT_DESC = 1;

     private int sortedBy = SORT_BY_RANK;
     private int sortDir = SORT_ASC;

    private String name = null;

    public FacetInfo(String name)
    {
        this.name = name;
    }

    public String getName()
    {
        return name;
    }

    public StringBuilder toStringBuilder()
    {
        StringBuilder sb = new StringBuilder();
        sb.append("Facet: ").append(name).append("\n");

        for (FacetEntry fe : this)
        {
           sb.append("\n").append(fe.getName()).append(":\t").append(fe.getCount());
        }
        sb.append("\n");
        return sb;
    }



     public void sortByName()
     {
        sortByName(SORT_ASC);
     }

     public void sortByName(boolean ascendent)
     {
        sortByName(ascendent ? SORT_ASC : SORT_DESC);
     }

     private void sortByName(int sortDir)
     {
         if (sortedBy == SORT_BY_NAME)
            if (this.sortDir == sortDir)
               return;
         sort(new NameComparator(),sortDir);
     }


     public void sortByRank()
     {
        sortByRank(SORT_ASC);
     }

     public void sortByRank(boolean ascendent)
     {
        sortByRank(ascendent ? SORT_ASC : SORT_DESC);
     }

     private void sortByRank(int sortDir)
     {
         if (sortedBy == SORT_BY_NAME)
            if (this.sortDir == sortDir)
               return;
         sort(new RankComparator(),sortDir);
     }


     private void sort(Comparator<FacetEntry> comparator, int sortDir)
     {
         if (sortedBy == SORT_BY_NAME)
            if (this.sortDir == sortDir)
               return;

         Comparator<FacetEntry> comp;
         comp = (sortDir == SORT_ASC) ? comparator : Collections.reverseOrder(comparator);
         Collections.sort(this, comp);

         this.sortedBy = SORT_BY_NAME;
         this.sortDir = sortDir;
     }


     private class RankComparator implements Comparator<FacetEntry>
     {
        @Override
        public int compare(FacetEntry one, FacetEntry two)
        {
           int sdif = one.getCount() - two.getCount();
           return sdif;
        }
     }

     private class NameComparator implements Comparator<FacetEntry>
     {
        @Override
        public int compare(FacetEntry one, FacetEntry two)
        {
           int sdif = one.getName().compareToIgnoreCase(two.getName());
           return sdif;
        }
     }


}//class//
