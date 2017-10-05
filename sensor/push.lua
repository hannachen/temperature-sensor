PIN=4 --data pin, GPIO2

-- Load global user-defined variables
dofile("config.lua")

wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASS)
wifi.sta.setip({ip=IP,netmask="255.255.255.0",gateway=GATEWAY})
wifi.sta.connect()

-- Read out DHT22 sensor using dht module
function readDht()
    print("Reading from sensor...")

    status, temp, humi, temp_dec, humi_dec = dht.read(PIN)
    if status == dht.OK then
        print("DHT Temperature: "..temp.."C")
        print("DHT Humidity: "..humi.."%")
        sendData(temp,humi)
    elseif(dht_status == dht.ERROR_CHECKSUM) then
        print("DHT Checksum error")
        connectWifi()
    elseif(dht_status == dht.ERROR_TIMEOUT) then
        print("DHT Time out")
        connectWifi()
    end
end

function sendData(temp,humi)
    print("Sending data...")

    local body="id="..ID.."&t="..temp.."&h="..humi
    local header="POST / HTTP/1.1\r\n"
                .."Host: "..IP.."\r\n"
                .."Content-Type: application/x-www-form-urlencoded\r\n"
                .."Content-length: "..#body.."\r\n"
                .."Accept: */*\r\n"
                .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
                .."x-api-key: "..KEY

    http.post('http://'..API,
        'Content-Type: application/x-www-form-urlencoded\r\n',
        body,
        function(code, data)
            local timeout=500
            if (code < 0) then
                print("HTTP request failed")
            else
                print(code, data)
                if (code == 200 and data == "OK") then
                    timeout=SLEEP_TIME
                    print("disconnected, timeout for "..(SLEEP_TIME/1000).." seconds")
                end
            end
            tmr.alarm(1,timeout,tmr.ALARM_SINGLE,function() connectWifi() end)
        end)
end

-- Execute sensor reading
function execLoop()
    if wifi.sta.status() == 5 then  --STA_GOTIP
        print("Connected to "..wifi.sta.getip())
        tmr.stop(1) --Exit loop
        readDht() --Retrieve sensor data
    else
        print("Connecting...")
    end
end

function connectWifi()
    tmr.alarm(1,500,tmr.ALARM_AUTO,function() execLoop() end)
end

connectWifi()