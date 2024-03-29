import java.awt.event.*;
import java.util.*;
import java.awt.*;
import java.io.*;
import java.net.*;

/**
 *
 * OscServer
 * <BR><BR>
 * OpenSoundControl UDP Server for Gateway.
 *
 * Based on CommServer by Derek Clayton and dumpOSC by Matt Wright.
 *
 * Thanks to Jesse Gilbert (j@resistantstrain.net) for helping me with
 * the static socket.
 *
 * @author  Ben Chun        ben@benchun.net
 * @version 1.0
 */

public class OscServer extends Thread {
    private DatagramSocket oscSocket;       // incoming UDP socket
    private int port;                       // incoming UDP port
    private Gateway gateway;                // Gateway for this server
    private static OscSocket outSocket;     // outgoing UDP socket
    static 
    {
        try
	    {
		outSocket = new OscSocket();
	    }
        catch( SocketException se )
	    {
		se.printStackTrace();
	    }
    }
    
    /**
     * Constructor for the OscServer.
     *
     * @param   port     UDP port for OSC communication.
     * @param   gateway  parent Gateway.
    */
    public OscServer(int port, Gateway gateway) {
	this.port = port;
	this.gateway = gateway;
        System.out.println("OscServer created...");
    }

    /**
     * Thread run method.  Monitors incoming messages.
    */	
    public void run() {
	try{
	    // --- create a new UDP OSC socket
	    oscSocket = new DatagramSocket(port);
	    Debug.writeActivity("UDP OSC server started on port: " + port);
	    while(true) {
		byte[] datagram  = new byte[1024];
		DatagramPacket packet = new DatagramPacket(datagram, datagram.length);

		// block until a datagram is received
		oscSocket.receive(packet);

		// parse the packet
		Debug.writeActivity("Received UDP packet, parsing OSC...");
		OscPacket oscp = new OscPacket();
		oscp.address = packet.getAddress();
		oscp.port = packet.getPort();
		parseOscPacket(datagram, packet.getLength(), oscp);
		
		// then send it as XML to all the flash clients
		gateway.broadcastMessage( oscp.getXml() );

		// DEBUG
		//System.out.println("** raw packet **");
		//OscPacket.printBytes( datagram );
		//System.out.println("** constructed packet **");
		//OscPacket.printBytes( oscp.getByteArray() );

	    }
        } catch(IOException ioe) {
            Debug.writeActivity("Server error...Stopping UDP OSC server");
            // kill this server
            killServer();
        }
    }

    /**
     * This method is based on dumpOSC::ParseOSCPacket.  It verifies
     * that the packet is well-formed and puts the data into an
     * OscPacket object, or else prints useful error messages about
     * what went wrong.
     *
     * @param   datagram  a byte array containing the OSC packet
     * @param   n         size of the byte array
     * @param   packet    the OscPacket object to put data into
     */
    public void parseOscPacket(byte[] datagram, int n, OscPacket packet) {
	int size, i;

	if ( (n % 4) != 0 ) {
	    Debug.writeActivity("SynthControl packet size (" + n +
			  ") not a multiple of 4 bytes, dropped it.");
	    return;
	}

	String dataString = new String(datagram);
	if ( ( n >= 8 ) && dataString.startsWith( "#bundle" ) ) {
	    /* This is a bundle message. */
	    
	    if ( n < 16 ) {
		Debug.writeActivity("Bundle message too small (" + n +
			      " bytes) for time tag, dropped it.");
		return;
	    }

	    /* Get the time tag */
	    Long time = new Long( Bytes.toLong( Bytes.copy(datagram, 8, 8) ) );
	    packet.setTime(time.longValue());

	    i = 16; /* Skip "#bundle\0" and time tags */
	    while( i<n ) {
		size = ( Bytes.toInt( Bytes.copy(datagram, i, i+4 ) ) );
		if ((size % 4) != 0) {
		    Debug.writeActivity("Bad size count" + size +
				  "in bundle (not a multiple of 4)");
		    return;
		}
		if ( (size + i + 4) > n ) {
		    Debug.writeActivity("Bad size count" + size + "in bundle" +
				  "(only" + (n-i-4) + "bytes left in entire bundle)");
		    return;
		}
		
		/* Recursively handle element of bundle */
		byte[] remaining =  Bytes.copy(datagram, i+4);
		parseOscPacket(remaining, size, packet);
		i += (4 + size);
	    }
	} else {
	    /* This is not a bundle message */	    
	    Vector nameAndData = getStringAndData(datagram, n);

	    String name = (String) nameAndData.firstElement();
	    OscMessage message = new OscMessage(name);

	    byte[] data = (byte[]) nameAndData.lastElement();
	    Vector[] typesAndArgs = getTypesAndArgs(data);
	    message.setTypesAndArgs(typesAndArgs[0], typesAndArgs[1]);

	    packet.addMessage(message);
	}
    }

    /**
     * Takes a byte array starting with a string padded with null
     * characters so that the length of the entire block is a multiple
     * of 4, and seperates it into a String and a byte array of the
     * remaining data.  These are then returned in a Vector.
     *
     * @param   block           block of data beginning with a string
     * @param   stringLength    number of characters in the string
    */	
    public Vector getStringAndData(byte[] block, int stringLength) {
	Vector v = new Vector();
	int i;
	
	if ( stringLength %4 != 0) {
	    Debug.writeActivity("printNameAndArgs: bad boundary");
	    return v;
	}

	for (i = 0; block[i] != '\0'; i++) {
	    if (i >= stringLength) {
		Debug.writeActivity("printNameAndArgs: Unreasonably long string");
		return v;
	    }
	}
	// v.firstElement() is the String
	v.addElement( new String(Bytes.copy(block, 0, i)) );

	i++;
	for (; (i % 4) != 0; i++) {
	    if (i >= stringLength) {
		Debug.writeActivity("printNameAndArgs: Unreasonably long string");
		return v;
	    }
	    if (block[i] != '\0') {
		Debug.writeActivity("printNameAndArgs: Incorrectly padded string.");
		return v;
	    }
	}
	// v.elementAt(1) is the position in the orginal byte[] where the data starts
	v.addElement( new Integer(i) );
	// v.lastElement() is the byte[] of data
	v.addElement( Bytes.copy( block, i ) );
	return v;
    }

    /**
     * Returns an array of Vectors containing types and arguments.
     *
     * @param   block   byte array containing types and arguments
    */
    public Vector[] getTypesAndArgs( byte[] block ) {
	// TBD : throw exceptions or something when there are no type tags
	int n = block.length;
	Vector[] va = new Vector[2];
	if (n != 0) {
	    if (block[0] == ',') {
		if (block[1] != ',') {
		    /* This message begins with a type-tag string */
		    va = getTypeTaggedArgs( block );
		} else {
		    /* Double comma means an escaped real comma, not a
		     * type string */
		    va = getHeuristicallyTypeGuessedArgs( block );
		}
	    } else {
		va = getHeuristicallyTypeGuessedArgs( block );
	    }
	}
	return va;
    }

    /**
     * Returns Vectors containing the types and arguments from a
     * type-tagged byte array
     *
     * @param   block   a byte array with type-tagged data
    */
    public Vector[] getTypeTaggedArgs( byte[] block ) {
	Vector typeVector = new Vector();
	Vector argVector = new Vector();
	int p = 0;

	/* seperate the block into the types byte array and the
	 * argument byte array*/
	Vector typesAndArgs = getStringAndData(block, block.length);
	byte[] args = (byte[]) typesAndArgs.lastElement();
	
	for (int thisType=1; block[thisType] != 0; thisType++) {
	    switch (block[thisType]) {

	    case '[' :
		typeVector.addElement(new Character('['));
		break;

	    case ']' :
		typeVector.addElement(new Character(']'));
		break;

	    case 'i': case 'r': case 'm': case 'c':
		typeVector.addElement(new Character('i'));
		argVector.addElement( new Integer( Bytes.toInt( Bytes.copy(args, p, p+4) )) );
		p += 4;
		break;
		
	    case 'f':
		typeVector.addElement(new Character('f'));
		argVector.addElement( new Float( Bytes.toFloat( Bytes.copy(args, p, p+4) )) );
		p += 4;
		break;
		
	    case 'h': case 't':
		typeVector.addElement(new Character('h'));
		argVector.addElement( new Long( Bytes.toLong( Bytes.copy(args, p, p+8) )) );
		p += 8;
		break;
		
	    case 'd':
		typeVector.addElement(new Character('d'));
		argVector.addElement( new Double( Bytes.toDouble( Bytes.copy(args, p, p+8) )) );
		p += 8;
		break;
		
	    case 's': case 'S':
		typeVector.addElement(new Character('s'));
		byte[] remaining = Bytes.copy(args, p);
		Vector v = getStringAndData( remaining, remaining.length );
		argVector.addElement( (String)v.firstElement() );
		p += ((Integer)v.elementAt(1)).intValue();
		break;
		
	    case 'T':
		typeVector.addElement(new Character('T')); 
		break;
	    case 'F':
		typeVector.addElement(new Character('F'));
		break;
	    case 'N':
		typeVector.addElement(new Character('N'));
		break;
	    case 'I':
		typeVector.addElement(new Character('I'));
		break;

	    default:
		Debug.writeActivity( "[Unrecognized type tag " +
			       block[thisType] + "]" );
	    }
	}

	Vector[] returnValue = new Vector[2];
	returnValue[0] = typeVector;
	returnValue[1] = argVector;
	return returnValue;
    }
	

    /**
     * Returns the arguments from a non-type-tagged byte array
     *
     * @param   block   a byte array containing data
    */
    public Vector[] getHeuristicallyTypeGuessedArgs( byte[] block ) {
	// TBD : handle packets without type tags
	Debug.writeActivity("Bad OSC packet: No type tags");
	return new Vector[2];
    }


   /**
     * Sends an OscPacket via an OscSocket.  the packet contains the
     * address and port information.
     *
     * @param packet  the OscPacket to send
     */
    public void sendPacket(OscPacket packet) {

	try {
	    Debug.writeActivity("OscServer sending UDP packet...");
	    outSocket.send(packet);
	} catch(IOException ioe) {
            Debug.writeActivity("sendPacket error...Stopping UDP OSC server");
            // kill this server
            killServer();
        }
    }


    /**
     * Stops the UDP server.
    */
    public void killServer() {
	// --- close the socket
	oscSocket.close();
	Debug.writeActivity("UDP OSC server stopped");
    }
}
