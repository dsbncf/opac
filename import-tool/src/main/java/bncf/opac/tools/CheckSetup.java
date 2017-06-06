
package bncf.opac.tools;

import java.io.ByteArrayOutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;


public class CheckSetup
{

   public static void showSystemSettings()
   {
    	System.out.println("Default Charset.......: " + Charset.defaultCharset());
    	System.out.println("file.encoding.........: " + System.getProperty("file.encoding"));
    	System.out.println("Default Charset.......: " + Charset.defaultCharset());
    	System.out.println("Default Charset in Use: " + getDefaultCharSet());
    }

    private static String getDefaultCharSet() {
    	OutputStreamWriter writer = new OutputStreamWriter(new ByteArrayOutputStream());
    	String enc = writer.getEncoding();
    	return enc;
    }

    
   public static void main( String[] args )
   {
      showSystemSettings();
   }
   

} //class//
