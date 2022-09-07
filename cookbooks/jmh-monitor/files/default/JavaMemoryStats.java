import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.Integer;
import java.net.InetAddress;
import javax.management.MBeanServerConnection;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;
import java.util.Date;

//http://docs.oracle.com/javase/7/docs/api/java/lang/management/MemoryMXBean.html

public class JavaMemoryStats {
	/**
	 * * @param args
	 * */
	public static void main(String[] args) throws Exception {
	        if (args.length  < 3) {
	                System.out.println("Need 3 parameters");
	                System.out.println("Usage: java JavaHeap <jmx port> <jmx app name> <server>");
	                System.exit(1);
	        }
	        String jmxport = args[0];
	        String jmxapp = args[1];
	        String server = args[2];
	
	        JMXServiceURL u = new JMXServiceURL(
	               "service:jmx:rmi:///jndi/rmi://localhost:" + jmxport + "/jmxrmi");
	        JMXConnector c = JMXConnectorFactory.connect(u);
	        MBeanServerConnection mbsc = c.getMBeanServerConnection();
	        MemoryMXBean mbean =  ManagementFactory.getMemoryMXBean();
	        //ThreadMXBean tbean = ManagementFactory.getThreadMXBean();
	        long timestamp = new Date().getTime()/1000; // 1000 puts the timstamp in Graphite order
	
	        String outputPrefix = server + "." + jmxapp + ".jvmmemory";
	
	        System.out.println(outputPrefix + ".heapmax" + "\t" + mbean.getHeapMemoryUsage().getMax()/1024  + "\t" + timestamp);
	        System.out.println(outputPrefix + ".heapused" + "\t" + mbean.getHeapMemoryUsage().getUsed()/1024 + "\t" + timestamp);
	        System.out.println(outputPrefix + ".heapinit" + "\t" + mbean.getHeapMemoryUsage().getInit()/1024 + "\t" + timestamp);
	        System.out.println(outputPrefix + ".heapcommitted" + "\t" + mbean.getHeapMemoryUsage().getCommitted()/1024 + "\t" + timestamp);
	        System.out.println(outputPrefix + ".nonheapmax" + "\t" + mbean.getNonHeapMemoryUsage().getMax()/1024 + "\t" + timestamp);
	        System.out.println(outputPrefix + ".nonheapused" + "\t" + mbean.getNonHeapMemoryUsage().getUsed()/1024 + "\t" + timestamp);
	        System.out.println(outputPrefix + ".nonheapinit" + "\t" + mbean.getNonHeapMemoryUsage().getInit()/1024 + "\t" + timestamp);
	        System.out.println(outputPrefix + ".nonheapcommitted" + "\t" + mbean.getNonHeapMemoryUsage().getCommitted()/1024 + "\t" + timestamp);
	        System.out.println("");
	        //System.out.println(mbean.getNonHeapMemoryUsage());
	}

}
