
package bncf.opac.handler;


public class SearchHandlerException extends Exception
{

   public SearchHandlerException()
   {
      super();
   }

   public SearchHandlerException(String msg)
   {
      super(msg);
   }

   public SearchHandlerException(Throwable cause)
   {
      super(cause);
   }

   public SearchHandlerException(String msg, Throwable cause)
   {
      super(msg,cause);
   }

}
