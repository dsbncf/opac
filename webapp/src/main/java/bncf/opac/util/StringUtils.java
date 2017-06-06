
package bncf.opac.util;

import java.util.ArrayList;
import java.util.regex.Pattern;
import java.util.regex.Matcher;


// spostato in bncf.opac.utils !


public class StringUtils
{
   private static final String TOKENIZER_REGEX  = "([^\\s\"]+)|(\"[^\"]+\")";
   private static final Pattern tokenPattern = Pattern.compile(TOKENIZER_REGEX);

   private static final String RANGEQUERY_REGEX = "\\[(\\*|\\d+)\\sTO\\s(\\*|\\d+)\\]";
   private static final Pattern rangePattern = Pattern.compile(RANGEQUERY_REGEX);

  private static char[] normalizedChar =
  {
     // 0     1     2     3     4     5     6     7     8     9
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
     // 10    11    12    13    14    15    16    17    18    19
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
     // 20    21    22    23    24    25    26    27    28    29
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
     // 30    31    32    33    34    35    36    37    38    39
        0,    0,    ' ',  0,    ' ' , ' ' , ' ' , ' ' , ' ' , ' ' ,
     // 40    41    42    43    44    45    46    47    48    49
        0,    0,    0,    ' ' , 0,    ' ' , 0,    ' ' , '0' , '1' ,
     // 50    51    52    53    54    55    56    57    58    59
        '2',  '3' , '4' , '5' , '6' , '7' , '8' , '9' , ' ' , 0,
     // 60    61    62    63    64    65    66    67    68    69
        ' ',  ' ' , ' ' , 0,    ' ' , 'A' , 'B' , 'C' , 'D' , 'E' ,
     // 70    71    72    73    74    75    76    77    78    79
        'F',  'G' , 'H' , 'I' , 'J' , 'K' , 'L' , 'M' , 'N' , 'O' ,
     // 80    81    82    83    84    85    86    87    88    89
        'P',  'Q' , 'R' , 'S' , 'T' , 'U' , 'V' , 'W' , 'X' , 'Y' ,
     // 90    91    92    93    94    95    96    97    98    99
        'Z',  0,    ' ' , 0,    0,    0,    0,    'A' , 'B' , 'C' ,
     // 100   101   102   103   104   105   106   107   108   109
        'D',  'E' , 'F' , 'G' , 'H' , 'I' , 'J' , 'K' , 'L' , 'M' ,
     // 110   111   112   113   114   115   116   117   118   119
        'N',  'O' , 'P' , 'Q' , 'R' , 'S' , 'T' , 'U' , 'V' , 'W' ,
     // 120   121   122   123   124   125   126   127   128
        'X',  'Y' , 'Z' , 0,    0,    0,    0,    0,    0
  };

  // operators for MySql full-text search are not replaced
  // '"' = 34, '\'' = 39, '(' = 40, ')' = 41, '+' = 43,
  // '-' = 45, '*'  = 42, '<' = 60, '>' = 62
  private static char[] normalizedCharFullText =
  {
     // 0     1     2     3     4     5     6     7     8     9
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
     // 10    11    12    13    14    15    16    17    18    19
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
     // 20    21    22    23    24    25    26    27    28    29
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
     // 30    31    32    33    34    35    36    37    38    39
        0,    0,    ' ',  0,    '"' , ' ' , ' ' , ' ' , ' ' , '\'' ,
     // 40    41    42    43    44    45    46    47    48    49
        '(',  ')',  '*',  '+' , 0,    '-' , 0,    ' ' , '0' , '1' ,
     // 50    51    52    53    54    55    56    57    58    59
        '2',  '3' , '4' , '5' , '6' , '7' , '8' , '9' , ' ' , 0,
     // 60    61    62    63    64    65    66    67    68    69
        '<',  ' ' , '>' ,  0  , ' ' , 'A' , 'B' , 'C' , 'D' , 'E' ,
     // 70    71    72    73    74    75    76    77    78    79
        'F',  'G' , 'H' , 'I' , 'J' , 'K' , 'L' , 'M' , 'N' , 'O' ,
     // 80    81    82    83    84    85    86    87    88    89
        'P',  'Q' , 'R' , 'S' , 'T' , 'U' , 'V' , 'W' , 'X' , 'Y' ,
     // 90    91    92    93    94    95    96    97    98    99
        'Z',  0,    ' ' , 0,    0,    0,    0,    'A' , 'B' , 'C' ,
     // 100   101   102   103   104   105   106   107   108   109
        'D',  'E' , 'F' , 'G' , 'H' , 'I' , 'J' , 'K' , 'L' , 'M' ,
     // 110   111   112   113   114   115   116   117   118   119
        'N',  'O' , 'P' , 'Q' , 'R' , 'S' , 'T' , 'U' , 'V' , 'W' ,
     // 120   121   122   123   124   125   126   127   128
        'X',  'Y' , 'Z' , 0,    0,    0,    0,    0,    0
  };


  /**
   * Converte in stringa normalizzata nel charset ascii standard.
   */
  public static synchronized String  utf8ToNorm(String utf8encoded)
  {
     if (utf8encoded == null)
        return null;

     char[]   utfchars = utf8encoded.toCharArray();
     int           len = utfchars.length;
     StringBuilder dest = new StringBuilder(len+5);

     for ( int j = 0 ; j < len ; ++j )
     {
        if ( utfchars[j] > 127 )
        {
           dest.append(uctonorm(utfchars[j]));
        }
        else
        {
           char c = normalizedChar[utfchars[j]];
           if (c > 0)
             dest.append(c);
        }
     }
     return dest.toString();
  }


  /**
   * Converte in stringa normalizzata nel charset ascii standard.
   * lascia i wildcards ('*' e '?')
   */
  public static synchronized String  utf8ToNormWC(String utf8encoded)
  {
     if (utf8encoded == null)
        return null;

     char[]   utfchars = utf8encoded.toCharArray();
     int           len = utfchars.length;
     StringBuilder dest = new StringBuilder(len+5);

     for ( int j = 0 ; j < len ; ++j )
     {
        if ( utfchars[j] > 127 )
        {
           dest.append(uctonorm(utfchars[j]));
        }
        else
        {
           char c = normalizedCharFullText[utfchars[j]];
           if (c > 0)
             dest.append(c);
        }
     }
     return dest.toString().replaceAll("\\s\\s+"," ").trim();
  }


  /**
   * Converte in stringa normalizzata e compatta spazi multipli, esclude caratteri di ordinamento.
   * Spazi multipli consecutivi vengono sostituiti con uno solo spazio,
   * spazi finali vengono eliminati.
   * Le seguenze di caratteri inclusi fra i delimitatori "no-sort" (0x0098 e 0x009C)
   * vengono eliminati, compresi i delimitatori.
   */
  public static synchronized String  utf8ToNormOrd(String utf8encoded, boolean compactSpace)
  {
     if (utf8encoded == null)
        return null;
     String s = utf8ToNorm(utf8encoded.replaceAll("[^]*",""));
     return ((s != null) && compactSpace) ? s.replaceAll("\\s\\s+"," ").trim() : null;
  }



  /**
   * Converte in stringa normalizzata e compatta spazi multipli.
   * Spazi multipli consecutivi vengono sostituiti con uno solo spazio,
   * spazi finali vengono eliminati.
   */
  public static synchronized String  utf8ToNorm(String utf8encoded, boolean compactSpace)
  {
     String s = utf8ToNorm(utf8encoded);
     return ((s != null) && compactSpace) ? s.replaceAll("\\s\\s+"," ").trim() : null;
  }


  /**
   * Tokenizes string into words and/or phrases.
   *
   * Estrae parole da una stringa; ogni parola diventa un token;
   * piu parole racchise fra doppie virgolette (") formano un token
   * (doppie virgolette comprese).
   * Esempio:
   * la stringa "spagnola \"antille viaggi\" lingua"
   * genera i seguenti token:
   *    spagnola
   *    "antille viaggi"
   *    lingua
   */
  public static String[] extractLucenePhrases(String str)
  {
     String expr = str.replaceAll("\\|\\s+","|").replaceAll("\\+\\s+","+").replaceAll("-\\s+","-");
     Matcher matcher = tokenPattern.matcher(expr);
     ArrayList<String> list = new ArrayList<String>();
     while (matcher.find())
        list.add(matcher.group());
     return list.toArray(new String[0]);
  }


  public static String[] extractLuceneRangeValues(String str)
  {
     String[] range = new String[2];

     Matcher m = rangePattern.matcher(str);
     if (m.matches())
     {
        // System.out.println("count="+m.groupCount());
        range[0] = m.group(1);
        range[1] = m.group(2);
        // System.out.println("range[0]="+range[0]+", range[1]="+range[1]);
     }
     return range;
  }




  public static int unsignedByteToInt(byte b)
  {
      return (b & 0xFF);
  }


  private static String  uctonorm( char uc )
  {
     switch(uc)
     {
       case 132:  return "";
       case 146:  return "";
       case 161:  return "";
       case 162:  return " ";
       case 163:  return " ";
       case 165:  return " ";
       case 167:  return "";
       case 169:  return "C";
       case 170:  return "A";
       case 171:  return "";
       case 174:  return "R";
       case 176:  return " ";
       case 177:  return " ";
       case 178:  return "2";
       case 179:  return "3";
       case 181:  return "MM";
       case 182:  return "";
       case 185:  return "1";
       case 186:  return "O";
       case 187:  return "";
       case 191:  return "";
       case 192:  return "A";
       case 193:  return "A";
       case 194:  return "A";
       case 195:  return "A";
       case 196:  return "A";
       case 197:  return "A";
       case 198:  return "AE";
       case 199:  return "C";
       case 200:  return "E";
       case 201:  return "E";
       case 202:  return "E";
       case 203:  return "E";
       case 204:  return "I";
       case 205:  return "I";
       case 206:  return "I";
       case 207:  return "I";
       case 208:  return "D";
       case 209:  return "N";
       case 210:  return "O";
       case 211:  return "O";
       case 212:  return "O";
       case 213:  return "O";
       case 214:  return "O";
       case 216:  return "O";
       case 217:  return "U";
       case 218:  return "U";
       case 219:  return "U";
       case 220:  return "U";
       case 221:  return "Y";
       case 223:  return "SS";
       case 224:  return "A";
       case 225:  return "A";
       case 226:  return "A";
       case 227:  return "A";
       case 228:  return "A";
       case 229:  return "A";
       case 230:  return "AE";
       case 231:  return "C";
       case 232:  return "E";
       case 233:  return "E";
       case 234:  return "E";
       case 235:  return "E";
       case 236:  return "I";
       case 237:  return "I";
       case 238:  return "I";
       case 239:  return "I";
       case 240:  return "D";
       case 241:  return "N";
       case 242:  return "O";
       case 243:  return "O";
       case 244:  return "O";
       case 245:  return "O";
       case 246:  return "O";
       case 247:  return " ";
       case 248:  return "O";
       case 249:  return "U";
       case 250:  return "U";
       case 251:  return "U";
       case 252:  return "U";
       case 253:  return "Y";
       case 257:  return "A";
       case 258:  return "A";
       case 259:  return "A";
       case 260:  return "A";
       case 261:  return "A";
       case 262:  return "C";
       case 263:  return "C";
       case 264:  return "C";
       case 265:  return "C";
       case 266:  return "C";
       case 267:  return "C";
       case 268:  return "C";
       case 269:  return "C";
       case 270:  return "D";
       case 271:  return "D";
       case 273:  return "D";
       case 275:  return "E";
       case 277:  return "E";
       case 278:  return "E";
       case 279:  return "E";
       case 280:  return "E";
       case 281:  return "E";
       case 282:  return "E";
       case 283:  return "E";
       case 284:  return "G";
       case 285:  return "G";
       case 286:  return "G";
       case 287:  return "G";
       case 288:  return "G";
       case 289:  return "G";
       case 290:  return "G";
       case 292:  return "H";
       case 293:  return "H";
       case 294:  return "H";
       case 295:  return "H";
       case 296:  return "I";
       case 297:  return "I";
       case 299:  return "I";
       case 300:  return "I";
       case 301:  return "I";
       case 302:  return "I";
       case 303:  return "I";
       case 304:  return "I";
       case 305:  return "I";
       case 306:  return "IJ";
       case 307:  return "IJ";
       case 308:  return "J";
       case 309:  return "J";
       case 310:  return "K";
       case 311:  return "K";
       case 312:  return "K";
       case 313:  return "L";
       case 314:  return "L";
       case 315:  return "L";
       case 316:  return "L";
       case 319:  return "L";
       case 320:  return "L";
       case 321:  return "L";
       case 322:  return "L";
       case 323:  return "N";
       case 324:  return "N";
       case 325:  return "N";
       case 326:  return "N";
       case 327:  return "N";
       case 328:  return "N";
       case 329:  return "N";
       case 330:  return "N";
       case 331:  return "N";
       case 333:  return "O";
       case 335:  return "O";
       case 336:  return "O";
       case 337:  return "O";
       case 338:  return "OE";
       case 339:  return "OE";
       case 340:  return "R";
       case 341:  return "R";
       case 342:  return "R";
       case 343:  return "R";
       case 344:  return "R";
       case 345:  return "R";
       case 346:  return "S";
       case 347:  return "S";
       case 348:  return "S";
       case 349:  return "S";
       case 350:  return "S";
       case 351:  return "S";
       case 352:  return "S";
       case 353:  return "S";
       case 356:  return "T";
       case 357:  return "T";
       case 358:  return "T";
       case 359:  return "T";
       case 360:  return "U";
       case 361:  return "U";
       case 362:  return "U";
       case 363:  return "U";
       case 365:  return "U";
       case 366:  return "U";
       case 367:  return "U";
       case 368:  return "U";
       case 369:  return "U";
       case 370:  return "U";
       case 371:  return "U";
       case 372:  return "W";
       case 373:  return "W";
       case 374:  return "Y";
       case 375:  return "Y";
       case 376:  return "Y";
       case 377:  return "Z";
       case 378:  return "Z";
       case 379:  return "Z";
       case 380:  return "Z";
       case 381:  return "Z";
       case 382:  return "Z";
       case 420:  return "TH";
       case 421:  return "TH";
       case 461:  return "A";
       case 462:  return "A";
       case 464:  return "I";
       case 486:  return "G";
       case 487:  return "G";
       case 488:  return "K";
       case 697:  return "";
       case 698:  return "";
       case 702:  return "";
       case 703:  return "";
       case 769:  return "";
       case 772:  return "";
       case 773:  return "";
       case 774:  return "";
       case 775:  return "";
       case 779:  return "";
       case 780:  return "";
       case 782:  return "";
       case 789:  return "";
       case 801:  return "";
       case 803:  return "";
       case 814:  return "";
       case 817:  return "";
       case 913:  return "A";
       case 914:  return "B";
       case 915:  return "G";
       case 916:  return "D";
       case 917:  return "E";
       case 918:  return "Z";
       case 919:  return "E";
       case 920:  return "TH";
       case 921:  return "I";
       case 922:  return "K";
       case 923:  return "L";
       case 924:  return "M";
       case 925:  return "N";
       case 926:  return "X";
       case 927:  return "O";
       case 928:  return "P";
       case 929:  return "R";
       case 931:  return "S";
       case 932:  return "T";
       case 933:  return "Y";
       case 934:  return "PH";
       case 935:  return "CH";
       case 936:  return "PS";
       case 937:  return "O";
       case 945:  return "A";
       case 946:  return "B";
       case 947:  return "G";
       case 948:  return "D";
       case 949:  return "E";
       case 950:  return "Z";
       case 951:  return "E";
       case 952:  return "TH";
       case 953:  return "I";
       case 954:  return "K";
       case 955:  return "L";
       case 956:  return "M";
       case 957:  return "N";
       case 958:  return "X";
       case 959:  return "O";
       case 960:  return "P";
       case 961:  return "R";
       case 962:  return "S";
       case 963:  return "S";
       case 964:  return "T";
       case 965:  return "Y";
       case 966:  return "PH";
       case 967:  return "CH";
       case 968:  return "PS";
       case 969:  return "O";
       case 986:  return "6";
       case 987:  return "6";
       case 988:  return "6";
       case 989:  return "6";
       case 990:  return "90";
       case 991:  return "90";
       case 992:  return "900";
       case 993:  return "900";
       case 8216:  return "";
       case 8218:  return "";
       case 8224:  return " ";
       case 8225:  return " ";
       case 8228:  return "X";
       case 8242:  return " ";
       case 8243:  return " ";
       case 8304:  return "0";
       case 8308:  return "4";
       case 8309:  return "5";
       case 8310:  return "6";
       case 8311:  return "7";
       case 8312:  return "8";
       case 8313:  return "9";
       case 8320:  return "0";
       case 8321:  return "1";
       case 8322:  return "2";
       case 8323:  return "3";
       case 8324:  return "4";
       case 8325:  return "5";
       case 8326:  return "6";
       case 8327:  return "7";
       case 8328:  return "8";
       case 8329:  return "9";
       case 8364:  return " ";
       case 8471:  return "P";
       case 8482:  return "TM";
       case 9834:  return " ";
       case 9837:  return "B";
     }
     return "";
  }



 public static void main( String[] args )
 {
    String s = null;

      s = "La Città futurista";
      System.out.println( s );
      System.out.println( utf8ToNorm(s) );

      s = "\u2122x\u03e0x\u03e1x\u00f7";
      System.out.println( s );
      System.out.println( utf8ToNorm(s) );

      s = "la @casa ;degli spiriti";
      System.out.println( s );
      System.out.println( utf8ToNorm(s) );
 }


}//class//


