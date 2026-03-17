const int PINO_SENSOR_LDR = A0;
int valorLuminosidade;

void setup() {
 Serial.begin(9600);

}

void loop() {
  valorLuminosidade = analogRead(PINO_SENSOR_LDR);
  
  Serial.print("Luminosidade Max:");
  Serial.print(1000);
  Serial.print(" ");
  Serial.print("Luminosidade Min:");
  Serial.print(200);
  Serial.print(" ");
  Serial.print("Luminosidade atual:");
  Serial.println(valorLuminosidade);

  delay(2000);



}
