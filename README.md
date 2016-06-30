This project links to a LoRa device via a serial interface, which could be USB (e.g. Prolific or FTDI adapter) or Bluetooth (e.g. HC-06).  It provides simple controls to set the LoRa parameters (frequency, bandwidth etc.), displays incoming telemetry packets, and optionally uploads those packets to the Habitat server.

Caveats and Limitations
-----------------------

- It does not currently support SSDV (Slow Scan Digital Video).
- It currently uses the old/simple "interim" Habitat interface, not the new shiny API.
- It's a Windows-only program

These will change quite soon.  Or not if this comment is still here in 6 months ...

Firmware
--------

Matching firmware for Arduino or compatible devices/chips available here - https://github.com/daveake/LoRaArduinoSerial

The serial protocol is described there.

Build
-----

The program was developed using Delphi 2009 with the TMS Async component for serial comms with the Arduino, and Indy HTTP component for HTTP upload to Habitat.  I've not tried but it should build fine with older or new Delphi versions, so long as those components are installed.

If you prefer something built with open source software, feel free to write in Python or whatever using the source and documentation as a guide; should be pretty easy.
