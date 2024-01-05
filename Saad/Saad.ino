#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

#define DHTPIN 15
#define DHTTYPE 11


int LEDPIN = 2;

const char* ID     = "My hotspot";
const char* PASSWORD = "fantastic";

const char* Broker_SERVER = "test.mosquitto.org";
const char* Broker_ID = "Smart Incubator";
const char* Broker_USERNAME = NULL;
const char* Broker_PASSWORD = NULL;

const char* TemperatureInHumidity = "sensor/DHT11/humidity";
const char* TemperatureInCelcius = "sensor/DHT11/temperature_celcius";
const char* TemperatureInFahrenheit = "sensor/DHT11/temperature_fahrenheit";

WiFiClient espClient;
PubSubClient client(espClient);

DHT dht(DHTPIN,DHTTYPE);

void setup() 
{
    Serial.begin(115200);
    pinMode(5,OUTPUT);
    pinMode(4,OUTPUT);
    client.setServer(Broker_SERVER,1883);
    dht.begin();
}

void loop()
{
    SensorValues();
    if  (WiFi.status() != WL_CONNECTED)
    {
        WifiConnection();
    }
    if  (!client.connected())
    {
        ServerEstablishment();
    }
    client.loop();
}

void WifiConnection()
{
    pinMode(LEDPIN, OUTPUT);
    Serial.print("Connecting to ");
    Serial.print(ID);
    WiFi.begin(ID, PASSWORD);
    while (WiFi.status() != WL_CONNECTED) 
    {
        delay(250);
        digitalWrite(LEDPIN, HIGH);
        delay(250);
        digitalWrite(LEDPIN, LOW);
        Serial.print(".");
    }
    digitalWrite(LEDPIN, HIGH);
    Serial.println("Connected!");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());  
}

void ServerEstablishment()
{    
    while(!client.connected())
    {
        Serial.print("Connecting to ");
        Serial.println(Broker_SERVER);
        if  (client.connect(Broker_ID,Broker_USERNAME,Broker_PASSWORD))
        {
            Serial.print("Connection estblished with ");
            Serial.println(Broker_SERVER);
        }
        else
        {
            Serial.print(".");  
        }
     }
}

void SensorValues()
{
    int Humidity = dht.readHumidity();
    int Temprature = dht.readTemperature();
    
    client.publish(TemperatureInHumidity, String(Humidity).c_str(), true);
    client.publish(TemperatureInCelcius, String(Temprature).c_str(), true);
    
    if (Humidity >= 75)
    {
        digitalWrite(5,HIGH);
    }  
    else
    {
        digitalWrite(5,LOW);
    }

   
    if(Temprature < 22)
    {
        digitalWrite(4,HIGH);
    }
    else
    {
        digitalWrite(4,LOW);
    }
}
