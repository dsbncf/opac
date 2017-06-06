

package bncf.opac.tools;

import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SimpleScheduleBuilder;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import static org.quartz.TriggerBuilder.newTrigger;

public class Dispatcher
{
   private static final Logger logger = LoggerFactory.getLogger(Dispatcher.class);
   private static final int MAIN_LOOP_WAIT = 3600000; // 1 hour
   private static final int CHECK_DELAY = 10; // 10 minutes
   private Scheduler scheduler = null;
   private int delayInSeconds = 0;
   private int delayInMinutes = 0;

   public Dispatcher()
   {
      //
   }

   public void setDelayInSeconds(int seconds)
   {
      delayInSeconds = seconds;
   }

   public void setDelayInMinutes(int minutes)
   {
      delayInMinutes = minutes;
   }

   public void start() throws SchedulerException
   {
      // define the job and tie it to our HDispatcherJob class
      JobDetail job = newJob(DispatcherJob.class).withIdentity("mainJob", "opac2").build();

      // Trigger the job to run now, and then every 40 seconds
      TriggerBuilder<Trigger> trbld = newTrigger().withIdentity("dispatchTrigger", "opac2");
      trbld.startNow();
      SimpleScheduleBuilder scbld;
      if (delayInSeconds > 0)
         scbld = simpleSchedule().withIntervalInSeconds(delayInSeconds).repeatForever();
      else if (delayInMinutes > 0)
         scbld = simpleSchedule().withIntervalInMinutes(delayInMinutes).repeatForever();
      else
         throw new SchedulerException("Delay for scheduler not defined");

      Trigger trigger = trbld.withSchedule(scbld).build();

      //schedule the job using the trigger
      scheduler = new StdSchedulerFactory().getScheduler();
      scheduler.start();
      scheduler.scheduleJob(job, trigger);
   }


   /**
    * Stop scheduler,  waiting until executing Jobs complete execution.
    *
    * @throws SchedulerException
    */
   public void shutdown() throws SchedulerException
   {
      if (scheduler != null)
         scheduler.shutdown(true); // does not return until executing Jobs complete execution
   }

   
   public static void showSystemSettings()
   {
    	logger.info("Default Charset: {}", Charset.defaultCharset());
    	logger.info("file.encoding : {}", System.getProperty("file.encoding"));
    	logger.info("Default Charset: {}", Charset.defaultCharset());
    	logger.info("Default Charset in Use: {}", getDefaultCharSet());
    }

    private static String getDefaultCharSet()
    {
    	OutputStreamWriter writer = new OutputStreamWriter(new ByteArrayOutputStream());
    	return writer.getEncoding();
    }

    
   public static void main( String[] args )
   {
      showSystemSettings();

      Dispatcher dispatcher = new Dispatcher();
      try
      {
         dispatcher.setDelayInMinutes(CHECK_DELAY);
         dispatcher.start();
      }
      catch (SchedulerException ex)
      {
         logger.error("Scheduler interrupted", ex);
         return;
      }

      boolean active = true;
      while (active)
      {
         try
         {
             Thread.sleep(MAIN_LOOP_WAIT);
         }
         catch(InterruptedException ex)
         {
            logger.error("Main thread interrupted", ex);
            active = false;
         }
      }
      try
      {
         dispatcher.shutdown();
      }
      catch (SchedulerException ex)
      {
         logger.error("Could not shutdown Scheduler", ex);
      }
   }

} //class//
