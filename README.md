This project links to a LoRa device via a serial interface, which could be USB (e.g. Prolific or FTDI adapter) or Bluetooth (e.g. HC-06).  It provides simple controls to set the LoRa parameters (frequency, bandwidth etc.), displays incoming telemetry packets, and optionally uploads those packets to the Habitat server.

Capabilities
------------

- Allows the LoRa frequency, bandwidth etc. to be set
- Displays RSSI etc from the LoRa module
- Displays incoming packets
- Uploads telemetry to the Habitat servers
- Uploads SSDV packets to the Habitat servers
- All uploads are done in threads

Caveats and Limitations
-----------------------

- It currently uses the old/simple "interim" Habitat interface, not the new shiny API.
- It's a Windows-only program

Firmware
--------

Matching firmware for Arduino or compatible devices/chips available here - https://github.com/daveake/LoRaArduinoSerial

The serial protocol is described there.

** Note ** V1.1 of this Winbdows program requires V1.1 of the firmware, because the baud rate is now 57,600 on both (was 9,600 on V1.0)

Build
-----

The program was developed using Delphi 2009 with the TMS Async component for serial comms with the Arduino, and Indy HTTP component for HTTP upload to Habitat.  I've not tried but it should build fine with older or new Delphi versions, so long as those components are installed.

If you prefer something built with open source software, feel free to write in Python or whatever using the source and documentation as a guide; should be pretty easy.

History
-------

23/09/2016	V1.1	- Added LoRa modes 3-7
					- Added SSDV uploader
					- SSDV and telemetry uploaders are now threads
					- Baud rate now 57,600

