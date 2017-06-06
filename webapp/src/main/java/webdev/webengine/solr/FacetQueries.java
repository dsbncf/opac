/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package webdev.webengine.solr;

import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author ds
 */
public class FacetQueries extends ArrayList<FacetInfo>
{
    private static final Logger logger = LoggerFactory.getLogger(FacetQueries.class);
    
   
    public void addQuery(String name, String value)
    {
        String query[] = name.split(":");
        getFacetInfo(query[0]).add(new FacetEntry(query[1],value));
        logger.debug("added: " + query[0] + " - " + query[1] + " - " + value);
    }
    
    private FacetInfo getFacetInfo(String name)
    {
        for (FacetInfo fi : this)
            if (fi.getName().equals(name))
                return fi;
        FacetInfo fi = new FacetInfo(name);
        this.add(fi);
        return fi;
    }
    
    /*    
    public StringBuilder toStringBuilder()
    {
        StringBuilder sb = new StringBuilder();
        sb.append("Facet: ").append(name).append("\n");

        for (FacetInfo fi : this)
        {
           // sb.append("\n").append(fe.getName()).append(":\t").append(fe.getCount());
        }
        sb.append("\n");
        return sb;
    }
    */
         
    
    
}//class//
