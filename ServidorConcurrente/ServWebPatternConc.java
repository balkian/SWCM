/*
* Juan Fernando Sánchez Rada
* Sergio Díaz Bautista
* SWCM 2010/11
*/

package ServidorConcurrente;

import java.util.*;   
import java.io.*;   
import java.net.*;

public class ServWebPatternConc { 
  public static int maxCon = 10;
  public static void main (String args[]) {        
    try {
      ServerSocket serv = new ServerSocket(8080);
      System.out.println("showserver created at port 8080.");
	ThreadGroup workers = new ThreadGroup("WebWorkers");

      while (true) {
	if(workers.activeCount()<maxCon){
  	 System.out.println("Hay "+workers.activeCount()+" hebras corriendo.");
         Socket conn = serv.accept();
	 Thread hs = new Thread(workers, new HebraServ(conn));
	 hs.start();
	}
	else{
	 try{
	 	Thread.sleep(500);
	 } 
	 catch(Exception ex){	
	 }
	}
      }
    } 
    catch (IOException e) { System.err.println(e); }
  }
}
