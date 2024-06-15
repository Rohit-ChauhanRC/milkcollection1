#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
ESP8266WebServer server(80);

void handle404();

// if D3 not work just use 3

void setup() {

//WiFi-Setup
Serial.begin(9600);
WiFi.begin("Admin", "Admin1234"); //enter your ssid , password
Serial.print("Connecting");
while (WiFi.status() != WL_CONNECTED)
{
delay(500);
Serial.print(".");
}
Serial.println();

Serial.print("Connected, IP address: ");
Serial.println(WiFi.localIP());

Serial.println(WiFi.broadcastIP());
// Serial.println(WiFi.BSSID());

//Server-Setup
server.on("/status", HTTP_POST, handleStatus);
server.onNotFound(handle404);

server.begin();
// power-up safety delay

}

void loop()
{
server.handleClient();

}

void handleStatus(){
String bulboff ="print";
if (!server.hasArg("print") || server.arg("print") == NULL ){
Serial.println(server.arg("print"));

        server.send(400, "text/plain", "400: Invalid Request");
        return;
      }

Serial.println(server.arg("print"));
server.send(200);

}

void handle404(){
server.send(404, "text/plain", "404: Not found");
}
