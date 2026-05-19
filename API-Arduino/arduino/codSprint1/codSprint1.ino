const int PINO_SENSOR_LDR = A0;
int valorLuminosidade;

void setup() {
 Serial.begin(9600);

}

void loop() {
  valorLuminosidade = analogRead(PINO_SENSOR_LDR);
  Serial.println(valorLuminosidade);

  delay(2000);
}