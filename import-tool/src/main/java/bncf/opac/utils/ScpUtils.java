

package bncf.opac.utils;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


public class ScpUtils
{
   private static final Logger logger = LoggerFactory.getLogger(ScpUtils.class);

   private Session session = null;
   private int timeout = 15000; // default 15 seconds
   private boolean ptimestamp = true;

  public ScpUtils()
  {
    //
  }

  /**
   * Set connection timeout in milli seconds.
   * @param timeout milliseconds
   */
  public void setConnectionTimeout(int timeout)
  {
     this.timeout = timeout;
  }

  public void connect(String user, String passwd, String host) throws JSchException
  {
     connect(user, passwd, host, 22);
  }


  public void connect(String user, String passwd, String host, int port) throws JSchException
  {
      JSch jsch = new JSch();
      session = jsch.getSession(user, host, port);
      session.setConfig("StrictHostKeyChecking", "no");
      session.setConfig("PreferredAuthentications", "password");
      session.setTimeout(timeout);
      session.setPassword(passwd);
      session.connect();
  }


  public void disconnect()
  {
      session.disconnect();
  }


   public void copy(File fromFile, String toFilename) throws Exception
   {
      // exec 'scp -t rfile' remotely
      String command = "scp " + (ptimestamp ? "-p" : "") + " -t " + toFilename;
      Channel channel = session.openChannel("exec");
      ((ChannelExec) channel).setCommand(command);

      // get I/O streams for remote scp
      OutputStream out = channel.getOutputStream();
      InputStream in = channel.getInputStream();

      channel.connect();

      if (checkAck(in) != 0)
      {
         throw new Exception("Error on stream");
      }

      if (ptimestamp)
      {
         command = "T " + (fromFile.lastModified() / 1000) + " 0";
         // The access time should be sent here,
         // but it is not accessible with JavaAPI ;-<
         command += (" " + (fromFile.lastModified() / 1000) + " 0\n");
         out.write(command.getBytes());
         out.flush();
         if (checkAck(in) != 0)
         {
            throw new Exception("Error on stream");
         }
      }

      // send "C0644 filesize filename", where filename should not include '/'
      long filesize = fromFile.length();
      command = "C0644 " + filesize + " ";
      String fname = fromFile.getPath();
      if (fname.lastIndexOf('/') > 0)
      {
         command += fname.substring(fname.lastIndexOf('/') + 1);
      }
      else
      {
         command += fname;
      }
      command += "\n";
      out.write(command.getBytes());
      out.flush();
      if (checkAck(in) != 0)
      {
         throw new Exception("Error on stream");
      }

      FileInputStream fis = null;
      try
      {
         // send a content of lfile
         fis = new FileInputStream(fromFile);
         byte[] buf = new byte[1024];
         while (true)
         {
            int len = fis.read(buf, 0, buf.length);
            if (len <= 0)
            {
               break;
            }
            out.write(buf, 0, len); //out.flush();
         }
         // send '\0'
         buf[0] = 0;
         out.write(buf, 0, 1);
         out.flush();
      }
      finally
      {
         if (fis != null)
         {
            fis.close();
         }
      }
      if (checkAck(in) != 0)
      {
         throw new Exception("Error on stream");
      }
      out.close();
      channel.disconnect();
   }


   private int checkAck(InputStream in) throws IOException
   {
      int b = in.read();
      // b may be 0 for success,
      //          1 for error,
      //          2 for fatal error,
      //          -1
      if (b == 0)
      {
         return b;
      }
      if (b == -1)
      {
         return b;
      }

      if (b == 1 || b == 2)
      {
         StringBuilder sb = new StringBuilder();
         int c;
         do
         {
            c = in.read();
            sb.append((char) c);
         }
         while (c != '\n');
         if (b == 1)
         { // error
            logger.error(sb.toString());
         }
         if (b == 2)
         {
            logger.error(sb.toString());
         }
      }
      return b;
   }

} //class//
