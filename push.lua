PIN=4 --data pin, GPIO2

-- Load global user-defined variables
dofile("config.lua")

timer=tmr.create()
timeout=false
cache = ""

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
    elseif(dht_status == dht.ERROR_TIMEOUT) then
        print("DHT Time out")
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
            if (code < 0) then
                print("HTTP request failed")
            else
                print(code, data)
            end
        end)

    --[=====[
        conn=net.createConnection(net.TCP, 0)
        conn:on("receive", function(conn, payload) print(payload) end)
        conn:connect(80,API)
        conn:send(header)
        conn:send("\r\n")
        conn:send(body)
        conn:on("sent",function(conn)
            conn:close()
            print("Connection closed")
        end)
        conn:on("disconnection", function(conn)
            tmr.alarm(1,SLEEP_TIME,tmr.ALARM_SINGLE,function() connectWifi() end)
            print("disconnected, sleeping for "..(SLEEP_TIME/1000).." seconds")
        end)
    --]=====]
    end

    -- Execute sensor reading and enter deep sleep
    function func_exec_loop()
        if wifi.sta.status() == 5 then  --STA_GOTIP
            print("Connected to "..wifi.sta.getip())
            tmr.stop(1) --Exit loop
            readDht() --Retrieve sensor data
            --print("Going into deep sleep mode for "..(SLEEP_TIME/1000).." seconds.")
            --node.sleep(SLEEP_TIME*1000)
        else
            print("Connecting...")
        end
    end

    function connectWifi()
        tmr.alarm(1,500,tmr.ALARM_AUTO,function() func_exec_loop() end)
    end

    connectWifi()