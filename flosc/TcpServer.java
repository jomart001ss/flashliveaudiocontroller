import java.awt.event.*;
import java.util.*;
import java.awt.*;
import java.io.*;
import java.net.*;

/**
 *
 * TcpServer
 * <BR><BR>
 * Flash XML Socket Server for Gateway.
 *
 * Based on CommServer by Derek Clayton.
 *
 *
 * @author  Ben Chun        ben@benchun.net
 * @version 1.0
 */

public class TcpServer extends Thread {
    private Vector clients = new Vector();  // all connected Flash clients
    private int port;                       // the TCP port
    ServerSocket server;                    // the TCP server
    Gateway gateway;                        // Gateway for this server
    
    /**
     * Constructor for the TcpServer.
     * @param   port   TCP port for Flash client connections.
     * @param   gateway  parent Gateway.
    */
    public TcpServer(int port, Gateway gateway) {
	this.port = port;
	this.gateway = gateway;
        System.out.println("TcpServer created...");
    }


    /**
     * Thread run method.  Monitors incoming messages.
    */	
    public void run() {
        try {
            // --- create a new TCP server
            server = new ServerSocket(port);
            Debug.writeActivity("TCP XML/Flash server started on port: " + port);
            // --- while the server is active...
            while(true) {
                // --- ...listen for new client connections
                Socket socket = server.accept();
                TcpClient client = new TcpClient(this, socket);
                Debug.writeActivity(client.getIP()+ " connected to TCP XML/Flash server.");
                // --- add the new client to our client list 
                clients.addElement(client);
                // --- start the client thread
                client.start();
            }
        } catch(IOException ioe) {
            Debug.writeActivity("Server error...Stopping TCP XML/Flash server");
            // kill this server
            killServer();
        } 
    }

    /**
     * Broadcasts a message to all connected Flash clients.
     * Messages are terminated with a null character.
     *
     * @param   message    The message to broadcast.
    */
    public synchronized void broadcastMessage(String message) {
        // --- add the null character to the message
        message += '\0';
        
        // --- enumerate through the clients and send each the message
        Enumeration enum = clients.elements();
        while (enum.hasMoreElements()) {
            TcpClient client = (TcpClient)enum.nextElement();
            client.send(message);
        }
    }

    /**
     * Takes incoming XML-encoded OSC and creates an OSC packet for
     * the Gateway to send.  This pseduo-parser method does not
     * validate the XML in any way, so client applications should take
     * care to send only well-formed XMl that would validate against
     * flosc.dtd (usually this is not a problem, since flosc.fla does
     * it correctly).
     *
     * @param   client    The TcpClient to remove.
     *
     */
    public void handleOsc(String oscxml) throws UnknownHostException {
	Debug.writeActivity("Received TCP packet, parsing XML...");

	// DEBUG
	//Debug.writeActivity(oscxml);

	//  parse the XML, create an OscPacket
	StringTokenizer st = new StringTokenizer(oscxml, " =<>\"", false);
	OscPacket packet = new OscPacket();

	// this gets ugly, i know.  it was this or a real xml parser.
	boolean validOSC = false;
	boolean inMessage = false;
	OscMessage message = new OscMessage("/ERROR");
	while (st.hasMoreTokens() ) {
	    String token = st.nextToken();
	    if (token.compareTo("OSCPACKET") == 0)
		validOSC = true;
	    if (token.compareTo("TIME") == 0)
		packet.setTime( Long.parseLong(st.nextToken()) );
	    if (token.compareTo("ADDRESS") == 0)
		packet.setAddress( InetAddress.getByName(st.nextToken()) );
	    if (token.compareTo("PORT") == 0)
		packet.setPort( Integer.parseInt(st.nextToken()) );

	    if (token.compareTo("MESSAGE") == 0) {
		inMessage = true;
		token = st.nextToken();
	    }

	    if (inMessage) {
		if(token.compareTo("NAME")  == 0)
		    message = new OscMessage( st.nextToken() );
		
		// TBD : change DTD to be <ARG TYPE="x">value
		// here</ARG>
	   
		// danger : relies on ARGUMENT attributes to occur in
		// order TYPE, VALUE
		
		if (token.compareTo("ARGUMENT") == 0) {
		    token = st.nextToken();
		    char tchar = 'i';
		    if (token.compareTo("TYPE") == 0) {
			tchar = st.nextToken().charAt(0);
			token = st.nextToken();
		    }
		    Character type = new Character(tchar);

		    if (token.compareTo("VALUE") == 0) {
			String value = st.nextToken();
			switch (tchar) {
			case 'i': case 'r': case 'm': case 'c':
			    Integer i = Integer.valueOf( value );
			    message.addArg(type, i);
			    break;
			case 'f':
			    Float f = Float.valueOf( value );
			    message.addArg(type, f);
			    break;
			case 'h': case 't':
			    Long l = Long.valueOf( value );
			    message.addArg(type, l);
			    break;
			case 'd':
			    Double d = Double.valueOf( value );
			    message.addArg(type, d);
			    break;
			case 's': case 'S':
			    message.addArg(type, unescape(value));
			    break;
			}
		    }
		}
	    }

	    if (token.compareTo("/MESSAGE") == 0) {
		packet.addMessage(message);
		inMessage = false;
	    }

	    if (!validOSC)
		Debug.writeActivity("Parse error: data outside OSCPACKET element");
	}
	
	gateway.sendPacket(packet);
    }


    /**
     * Replaces escape codes in a string with the literal
     * characters. (e.g.: "%20" is replaced with a space).
     *
     * (c) 2001 by Phil Scovis, all rights reserved.  This code is
     * provided as-is, without warranty.  You may copy, use, or
     * distribute this code, provided that you add value to it and
     * include this notice.
     *
     * @param s the string with escape codes.
     * @return the string with the escape codes replaced.
     */
    public String unescape(String s){
	String retval="";
	for (int i=0; i<s.length(); i++){
	    switch(s.charAt(i)){
	    case '%':
		String hexCode = s.substring(i+1, i+3);
		int hexValue = Integer.parseInt(hexCode,16);
		retval+=(char)hexValue;
		i+=2;
		break;
	    default:		
		retval+=s.charAt(i);
	    }
	}
	return retval;
    }
    
    


    /**
     * Removes clients from the client list.
     *
     * @param   client    The TcpClient to remove.
     *
    */
    public void removeClient(TcpClient client) {
        Debug.writeActivity(client.getIP() + " has disconnected from the server.");
        
        // --- remove the client from the list
        clients.removeElement(client);
        
    }

    /**
     * Stops the TCP server.
    */
    public void killServer() {
        try {
            // --- stop the server
            server.close();
            Debug.writeActivity("TCP XML/Flash server stopped");
        } catch (IOException ioe) {
            Debug.writeActivity("Error while stopping TCP XML/Flash server");
        }
    }
}
