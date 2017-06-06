

package bncf.opac.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;



public class RelazioniSoggetti
{
  private HashMap<String,ArrayList<String>> preferredHSF = null;
  private HashMap<String,ArrayList<String>> preferredUF  = null;
  private HashMap<String,String> usedforHSF = null;
  private HashMap<String,String> usedforUF  = null;


  public RelazioniSoggetti(File file) throws Exception
  {
     load(new FileInputStream(file));
  }

  
  public RelazioniSoggetti(InputStream inputStream) throws Exception
  {
     load(inputStream);
  }


  /**
   * Lettura dati da file di export dei soggetti.
   *
   * Formato file input:
   * <code>5|Lingue indoeuropee orientali|UF|6|Lingue satem</code>
   *
   * i quattro campi sono:
   *
   *    [0] id di partenza
   *    [1] termine di partenza (preferito)
   *    [2] tipo di relazione
   *    [3] id di arrivo
   *    [4] termine di arrivo (preferito)
   */
  private void load(InputStream inputStream) throws Exception
  {
     preferredHSF = new HashMap<>();
     usedforHSF   = new HashMap<>();
     preferredUF  = new HashMap<>();
     usedforUF    = new HashMap<>();

     BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
     String line;
     while ((line = reader.readLine()) != null)
     {
        String[] fields = line.trim().split("\\|");
        switch (fields[2])
        {
           case "UF":
              loadUF(fields[1],fields[4]);
              break;
           case "HSF":
              loadHSF(fields[1],fields[4]);
              break;
        }
     }
  }


  public ArrayList<String> getUF(String val)
  {
     return preferredUF.get(val);
  }

  public String getPreferredUF(String val)
  {
     return usedforUF.get(val);
  }

  public ArrayList<String> getHSF(String val)
  {
     return preferredHSF.get(val);
  }

  public String getPreferredHSF(String val)
  {
     return usedforHSF.get(val);
  }


  /**
   * Carica le relazioni di tipo HSF.
   *
   * Ad un termine preferito possono essere abbinate piu di un'termine,
   * mentre un termine (usedfor) rimanda sempre solo ad un termine preferito.
   * Nel primo caso si associa un ArrayList di varianti al termine preferito,
   * nel secondo caso e' una semplice associazione fra due String.
   */
  private void loadHSF(String preferred, String usedfor)
  {
      // realzione preferred -> usedfor (relazione 1-N)
      ArrayList<String> used = preferredHSF.get(preferred);
      if (used == null)
      {
         used = new ArrayList<>(1);
         used.add(usedfor);
         preferredHSF.put(preferred,used);
      }
      else
        if (!used.contains(usedfor))
           used.add(usedfor);

      // realzione inversa usedfor -> preferred
      if (! usedforHSF.containsKey(usedfor))
         usedforHSF.put(usedfor,preferred);
  }

  /**
   * Carica le relazioni di tipo UF.
   *
   * Ad un termine preferito possono essere abbinate piu di un'termine,
   * mentre un termine (usedfor) rimanda sempre solo ad un termine preferito.
   * Nel primo caso si associa un ArrayList di varianti al termine preferito,
   * nel secondo caso e' una semplice associazione fra due String.
   */
  private void loadUF(String preferred, String usedfor)
  {
      // realzione preferred -> usedfor (relazione 1-N)
      ArrayList<String> used = preferredUF.get(preferred);
      if (used == null)
      {
         used = new ArrayList<>(1);
         used.add(usedfor);
         preferredUF.put(preferred,used);
      }
      else
        if (!used.contains(usedfor))
           used.add(usedfor);

      // realzione inversa usedfor -> preferred
      if (! usedforUF.containsKey(usedfor))
         usedforUF.put(usedfor,preferred);
  }


}//class//
