PIN=4 --data pin, GPIO2

-- Load global user-defined variables
dofile("config.lua")

timer=tmr.create()
timeout=false
cache = ""

wifi.setmode(wifi.STATION)
wifi.sta.config(SSID,PASS)
wifi.sta.setip({ip=IP,netmask="255.255.255.0",gateway=GATEWAY})
srv=net.createServer(net.TCP, 30)
srv:listen(80,function(conn)
    conn:on("receive", function(client)
        local body=""

        if (timeout)then
            body = cache
        else

            -- Setup a timer to debounce sensor read
            if timer:state() == nil then
                timeout=true
                timer:alarm(3000, tmr.ALARM_SINGLE, function() timeout=false end)
            end

            -- Read from sensor
            status, temp, humi, temp_dec, humi_dec = dht.read(PIN)
            if status == dht.OK then
                body= "{ "
                body=body.."t: "..temp..", "
                body=body.."h: "..humi
                body=body.." }"
                cache=body
                print("DHT Temperature:"..temp..";".."Humidity:"..humi)
            elseif status == dht.ERROR_CHECKSUM then
                timer:unregister()
                body=body.." { error: \"DHT Checksum error.\" }"
                print( "DHT Checksum error." )
            elseif status == dht.ERROR_TIMEOUT then
                timer:unregister()
                body=body.." { error: \"DHT timed out.\" }"
            end
            
        end
        local header="HTTP/1.1 200 OK\r\n"
                .."Connection: keep-alive\r\n"
                .."Content-Type: application/json\r\n"
                .."Content-length: "..#body.."\n\n"
        client:send(header..body)
        client:close()
        collectgarbage()
    end)
end)
