
package bncf.opac.handler;


import bncf.opac.db.OpacUserDb;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * Questa servlet tratta i suggerimenti nella analitica controllandoli e salvandoli su db.
 */

public class SuggestHandler
{
   private static final String EMAIL_PATTERN =
    "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[_A-Za-z0-9-]+)";

    private static final Logger  logger = LoggerFactory.getLogger(SuggestHandler.class);
    private static final Pattern email_pattern = Pattern.compile(EMAIL_PATTERN);

    private final OpacUserDb userDb;
    
    private String email       = "";
    private String testo       = "";
    private String bid         = "";
    private String captcha     = "";
    private String sessCaptcha = "";
    private String ip          = null;

    private boolean errorsPresent = false;
    private String errorString = "";

   /**
    * Constructor
    *
    * @param userDb Database degli utenti, suggerimenti
    */
   public SuggestHandler(OpacUserDb userDb)
   {
      this.userDb = userDb;
   }



   /**
    * setValues: setta in una volta sola tutti i campi del suggerimento
    *
    * @param bid Bid della analitica
    * @param email Email dell'utente che lascia il messagio
    * @param testo Testo dell'utente che lascia il messagio
    * @param captcha Codice di controllo anti-span digitato dall'utente
    * @param sessCaptcha
    * @param ip Ip dell'utente
    */
   public void setValues(String bid, String email, String testo, String captcha,
			 String sessCaptcha, String ip)
   {
      this.bid = (bid == null) ? "" : bid.trim();
      this.email = (email == null) ? "" : email.trim();
      this.testo = (testo == null) ? "" : testo.trim();
      this.captcha = (captcha == null) ? "" : captcha.trim();
      this.sessCaptcha = sessCaptcha;
      this.ip = ip;
   }

   public boolean hasErrors()
   {
      return errorsPresent;
   }
   
   public String getErrorString()
   {
      return errorString;
   }

   /**
    * Verifica che gli attributi siano validi per il salvataggio su database.
    * 
    * - I campi sono tutti obbligatori. 
    * - verifica del formato dell'email
    * - Il testo non deve superare i 2000 caratteri.
    *
    * Il risultato e' una stringa che presenta in forma
    * compatta gli errori dei campi della segnalazione.
    * La variabile contiene in formato testo il numero
    * di errori e il tipo di errori. Il formato e' il seguente:
    * statusRichiesta|numeroCampiObbligatoriMancanti:nomecampo1,nomecampo2,|numeroCampiFormatoErrato:nomecampo1,nomecampo2,
    * Ad esempio:
    * ok -> la richiesta e' andata a buon fine
    * ko oppure ko|0:|0: -> la richiesta non e' andata a buon fine, errore generico
    * ko|1:email|0: -> la richiesta non e' andata a buon fine, un campo obbligatorio non e' stato compilato ("email")
    * ko|0:|2:email,testo -> la richiesta non e' andata a buon fine, due campi hanno un formato errato ("email" e "testo")
    * 
    * @return se sono presenti errori di verifica messaggio con "ko|..." altrimenti null;
    */
   public boolean isValid()
   {
      int errorRequired = 0;
      int errorCount = 0;
      int genericError = 0;
      
      ArrayList<String> required = new ArrayList<String>();
      ArrayList<String> bad = new ArrayList<String>();

      String result = null;

      if (bid.isEmpty())
      {
         required.add("bid");
      }

      if (email.isEmpty())
      {
         required.add("email");
      }
      else
      {

         Matcher m = email_pattern.matcher(email);
         if (!m.matches())
         {
            bad.add("email");
         }
      }

      if (testo.isEmpty())
      {
         required.add("testo");
      }
      else
      {
         if (testo.length() > 2000)
         {
            testo = testo.substring(0,2000);
         }
      }

      if (captcha.isEmpty())
      {
         required.add("captcha");
      }
      else
      {
         sessCaptcha = sessCaptcha.trim();
         if (!sessCaptcha.equals(captcha))
         {
            bad.add("captcha");
         }
      }

      if (ip == null)
      {
         genericError++;
      }

      if (genericError > 0)
      {
         errorsPresent = true;
      }

      if (errorRequired > 0 || errorCount > 0)
      {
         errorsPresent = true;
         StringBuilder sb = new StringBuilder("ko|");
         sb.append(required.size()).append(":").append(StringUtils.join(required, ","));
         sb.append("|").append(bad.size()).append(":").append(StringUtils.join(bad, ","));
         errorString = sb.toString();
      }
      return !errorsPresent;
   }

   /**
    * save: salva il suggerimento nel database.
    *
    * @return True se il suggerimento e' stato correttamente salvato
    */
   public boolean save()
   {
      if (errorsPresent)
      {
         return false;
      }
      return userDb.insertSegnalazione(bid, testo, email, ip);
   }

   
   public void close()
   {
      userDb.close();
   }

} //class//

