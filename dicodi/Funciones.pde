GButton CrearBoton(int X,int Y,int l_x, int l_y,String Texto,String funcion){
  GButton boton = new GButton(this,X,Y,l_x,l_y);
  boton.setText(Texto);
  boton.addEventHandler(this,funcion);
  return boton;
}

GDropList CrearLista(int X,int Y,int l_x,int l_y,String[] List_Item,int Index,String funcion){
  GDropList Lista = new GDropList(this,X,Y,l_x,l_y, 3, 10);
  Lista.setItems(List_Item,Index);
  Lista.addEventHandler(this,funcion);
  return Lista;
}

GLabel CrearLabel(int X,int Y,int l_x,int l_y,String Texto){
  GLabel Label = new GLabel(this, X,Y,l_x,l_y);
  Label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  Label.setText(Texto);
  Label.setOpaque(false);
  return Label;
}
GTextField CrearTextField(int X,int Y,int l_x,int l_y,String Texto,String Tag){
  GTextField txf1 = new GTextField(this, X,Y,l_x,l_y);
  txf1.tag = Tag;
  txf1.setText(Texto);
  return txf1;
}
void BottonEnable_Or_Disable(GButton source,boolean ON_OFF){
    source.setEnabled(ON_OFF);
    source.setVisible(ON_OFF);  
}

void GDropListEnable_Or_Disable(GDropList source,boolean ON_OFF){
    source.setEnabled(ON_OFF);
    source.setVisible(ON_OFF);  
}


void dibujo_Triangulo(Fun Funcion,float[] Limite){
  //Primer Tramo
  float K=Limite[1]-Limite[0],Punto_Medio;
  
  DibujoLinea_limite(60.0+(Funcion.Parametros[0]-Limite[0])*520.0/K,258,60.0+(Funcion.Parametros[1]-Limite[0])*520.0/K,118.0,60.0,580.0);
  DibujoLinea_limite(60.0+(Funcion.Parametros[1]-Limite[0])*520.0/K,118,60.0+(Funcion.Parametros[2]-Limite[0])*520.0/K,258.0,60.0,580.0);
  Punto_Medio=60.0+(Funcion.Parametros[1]-Limite[0])*520.0/K;
  if(Punto_Medio<=580&&60<=Punto_Medio){
  textSize(10);textAlign(CENTER);text(Funcion.nombre,Punto_Medio-40,105,80, 20);textSize(14);
  
  }

}

void dibujo_Trapecio(Fun Funcion,float[] Limite){
  float K=Limite[1]-Limite[0],Punto_Medio;
  DibujoLinea_limite(60.0+(Funcion.Parametros[0]-Limite[0])*520.0/K,258,60.0+(Funcion.Parametros[1]-Limite[0])*520.0/K,118.0,60.0,580.0);
  DibujoLinea_limite(60.0+(Funcion.Parametros[1]-Limite[0])*520.0/K,118,60.0+(Funcion.Parametros[2]-Limite[0])*520.0/K,118.0,60.0,580.0);
  DibujoLinea_limite(60.0+(Funcion.Parametros[2]-Limite[0])*520.0/K,118,60.0+(Funcion.Parametros[3]-Limite[0])*520.0/K,258.0,60.0,580.0);
  Punto_Medio=60.0+(((Funcion.Parametros[1]+Funcion.Parametros[2])/2)-Limite[0])*520.0/K;
  if(Punto_Medio<=580&&60<=Punto_Medio){
  textSize(10);textAlign(CENTER);text(Funcion.nombre,Punto_Medio-40,105,80, 20);textSize(14);
  }
}
void DibujoLinea_limite(float X1,float Y1,float X2,float Y2,float lim_x1,float lim_x2){
  float[] X_dibujar=new float[2];
  float[] Y_dibujar=new float[2];
  X_dibujar[0]=constrain(X1,lim_x1,lim_x2);
  X_dibujar[1]=constrain(X2,lim_x1,lim_x2);
  if(X_dibujar[0]!=X_dibujar[1]) {//>=
  Y_dibujar[0]=((Y2-Y1)/(X2-X1))*(X_dibujar[0]-X1)+Y1;
  Y_dibujar[1]=((Y2-Y1)/(X2-X1))*(X_dibujar[1]-X1)+Y1;
  line(X_dibujar[0],Y_dibujar[0],X_dibujar[1],Y_dibujar[1]);
  }
  
}

Fun relleno_datos_Fun(int Numero_0,int Tipo_0,float N1,float N2,float N3,float N4,String nombre_0){
  Fun Out_0=new Fun();
  Out_0.Numero=Numero_0;
  Out_0.Tipo=Tipo_0;
  Out_0.Parametros[0]=N1;Out_0.Parametros[1]=N2;
  Out_0.Parametros[2]=N3;Out_0.Parametros[3]=N4;
  Out_0.nombre=nombre_0;
  return Out_0;
}

Conjunto relleno_datos_entrada_or_salida_Inicial(float lim_x1,float lim_x2,String nombre,int ID){
  Conjunto Out_0=new Conjunto();
  Out_0.nombre=nombre+str(ID);
  Out_0.Limite[0]=lim_x1;Out_0.Limite[1]=lim_x2;
  float Const=1.0;
if(nombre=="Salida "){
  Const=51.0;
  }
  for(int i = 0; i <3; i+=1) {
  Out_0.Funciones[i]=relleno_datos_Fun(1+i,1,(-2.0+2.5*i)*Const,(2.5*i)*Const,(2.0+2.5*i)*Const,0.0,"Tr_"+str(i+1));
  }
  return Out_0;
}
void Grafico(){
fill(230,230,230);strokeWeight (0);stroke(230,230,230);
rect(0+Corx,490-Cory,650,540);
fill(0, 0, 0);stroke(0,0,0);strokeWeight (1);
textAlign(LEFT);
Imprimir_Reglas();
fill(230,230,230);strokeWeight (0);stroke(230,230,230);
rect(0,0,639,800);rect(0+Corx,460-Cory,650,40);rect(630+Corx,490-Cory,30,560);rect(0+Corx,650-Cory,650,560);
fill(0, 0, 0);stroke(0,0,0);strokeWeight (1);
//text("REGLAS",51, 470, 537, 57);//Xinicial,Yinicial
textSize(15);textAlign(CENTER);text("REGLAS",51+Corx, 470-Cory, 537, 57);//Xinicial,Yinicial
textSize(14);
int[] C1={CBE,CBS};
for(int i=0;i<2;i+=1){for(int j=0;j<C1[i];j+=1){
    if(i==0){
        text("Entrada "+str(j+1),Corx+61+111*j-HORIZONTAL.getValueI(),787-Cory);
    }else{
        text("Salida "+str(j+1),Corx+61+111*j-HORIZONTAL.getValueI(),832-Cory);
    }
}
}
fill(230,230,230);strokeWeight (0);stroke(230,230,230);
rect(0,0,630,800);fill(0, 0, 0);stroke(0,0,0);strokeWeight (1);
textAlign(LEFT);text("Valor de entrada(s):",11+Corx, 700-Cory, 150, 120);
text("Valor de Salida(s):",11+Corx, 740-Cory, 150, 120);


  for(int i=0;i<2;i+=1){for(int j=0;j<2;j+=1){
      line(Corx+18+612*i,500+150*i-Cory,Corx+18+612*j,500+150*(1-j)-Cory);//60,118,520,140
      line(Corx+648*i,490+178*i-Cory,Corx+648*j,490+178*(1-j)-Cory);//60,118,520,140
  }}

//TEXTO
  float Rango;
  textFont(loadFont("ArialRoundedMTBold-48.vlw"));
  textSize(18);fill(0, 0, 0);textAlign(CENTER);
  text("PLATAFORMA DE SOTFWARE PARA EL DISEÑO DE  CONTROLADORES PID DIFUSOS EN TARJETAS  ARDUINO",95, 20,1000, 57);//Xinicial,Yinicial
  text("MODIFICACION DE FUNCIONES DE MEMBRESIA",53, 370, 570, 57);
  textSize(14);
  textAlign(LEFT);
  text("Entradas",43, 75,80, 20);text("Salidas",40, 272,80, 20); //text("Rango: ",40, 272,80, 20);
  text("Seleccionar funcion: ",51, 390, 133, 120);
  text("Tipo de funcion: ",231, 390,96, 40); 
  text("Nombre: ",418, 400,96, 40);
  text("Parametros: ",51, 440, 133, 120);
  text("Rango: ",51, 480,96, 40);
  if(Actual.SorE==false){
    fondo_Fun(177,176,152,186,189,182);
    Seleccion(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1]);//Dibujo
    Rango=Entrada_datos[Actual.Numero-1].Limite[1]-Entrada_datos[Actual.Numero-1].Limite[0];
    text(str(int(Entrada_datos[Actual.Numero-1].Limite[0])),65,268);
    text(str((Rango/2)+Entrada_datos[Actual.Numero-1].Limite[0]),320,268);
    text(str(int(Entrada_datos[Actual.Numero-1].Limite[1])),580,268); 
  }else{
    fondo_Fun(150,138,198,183,169,242);
    Seleccion(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1]);
    text("0",65,268);text("127.5",320,268);text("255",580,268);
  }
  text("0",58,258);text("1",58,127);//  textFont(loadFont("ArialMT-48.vlw"));
  for(int i=0;i<2;i+=1){for(int j=0;j<2;j+=1){
      line(60+520*i,98+160*i,60+520*j,98+160*(1-j));//60,118,520,140
      line(51+538*i,89+178*i,51+538*j,89+178*(1-j));//60,118,520,140
  }}

}


void fondo_Fun(int N1,int N2,int N3,int N4,int N5,int N6){
  stroke (N1,N2,N3);fill (N4,N5,N6);strokeWeight (10); //color borde rojo// relleno verde//grosor 5
  rect (60-5,98-5,520+5*2,160+5*2);//rectángulo
  stroke (0,0,0);fill(0, 0, 0);strokeWeight (1);
}

void Seleccion(Conjunto con,int Cfun){
  for(int i = 0;i<Cfun; i+=1){
   switch(con.Funciones[i].Tipo){
      case 1:
        dibujo_Triangulo(con.Funciones[i],con.Limite);
        break;
     case 2:
        dibujo_Trapecio(con.Funciones[i],con.Limite);
        break;
    }
  }
}

String [] Inicial(int Max){
  String []En= new String[100];
  for (int i = 0; i <Max+1; i+=1) {
  En[i] = "" + (i);
  
  }
  En=subset(En,1);
  if(Max==0){
  En[0]="None";
  }
  return En;
}

String Busca_nombre(Conjunto conjunto,int Max,int tipo){
  String Nombre=new String();int Index;
  for (int j = 0; j <Max+1; j+=1) {
    Index=1;
    for (int i = 0; i <Max; i+=1) {
      if((conjunto.Funciones[i].nombre.equals("Tr_"+str(j+1)) == true)||(conjunto.Funciones[i].nombre.equals("Trap_"+str(j+1)) == true) ){
        Index=0;
      }
    }
    if(Index==1){
      Nombre=str(j+1);
      break;
    }
  }
  if(tipo==1){
    Nombre="Tr_"+Nombre;
  }else{
    Nombre="Trap_"+Nombre;
  }
  return Nombre;
}


float[] Redimensionar(float[] Parm,float[] LimtAnt,float[] LimtAct){
  float[] ParmR=new float[4];
  for(int i=0;i<4;i+=1){
    ParmR[i]=LimtAct[0]+((Parm[i]-LimtAnt[0])*(LimtAct[1]-LimtAct[0])/(LimtAnt[1]-LimtAnt[0]));
  }
  return ParmR;
}

float[] Guardar(float[] Parm,int Tip){
  float[] Vect=new float[4];
  for(int i=0;i<3+Tip;i+=1){
    Vect[i]=Parm[i];
  }
  if(Tip==0){
    Vect[3]=0;
  }
  return Vect;
}

float[] SepararNumeros(String str){
  float[] N={0};
  String C=str;
  C=C.substring(C.indexOf("[")+1,C.indexOf("]"));
  while(C!="]"){
    int inde=0;
    while (inde==0){
      inde=C.indexOf(" ");
      if(inde==0){
        C=C.substring(inde+1,C.length());
      }
    }
    if(inde!=-1){
      N=append(N, float(C.substring(0,inde)));
      C=C.substring(inde+1,C.length());
    }else if(inde==-1&&C.length()!=0){
      N=append(N,float(C));
      break;
    }else{
    break;
    }  
    }
  N=subset(N,1);
  return N;
}

String DevString(float[] Test1,int max){
  String Show="[ ";
  for(int i=0;i<max;i+=1){
    Show=Show+str(Test1[i])+" ";
  }
  Show=Show+"]";
  return Show;
}
String[] ListFunc(Conjunto EN_OU,int Cant){
  String []En= new String[100];
  En[0]="None";
  for (int i = 1; i <Cant+1; i+=1) {
  En[i] =EN_OU.Funciones[i-1].nombre;
  }

  return En;
}
