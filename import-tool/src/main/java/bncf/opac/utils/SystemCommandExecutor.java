
package bncf.opac.utils;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;


/**
 */
public class SystemCommandExecutor
{
   private static final Logger logger = LoggerFactory.getLogger(SystemCommandExecutor.class);
   private StreamGobbler errorGobbler = null;
   private StreamGobbler outputGobbler = null;


   public int executeCommand(String[] cmd) throws IOException, InterruptedException
   {
      ProcessBuilder pb = new ProcessBuilder(cmd);
      Process proc = pb.start();
      // capture both stdout and stderr data from process
      errorGobbler = new StreamGobbler(proc.getErrorStream());
      outputGobbler = new StreamGobbler(proc.getInputStream());
      errorGobbler.start();
      outputGobbler.start();
      int exitCode = proc.waitFor();
      errorGobbler.join();
      outputGobbler.join();
      return exitCode;
   }


   public String getOutput()
   {
      return (outputGobbler == null) ? null : outputGobbler.getContent();
   }


   public String getErrorOutput()
   {
      return (errorGobbler == null) ? null : errorGobbler.getContent();
   }

} //class//
