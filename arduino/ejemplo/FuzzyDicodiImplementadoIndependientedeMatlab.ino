//Declaracion de variables de la planta
float Sp=3.0;
int ENA = 10;
int IN1 = 9;
int IN2 = 8;
float Vactual = 0;
float ErrorAct=0,ErrorAnt=0;
//Declaracion de variables del fuzzy
float E[][6]={
{1,2,-43.75,-27.07,-18.0,-5.0},
{1,1,-20.0,0.0,20.0,-25.0},
{1,2,5.0,18.0,27.08,43.78},
{2,2,-43.76,-27.08,-18.0,-5.0},
{2,1,-20.0,0.0,20.0,-25.0},
{2,2,5.0,18.0,27.0,43.69}};
float S[][6]={
{1,1,40.0,45.0,50.0,0.0},
{1,1,53.5,56.5,59.5,0.0},
{1,1,65.0,75.0,85.0,0.0}};
byte R[][100] ={
{1,3,3,3},
{1,3,2,3},
{1,3,1,3},
{1,2,3,2},
{1,2,2,2},
{1,2,1,2},
{1,1,3,1},
{1,1,2,1},
{1,1,1,1}};
byte CE[]={3,3},CS[]={3},Tam[]={2,1,9};
float LimE[2][2]={{-25.0,25.0},{-25.0,25.0}};
float x[]={0,0},OUTF[1];
float S_Temp[100][5],U_Temp[50];

void setup (){
  Serial.begin(9600);
  delay(1000);
  pinMode (ENA, OUTPUT);
  pinMode (IN1, OUTPUT);
  pinMode (IN2, OUTPUT);
  digitalWrite (IN1, HIGH);
  digitalWrite (IN2, LOW);
  analogWrite (ENA, 0);
}
void loop (){
 Vactual = Lectura(0, Vactual) * 5.0 / 1024.0;
 ErrorAnt=ErrorAct;
 ErrorAct=(Escalamiento(Sp)-Escalamiento(Vactual));
  x[0]=ErrorAct;
  x[1]=ErrorAct-ErrorAnt;
   //Fuzzy
  float Uin[2][50],Uout[1][50];
  Entrada(CE,x,E,LimE,Uin,Tam[0]);
  Salida_Reglas(R,Uin,CE,CS,Uout,Tam);
  byte con=0;
  for(byte i=0;i<Tam[1];i++){
  TemporalMatriz(S_Temp,S,con,con+CS[i]);
  TemporalVector(U_Temp,Uout,i,CS[i]);
  con=con+CS[i];
  OUTF[i]=Salida_Fuzzy(S_Temp,U_Temp,CS[i]);
  }
  analogWrite (ENA,int(constrain(OUTF[0],0,75)));
//  analogWrite (ENA,60);
  Serial.println(Vactual,4);
  delay(40);
}

float Escalamiento(float V){
  float  PWM=35.182+(1.566+0.273*V)*V*V;
  return PWM;
  }

int Lectura(int A, int Ant) {
  int cont = 0;
  for (int i = 0; i < 5; i++) {
    float   C1 = analogRead(A);
    cont = cont + C1;
    delayMicroseconds(200);
  }
  cont = cont / 5;
  int diff = abs(cont - Ant);
  if (diff < 0.5) {
    cont = Ant;
  }
  return cont;
}
