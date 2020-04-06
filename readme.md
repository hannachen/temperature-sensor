# Wifi temperature sensor with ESP-01 and DHT22
![First iteration with enclosure](images/complete.jpg)

## Setup
- On the ESP-01, use a jumper wire to connect **GPIO0** and **GND** to enable **flash mode**
- Create a custom build of [NodeMCU 1.5.4.1-final](https://nodemcu-build.com/), with the following modules: **DHT, file, GPIO, HTTP, net, node, timer, UART, WiFi**
- Install [nodemcu v1.0 driver](https://cityos-air.readme.io/docs/1-mac-os-usb-drivers-for-nodemcu#section-13-nodemcu-v10-driver)
- Flash the ESP-01 wifi module position 0x00000 with custom built firmware (float version) using [esptool](https://github.com/espressif/esptool) i.e. `esptool.py --port /dev/tty.wchusbserial1410 write_flash 0x00000 ./nodemcu-1.5.4.1-final-9-modules-2020-04-03-04-23-13-float.bin`
- Use `stty -f /dev/cu.wchusbserial1410 115200 &` to set the serial Baud
- Download ESP8266 / NodeMCU / MicroPhython IDE [ESPlorer](https://github.com/4refr0nt/ESPlorer)
- Open **ESPlorer**, switch to **NodeMCU+MicroPython** tab
- Open and change settings in `config.lua`
- Rename `pull.lua` or `push.lua` to `init.lua`
- Upload `config.lua` and `init.lua` to the wifi module by clicking on **Save to ESP**

## Parts & Tools

### Components
- [ESP-01](http://www.icstation.com/esp8266-remote-serial-port-wifi-transceiver-wireless-module-apsta-p-4928.html)
- [DHT22](http://www.icstation.com/dht22am2302-digital-output-temp-sensor-module-temperature-humidity-sensor-dht22-p-1469.html)

### Development
- [USB to ESP8266 Serial Wireless Wi-Fi Module](http://www.icstation.com/wifi-module-esp8266-pinboard-cellphonepc-wireless-communication-p-8857.html)
  - [Driver (ch340)](http://sparks.gogo.co.nz/ch340.html)
- Custom development board  ![Badly soldered development board](images/development-board-bad-soldering.jpg)  Badly soldered example above...

## Wiring
![Wiring](images/esp8266-dht22_bb.png)

## References
- [Adafruit ESP8266 Temperature / Humidity Webserver Tutorial](https://learn.adafruit.com/esp8266-temperature-slash-humidity-webserver)
- [Capturing Sensor Data: DHT22](http://tiestvangool.ghost.io/2016/09/04/capturing-sensor-data-dht22/)
- [Wiring the ESP8266 As Stand Alone](http://www.14core.com/wiring-the-esp8266-as-stand-alone/)
- ESP8266 [Wikipedia](https://en.wikipedia.org/wiki/ESP8266) | [ESP8266 Community - Module Family](http://www.esp8266.com/wiki/doku.php?id=esp8266-module-family)

### Documentation
- [NodeMCU Documentation](https://nodemcu.readthedocs.io/en/dev/)
- [ESP8266 Arduino Core Documentation](http://arduino-esp8266.readthedocs.io/en/latest/)

### Datasheet
- [ESP-01 WiFi Module](http://ecksteinimg.de/Datasheet/Ai-thinker%20ESP-01%20EN.pdf)
- [DHT22](https://cdn-shop.adafruit.com/datasheets/DHT22.pdf)

## Further reading
- [Hack to enable deep sleep mode on the ESP-01](https://hackaday.com/2015/02/08/hack-allows-esp-01-to-go-to-deep-sleep/)
- [My odyssey across the trails of technology](http://tiestvangool.ghost.io/)
