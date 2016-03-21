We wanted to make (multiplayer) flash games which could be controlled by your own voice. We first thought this would be very simple, since flash CS3 allows you to do a fft analysis on audio sources. However, this computeSpectrum function does not work on the microphone input (what a shame!).

We have created an alternative approach for this (worldwide) known problem. We made a MaxMSP patch that does the FFT analysis and sends a OSC package to flash (with the help of a small java application). MAX/MSP sends the Amplitude and the pitch of a stereo signal (left and right). So, now we could use the input of the microphone to make a two-player game. If you only have one input they will both send the same data. In fact you will only get four paramaters in flash, you can do whatever you want with it (be creative)!


First you have to checkout the package thats available on our svn-repository.
If you’ve got the package, unzip it and use your console to start the FLOSC server;

java Gateway 7000 3000

![http://images.6angrymen.com/SoundController/terminal.jpg](http://images.6angrymen.com/SoundController/terminal.jpg)

When this java server is running you can launch the MAX/MSP file that is located in the “maxmsp/Runtimes/” folder. It’s available for both windows and mac. We also included the MAX/MSP source code so you can change the patch the way you like.

When you launch the MAX/MSP patch it should look like this:
![http://patrick.inlet.nl/googlecode/maxmsp.jpg](http://patrick.inlet.nl/googlecode/maxmsp.jpg)

Also make sure that in your Flash Settings you can always access your microphone. You can do this by editing your global security settings and ‘add a location’. Fill in a slash (/) here.

Then it’s all set to run the pong game! You can find it in the swfs folder!


Please us know if you have any trouble running it, or if you have created something with it.

The steps summarized:
  * Run the FLOSC server
  * Run the application file (in “maxmsp/Runtimes/”)
  * Run the SWF
  * Give permission to access your microphone
  * Play!

We released this project under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Netherlands License, so please Share alike!
![http://patrick.inlet.nl/googlecode/88x31.png](http://patrick.inlet.nl/googlecode/88x31.png)