//G4p controls
import g4p_controls.*;
GButton Exportar_Controlador,Calcular;
GButton[] In=new GButton[60],Out=new GButton[60];
Control_Reglas Cont_Reglas=new Control_Reglas();
Reglas Entrada_Reglas=new Reglas(),Salida_Reglas=new Reglas(); 
Conjunto[] Entrada_datos = new Conjunto[60],Salida_datos= new Conjunto[60];
String[] S_Tip={"     Triangulo","     Trapecio"},OP={"OR","AND"};
int[] CE=new int[60],CS=new int[60];
int CBE=1,CBS=1,CHANGE=1;
Acciones Entrada_boton=new Acciones(),Salida_boton=new Acciones(),Funcion_boton=new Acciones();
GTabManager tt;
Temp Temporal=new Temp();
Estado Actual=new Estado();
Modificacion DatosMod=new Modificacion();
GCustomSlider HORIZONTAL,VERTICAL; 
int Corx=620,Cory=400;
public class Regla{
  public int[] R=new int[60];
}

public class Reglas {
  public GDropList[] Selec=new GDropList[60];
}
public class Control_Reglas {
  public GDropList Seleccion_Regla;
  public GButton Regla_AGG;
  public GButton Regla_DEl;
  public GDropList Operacion;
  public int [ ] Tipo_Operacion= new int[100];//Se guardan los index
  public Regla[ ] Definicion_Reglas_Entrada= new Regla[100];//Se guardan los index
  public Regla[ ] Definicion_Reglas_Salida= new Regla[100];//Se guardan los index
  public int Cantidad;
}
public class Fun {
      public int Numero;
      public int Tipo;
      public float[] Parametros= new float[4];
      public String nombre;
}
public class Modificacion {
      public GDropList Numero;
      public GDropList Tipo;
      public GTextField Dat0s;
      public GTextField RangoM;
      public GTextField Nombre;
      public float[] entrada_Regla=new float[60];
      public GTextField TxtEntrada;
      public GTextField TxtSalida;
      
}
public class Conjunto {//entrada o salida
      public Fun[] Funciones=new Fun[50];
      public float[] Limite= new float[2];
      public String nombre;
}

public class Estado {
      public int Numero;
      public boolean SorE;
      public GLabel[] Limit=new GLabel[2];
      public GTextField Limit_R;
      
}

public class Acciones {
      public GButton agg;
      public GButton del;
      public GDropList[] Numero_DelOrAgg=new GDropList[2];//0) Entrada or salida 1)Seleccion de funcion trapezoidal o triangular 
}

public class Temp {
      public String Nombre;
      public String Parame;
      public String Rang;
      public String Entrada_Txt;
}


public void setup(){
  size(1280,590, JAVA2D);
  createGUI();
}

String [] ObtenerNombre(Conjunto Out_0,int Max){
  String []Items= new String[100];
  for (int i = 0; i <Max; i+=1) {
  Items[i]=Out_0.Funciones[i].nombre;
  }
  if(Max==0){
  Items[0]="   ";
  }
return Items;
}

public void Seleccion_Tipo(GSlider source, GEvent event) { //_CODE_:slider1:856892:
  println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
} 

public void draw(){
background(230);
Grafico();
frameRate(1200000);
}

public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("DICODI");
  
  G4P.setInputFont("Times New Roman", G4P.PLAIN, 20); // New for G4P V4.3
  Entrada_datos[0]=relleno_datos_entrada_or_salida_Inicial(0,5,"Entrada ",0);CE[0]=3;
  Salida_datos[0]=relleno_datos_entrada_or_salida_Inicial(0,255,"Salida ",0);CS[0]=3;
  Actual.Numero=1;Actual.SorE=false;
  
  DatosMod.Numero=CrearLista(140, 390,90, 120,ObtenerNombre(Entrada_datos[0],CE[0]), 0,"Seleccion_Funcion");
  DatosMod.Tipo=CrearLista(290, 390,126, 120,S_Tip, 0,"Seleccion_Tipo");
  DatosMod.Nombre=CrearTextField(475, 390,116, 30,"Tr_1","Nombre");
  DatosMod.Dat0s=CrearTextField(140, 430, 450, 30,"["+str(Entrada_datos[0].Funciones[0].Parametros[0])+"   "+str(Entrada_datos[0].Funciones[0].Parametros[1])+"   "+str(Entrada_datos[0].Funciones[0].Parametros[2])+"]","Datos");
  DatosMod.RangoM=CrearTextField(140, 470,450, 30,"["+str(Entrada_datos[0].Limite[0])+"   "+str(Entrada_datos[0].Limite[1])+"]","Rango");
  DatosMod.TxtEntrada=CrearTextField(151+Corx, 690-Cory,500, 30,"[0]","TxtEntrada");
  DatosMod.TxtSalida=CrearTextField(151+Corx, 730-Cory,440, 30,"[0]","TxtSalida");

  
  In[0]=CrearBoton(562,75,30,15,"1","Entrada_Salida_Mostrar");In[0].setLocalColorScheme(5);
  Out[0]=CrearBoton(562, 268, 30, 15,"1","Entrada_Salida_Mostrar");
  
  Funcion_boton.agg=CrearBoton(226,295,96,30,"Agregar Funcion","Agregar_Salida_Or_Entrada_Or_Funcion");
  Entrada_boton.agg=CrearBoton(51, 295, 175, 30,"Agregar Entrada","Agregar_Salida_Or_Entrada_Or_Funcion");
  Salida_boton.agg=CrearBoton( 418, 295, 174, 30,"Agregar Salida","Agregar_Salida_Or_Entrada_Or_Funcion");
  
  Entrada_boton.del=CrearBoton( 51, 330, 135, 30,"Eliminar Entrada","Eliminar_Salida_Or_Entrada_Or_Funcion");
  Funcion_boton.del=CrearBoton( 226, 330,96, 30,"Eliminar Funcion","Eliminar_Salida_Or_Entrada_Or_Funcion");
  Salida_boton.del=CrearBoton( 418, 330, 133, 30,"Eliminar Salida","Eliminar_Salida_Or_Entrada_Or_Funcion");
  
  Entrada_boton.Numero_DelOrAgg[0]=CrearLista(186, 330, 40, 120,Inicial(1), 0,"Vacio");//Numero de entrada
  Funcion_boton.Numero_DelOrAgg[0]=CrearLista(322, 330,96, 120,ObtenerNombre(Entrada_datos[0],CE[0]), 0,"Vacio");//Eliminar funcion
  Funcion_boton.Numero_DelOrAgg[1]=CrearLista(322, 295,96, 120,S_Tip, 0,"Vacio");//Agregar funcion tipo tria
  Salida_boton.Numero_DelOrAgg[0]=CrearLista(551, 330, 40, 120,Inicial(1), 0,"Vacio");//Numero de salida
  
  tt = new GTabManager();
  tt.addControls(DatosMod.Nombre,DatosMod.Dat0s,DatosMod.RangoM);
  HORIZONTAL = new GCustomSlider(this,Corx+15, 640-Cory, 610, 40, "grey_blue");
  HORIZONTAL.setLimits(0, 0.0,1280);
  HORIZONTAL.setNumberFormat(G4P.DECIMAL, 2);
  HORIZONTAL.setOpaque(false);
  HORIZONTAL.addEventHandler(this, "Movimiento_HorizontalR");
  
  VERTICAL = new GCustomSlider(this,Corx+30,500-Cory, 150, 40, "grey_blue");
  VERTICAL.setLimits(0, 0.0,1000);
  VERTICAL.setNumberFormat(G4P.DECIMAL, 2);
  VERTICAL.setOpaque(false);
  VERTICAL.setRotation(PI/2);
  VERTICAL.addEventHandler(this, "Movimiento_VerticalR");
  
  Entrada_Reglas.Selec[0]=CrearLista(Corx+15,790-Cory,96,120,ListFunc(Entrada_datos[0],CE[0]),1,"Vacio");//Modificar a 0
  Salida_Reglas.Selec[0]=CrearLista(Corx+15,835-Cory,96,120,ListFunc(Salida_datos[0],CS[0]),1,"Vacio");

  Cont_Reglas.Regla_AGG=CrearBoton(Corx+15,875-Cory,260,30,"AÑADIR REGLA","REGLA_agg_del");//39
  Cont_Reglas.Operacion=CrearLista(Corx+275,875-Cory,55,120,OP, 0,"Vacio");
  Cont_Reglas.Regla_DEl=CrearBoton(Corx+329,875-Cory,260,30,"ELIMINAR REGLA","REGLA_agg_del");
  Cont_Reglas.Seleccion_Regla=CrearLista(Corx+589, 875-Cory,60,120,Inicial(0), 0,"Vacio");
  Cont_Reglas.Cantidad=0;
  
  Calcular=CrearBoton(Corx+580,730-Cory, 70, 30,"Calcular","Calcular_Salida");
  Exportar_Controlador=CrearBoton(Corx+15,908-Cory,635, 30,"Exportar Controlador Difuso","Exportar_Controlador");
}



public void REGLA_agg_del(GButton button, GEvent event) {
if(button==Cont_Reglas.Regla_AGG){
  
    int[] Cant={CBE,CBS};
    int Cont=0,Cont2=0;
    Cont_Reglas.Definicion_Reglas_Entrada[Cont_Reglas.Cantidad]=new Regla();
    Cont_Reglas.Definicion_Reglas_Salida[Cont_Reglas.Cantidad]=new Regla();
    for(int i=0;i<2;i+=1){
      //println(i);
      for(int j=0;j<Cant[i];j+=1){
         //println(j);
        if(i==0){
          Cont_Reglas.Definicion_Reglas_Entrada[Cont_Reglas.Cantidad].R[j]=Entrada_Reglas.Selec[j].getSelectedIndex();
          if(0!=Entrada_Reglas.Selec[j].getSelectedIndex()){
          Cont=1;
          }
        }
        else{
          Cont_Reglas.Definicion_Reglas_Salida[Cont_Reglas.Cantidad].R[j]=Salida_Reglas.Selec[j].getSelectedIndex();
          if(0!=Salida_Reglas.Selec[j].getSelectedIndex()){
          Cont2=1;
          }
        }
      }
    }
    if(Cont2==1&&Cont==1){
      Cont_Reglas.Tipo_Operacion[Cont_Reglas.Cantidad]=Cont_Reglas.Operacion.getSelectedIndex();
      Cont_Reglas.Cantidad=Cont_Reglas.Cantidad+1;
      
    }
  }
  else if(button==Cont_Reglas.Regla_DEl&&0<Cont_Reglas.Cantidad){
      Eliminar_Regla_Index(Cont_Reglas.Seleccion_Regla.getSelectedIndex());
      }
      Cont_Reglas.Seleccion_Regla.setItems(Inicial(Cont_Reglas.Cantidad),0);
      }
//OP
void Eliminar_Regla_Index(int Pos){//Cont_Reglas.Seleccion_Regla.getSelectedIndex()
      for(int j=0;j<Cont_Reglas.Cantidad;j+=1){
        //print(Pos<=j);
        if(Pos<=j)
        Cont_Reglas.Definicion_Reglas_Entrada[j]=Cont_Reglas.Definicion_Reglas_Entrada[j+1];
        Cont_Reglas.Definicion_Reglas_Salida[j]=Cont_Reglas.Definicion_Reglas_Salida[j+1];
        Cont_Reglas.Tipo_Operacion[j]=Cont_Reglas.Tipo_Operacion[j+1];
        }
        Cont_Reglas.Cantidad=Cont_Reglas.Cantidad-1;
}
void Imprimir_Reglas(){
    int[] Cant={CBE,CBS};
    int inde,N;
    for(int k=0;k<Cont_Reglas.Cantidad;k+=1){//Reglas
      String Show=str(k+1)+")"+" if";
      for(int i=0;i<2;i+=1){
        int contN=0;
        if(i==0){
          N=ContarNumeroDiferenteAX(Cont_Reglas.Definicion_Reglas_Entrada[k].R,0);
        }else{
          N=ContarNumeroDiferenteAX(Cont_Reglas.Definicion_Reglas_Salida[k].R,0);
        }
        for(int j=0;j<Cant[i];j+=1){//Recorre entrada o salidaa
          if(i==0){
            inde=Cont_Reglas.Definicion_Reglas_Entrada[k].R[j];
            if(0!=inde&&contN<=N){
              contN=contN+1;
              if(j!=0){
              Show=Show+" "+OP[Cont_Reglas.Tipo_Operacion[k]];
              }
              Show=Show+" (Entrada "+str(j+1)+" es "+Entrada_datos[j].Funciones[inde-1].nombre+" )";
              if(contN==N){
              Show=Show+" entonces ";
              }
            }
        }else{
          
          inde=Cont_Reglas.Definicion_Reglas_Salida[k].R[j];
          if(0!=inde&&contN<N){
              contN=contN+1;
              Show=Show+" (Salida "+str(j+1)+" es "+Salida_datos[j].Funciones[inde-1].nombre+" )";
            }
          
        }
      }
    }
    float Ypos=520-VERTICAL.getValueI()+30*k;
 if(490<Ypos){   
    text(Show,25-HORIZONTAL.getValueI()+Corx,Ypos-Cory,1000,40);
 }
}
}

int ContarNumeroDiferenteAX(int[] arreglo,int busqueda) {
  int cont=0;
  for (int x = 0; x < arreglo.length; x++) {
    if (arreglo[x] != busqueda) {
      cont=cont+1;
    }
  }
  return cont;
}

public void Movimiento_VerticalR(GCustomSlider customslider, GEvent event) { /* code */ }

public void Movimiento_HorizontalR(GCustomSlider source, GEvent event){
  int[] Cant={CBE,CBS};
  for(int i=0;i<2;i+=1){for(int j=0;j<Cant[i];j+=1){
      boolean Condicion=true;
    if(i==0){
        Entrada_Reglas.Selec[j].moveTo(15+111*j-HORIZONTAL.getValueI()+Corx,790-Cory);
        if(15+111*j-HORIZONTAL.getValueI()+Corx<=593){
          Condicion=false;
        }
        Entrada_Reglas.Selec[j].setEnabled(Condicion);
        Entrada_Reglas.Selec[j].setVisible(Condicion);
    }else{
        Salida_Reglas.Selec[j].moveTo(15+111*j-HORIZONTAL.getValueI()+Corx,835-Cory);
        if(15+111*j-HORIZONTAL.getValueI()+Corx<=593){
          Condicion=false;
        }
        Salida_Reglas.Selec[j].setEnabled(Condicion);
        Salida_Reglas.Selec[j].setVisible(Condicion);
    }
  }
}
}



public void Agregar_Salida_Or_Entrada_Or_Funcion(GButton source, GEvent event) { //_CODE_:In:781201:
  if(source==Entrada_boton.agg) {
    boolean Condicion=true;
    In[CBE]=CrearBoton(562-CBE*25,75,30,15,str(CBE+1),"Entrada_Salida_Mostrar");
    BottonEnable_Or_Disable(In[CBE],true);
    Entrada_datos[CBE]=relleno_datos_entrada_or_salida_Inicial(0,5,"Entrada ",CBE+1);CE[CBE]=3;
    Entrada_Reglas.Selec[CBE]=CrearLista(15+111*CBE-HORIZONTAL.getValueI()+Corx,790-Cory,96,120,ListFunc(Entrada_datos[CBE],CE[CBE]),0,"Vacio"); 
    GDropListEnable_Or_Disable(Entrada_Reglas.Selec[CBE],true);
    if(15+111*CBE-HORIZONTAL.getValueI()+Corx<=593){
          Condicion=false;
    }
    Entrada_Reglas.Selec[CBE].setEnabled(Condicion);
    Entrada_Reglas.Selec[CBE].setVisible(Condicion);
    CBE=CBE+1;
    float[] Test1=SepararNumeros(DatosMod.TxtEntrada.getText());Test1=append(Test1,0);
    DatosMod.TxtEntrada.setText(DevString(Test1,CBE));
    Entrada_boton.Numero_DelOrAgg[0].setItems(Inicial(CBE),0);
  }else if(source==Salida_boton.agg){
    Out[CBS]=CrearBoton(562-CBS*25, 268, 30, 15,str(CBS+1),"Entrada_Salida_Mostrar");
    BottonEnable_Or_Disable(Out[CBS],true);
    Salida_datos[CBS]=relleno_datos_entrada_or_salida_Inicial(0,255,"Salida ",CBS+1);CS[CBS]=3;
    
    Salida_Reglas.Selec[CBS]=CrearLista(Corx+15+111*CBS-HORIZONTAL.getValueI(),835-Cory,96,120,ListFunc(Salida_datos[CBS],CS[CBS]),0,"Vacio");
    GDropListEnable_Or_Disable(Salida_Reglas.Selec[CBS],true);
    
    CBS=CBS+1;
    Salida_boton.Numero_DelOrAgg[0].setItems(Inicial(CBS),0);
  }else if(source==Funcion_boton.agg){
   int Ti=1; 
    if(Funcion_boton.Numero_DelOrAgg[1].getSelectedText()=="     Triangulo"){//Modificacion de nombre busca nombre
      Ti=0;
    }
    if(Actual.SorE==false){
      float Linf=Entrada_datos[Actual.Numero-1].Limite[0],Lsup=Entrada_datos[Actual.Numero-1].Limite[1];
      Entrada_datos[Actual.Numero-1].Funciones[CE[Actual.Numero-1]]=relleno_datos_Fun(Actual.Numero,1+Ti,Linf,Linf+(Lsup-Linf)/(2+Ti*2),Lsup-Ti*(Lsup-Linf)/4,Lsup*Ti,Busca_nombre(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1],1+Ti));//"Tr_"+str(CE[Actual.Numero-1]+1)
      CE[Actual.Numero-1]=CE[Actual.Numero-1]+1;
      
      Entrada_Reglas.Selec[Actual.Numero-1].setItems(ListFunc(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1]),Entrada_Reglas.Selec[Actual.Numero-1].getSelectedIndex());
      
      actualizar_funciones(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1],DatosMod.Numero.getSelectedIndex(),Funcion_boton.Numero_DelOrAgg[0].getSelectedIndex());  
    }else{    
      float Linf=Salida_datos[Actual.Numero-1].Limite[0],Lsup=Salida_datos[Actual.Numero-1].Limite[1];
      Salida_datos[Actual.Numero-1].Funciones[CS[Actual.Numero-1]]=relleno_datos_Fun(Actual.Numero,1+Ti,Linf,Linf+(Lsup-Linf)/(2+Ti*2),Lsup-Ti*(Lsup-Linf)/4,Lsup*Ti,Busca_nombre(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1],1+Ti));
      CS[Actual.Numero-1]=CS[Actual.Numero-1]+1;
      
      Salida_Reglas.Selec[Actual.Numero-1].setItems(ListFunc(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1]),Salida_Reglas.Selec[Actual.Numero-1].getSelectedIndex());
      
      actualizar_funciones(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1],DatosMod.Numero.getSelectedIndex(),Funcion_boton.Numero_DelOrAgg[0].getSelectedIndex());  
    }
  } 
}

void Actulizar_Reglas_Funciones(int Posicion,int N_Entrada_or_Salida,int Tip){
    for(int k=0;k<Cont_Reglas.Cantidad;k+=1){
      if(Tip==0&&Cont_Reglas.Definicion_Reglas_Entrada[k].R[N_Entrada_or_Salida]==Posicion){//Entrada
        Cont_Reglas.Definicion_Reglas_Entrada[k].R[N_Entrada_or_Salida]=0; 
      }else if(Tip==1&&Cont_Reglas.Definicion_Reglas_Salida[k].R[N_Entrada_or_Salida]==Posicion){//Salida
        Cont_Reglas.Definicion_Reglas_Salida[k].R[N_Entrada_or_Salida]=0;
        }
      if(Tip==0&&Posicion<Cont_Reglas.Definicion_Reglas_Entrada[k].R[N_Entrada_or_Salida]&&0!=Cont_Reglas.Definicion_Reglas_Entrada[k].R[N_Entrada_or_Salida]){//Entrada
        Cont_Reglas.Definicion_Reglas_Entrada[k].R[N_Entrada_or_Salida]=Cont_Reglas.Definicion_Reglas_Entrada[k].R[N_Entrada_or_Salida]-1; 
      }else if(Tip==1&&Posicion<Cont_Reglas.Definicion_Reglas_Salida[k].R[N_Entrada_or_Salida]&&0!=Cont_Reglas.Definicion_Reglas_Salida[k].R[N_Entrada_or_Salida]){//Salida
        Cont_Reglas.Definicion_Reglas_Salida[k].R[N_Entrada_or_Salida]=Cont_Reglas.Definicion_Reglas_Salida[k].R[N_Entrada_or_Salida]-1;
        }
        if(ContarNumeroDiferenteAX(Cont_Reglas.Definicion_Reglas_Salida[k].R,0)==0||ContarNumeroDiferenteAX(Cont_Reglas.Definicion_Reglas_Entrada[k].R,0)==0){
        Eliminar_Regla_Index(Posicion);
        Cont_Reglas.Cantidad=Cont_Reglas.Cantidad-1;
        }
      }
      
    }

void Actulizar_Reglas_Entrada_Salidas(int Posicion,int Tip){
   int[] Cant={CBE,CBS};
  //print("Datos: ");print(Posicion,CBE,CBS);println(" ");
    for(int k=0;k<Cont_Reglas.Cantidad;k+=1){   
      for(int j=0;j<Cant[Tip];j+=1){
      if(Tip==0&&Posicion<=j){//Entrada
        //print("J");print(j,"Valor en j: ",Cont_Reglas.Definicion_Reglas_Entrada[k].R[j],"Valor en j+1",Cont_Reglas.Definicion_Reglas_Entrada[k].R[j+1]);println(" ");
        Cont_Reglas.Definicion_Reglas_Entrada[k].R[j]=Cont_Reglas.Definicion_Reglas_Entrada[k].R[j+1]; 
      }else if(Tip==1&&Posicion<=j){//Salida
        Cont_Reglas.Definicion_Reglas_Salida[k].R[j]=Cont_Reglas.Definicion_Reglas_Salida[k].R[j+1];
        }
      }
      if(Tip==0){
        Cont_Reglas.Definicion_Reglas_Entrada[k].R[Cant[Tip]]=0;
      }else if(Tip==1){
      Cont_Reglas.Definicion_Reglas_Salida[k].R[Cant[Tip]]=0;
      }

    }
    for(int k=0;k<Cont_Reglas.Cantidad;k+=1){ 
         if(ContarNumeroDiferenteAX(Cont_Reglas.Definicion_Reglas_Salida[k].R,0)==0||ContarNumeroDiferenteAX(Cont_Reglas.Definicion_Reglas_Entrada[k].R,0)==0){
        Eliminar_Regla_Index(Posicion);//El error esta en eliminar Regla_Index 
        //Al eliminar una entrada esta se copia a la anterior con los valores por defecto
      }
    }
    
    }
    
    

public void Eliminar_Salida_Or_Entrada_Or_Funcion(GButton source, GEvent event) { 
  if(source==Entrada_boton.del&&CBE>1) {
    CBE=CBE-1;
    float[] Test1=SepararNumeros(DatosMod.TxtEntrada.getText());
    DatosMod.TxtEntrada.setText(DevString(Test1,CBE));
    BottonEnable_Or_Disable(In[CBE],false);
    GDropListEnable_Or_Disable(Entrada_Reglas.Selec[CBE],false);
    int c=Entrada_boton.Numero_DelOrAgg[0].getSelectedIndex();
    Actulizar_Reglas_Entrada_Salidas(c,0);
    for(int i=0;i<CBE;i+=1){
      if(c<=i&&i<CBE){
         Entrada_datos[i]=Entrada_datos[i+1]; 
        // for
        // Cont_Reglas.Definicion_Reglas_Entrada[k].R[N_Entrada_or_Salida]
         CE[i]=CE[i+1];
         Entrada_Reglas.Selec[i].setItems(ListFunc(Entrada_datos[i],CE[i]),Entrada_Reglas.Selec[i+1].getSelectedIndex());
               }
    }      
    Entrada_datos[CBE]=new Conjunto();
    if(Actual.SorE==false&&c==Actual.Numero-1){
    In[Actual.Numero-1].setLocalColorScheme(6);Actual.Numero=1;
    In[0].setLocalColorScheme(5);
    actualizar_funciones(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1],0,0);
    DatosMod.Nombre.setText(Entrada_datos[Actual.Numero-1].Funciones[0].nombre);
    actualizar_dato_Funcion();
    }else if(Actual.SorE==false&&Actual.Numero>CBE){
        Actual.Numero=CBE;  
        In[Actual.Numero-1].setLocalColorScheme(5);
        actualizar_funciones(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1],0,0);
        DatosMod.Nombre.setText(Entrada_datos[Actual.Numero-1].Funciones[0].nombre);
        actualizar_dato_Funcion();
    }
    Entrada_boton.Numero_DelOrAgg[0].setItems(Inicial(CBE),0);
  }else if(source==Funcion_boton.del){
    if(Actual.SorE==false&&1<CE[Actual.Numero-1]){
      CE[Actual.Numero-1]=CE[Actual.Numero-1]-1;
      int c=Funcion_boton.Numero_DelOrAgg[0].getSelectedIndex();
      Actulizar_Reglas_Funciones(c+1,Actual.Numero-1,0);
      for(int i=0;i<CE[Actual.Numero-1];i+=1){
        if(c<=i){
           Entrada_datos[Actual.Numero-1].Funciones[i]=actualizar_funciones_datos(Entrada_datos[Actual.Numero-1].Funciones,i+1); 
                }
        }
      if(Actual.SorE==false&&c==DatosMod.Numero.getSelectedIndex()){
       if(CE[Actual.Numero-1]==1){
         actualizar_dato_Funcion_1_In_OUT();
       }else{
        actualizar_dato_Funcion();
      }
      }
      Entrada_datos[Actual.Numero-1].Funciones[CE[Actual.Numero-1]]=new Fun();
      actualizar_funciones(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1],DatosMod.Numero.getSelectedIndex(),Funcion_boton.Numero_DelOrAgg[0].getSelectedIndex()); 
      Entrada_Reglas.Selec[Actual.Numero-1].setItems(ListFunc(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1]),Entrada_Reglas.Selec[Actual.Numero-1].getSelectedIndex());  
 
 }else if(Actual.SorE==true&&1<CS[Actual.Numero-1]){
      CS[Actual.Numero-1]=CS[Actual.Numero-1]-1;
      int c=Funcion_boton.Numero_DelOrAgg[0].getSelectedIndex();
      Actulizar_Reglas_Funciones(c+1,Actual.Numero-1,1);
      for(int i=0;i<CS[Actual.Numero-1];i+=1){
        if(c<=i){
           Salida_datos[Actual.Numero-1].Funciones[i]=actualizar_funciones_datos(Salida_datos[Actual.Numero-1].Funciones,i+1); 
                }
        }
      Salida_datos[Actual.Numero-1].Funciones[CS[Actual.Numero-1]]=new Fun();
      actualizar_funciones(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1],DatosMod.Numero.getSelectedIndex(),Funcion_boton.Numero_DelOrAgg[0].getSelectedIndex());     
      Salida_Reglas.Selec[Actual.Numero-1].setItems(ListFunc(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1]),Salida_Reglas.Selec[Actual.Numero-1].getSelectedIndex());
       if(Actual.SorE==true&&c==DatosMod.Numero.getSelectedIndex()){
         if(CS[Actual.Numero-1]==1){
         actualizar_dato_Funcion_1_In_OUT();
       }else{
        actualizar_dato_Funcion();
      }
       }
}
   
    
  }else if(source==Salida_boton.del&&CBS>1){
    CBS=CBS-1;
    BottonEnable_Or_Disable(Out[CBS],false);
    GDropListEnable_Or_Disable(Salida_Reglas.Selec[CBS],false);
    int c=Salida_boton.Numero_DelOrAgg[0].getSelectedIndex();
     Actulizar_Reglas_Entrada_Salidas(c,0);
    for(int i=0;i<CBS;i+=1){
      if(c<=i&&i<CBS){
         Salida_datos[i]=Salida_datos[i+1]; 
         CS[i]=CS[i+1];
         Salida_Reglas.Selec[i].setItems(ListFunc(Salida_datos[i],CS[i]),Salida_Reglas.Selec[i+1].getSelectedIndex());
               }
    }      
    Salida_datos[CBS]=new Conjunto();
    if(Actual.SorE==true&&c==Actual.Numero-1){
    Out[Actual.Numero-1].setLocalColorScheme(6);Actual.Numero=1;
    Out[0].setLocalColorScheme(5);
    actualizar_funciones(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1],0,0);
    DatosMod.Nombre.setText(Salida_datos[Actual.Numero-1].Funciones[0].nombre);
    actualizar_dato_Funcion();
    }else if(Actual.SorE==true&&Actual.Numero>CBS){
        Actual.Numero=CBS;  
        Out[Actual.Numero-1].setLocalColorScheme(5);
        actualizar_funciones(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1],0,0);
        DatosMod.Nombre.setText(Salida_datos[Actual.Numero-1].Funciones[0].nombre);
        actualizar_dato_Funcion();
    }
    Salida_boton.Numero_DelOrAgg[0].setItems(Inicial(CBS),0);
  }

}

Fun actualizar_funciones_datos(Fun[] CON1,int I_act){
  return relleno_datos_Fun(CON1[I_act].Numero,CON1[I_act].Tipo,CON1[I_act].Parametros[0],CON1[I_act].Parametros[1],CON1[I_act].Parametros[2],CON1[I_act].Parametros[3],CON1[I_act].nombre);
}

public void Entrada_Salida_Mostrar(GButton source, GEvent event) { //_CODE_:button1:524271:
  
  for(int i=0;i<max(CBE,CBS);i+=1){
    if(In[i]==source&&i<CBE){
      if(Actual.SorE==false){
        In[Actual.Numero-1].setLocalColorScheme(6);
      }else{
        Out[Actual.Numero-1].setLocalColorScheme(6);
      }
      In[i].setLocalColorScheme(5);
      Actual.Numero=i+1;Actual.SorE=false;
      actualizar_funciones(Entrada_datos[i],CE[i],0,0);
      actualizar_dato_Funcion();
      DatosMod.RangoM.setText("["+str(Entrada_datos[Actual.Numero-1].Limite[0])+"   "+str(Entrada_datos[Actual.Numero-1].Limite[1])+"]");
      DatosMod.RangoM.setEnabled(true);
  }else if(Out[i]==source&&i<CBS){
      if(Actual.SorE==false){
        In[Actual.Numero-1].setLocalColorScheme(6);
      }else{
        Out[Actual.Numero-1].setLocalColorScheme(6);
      }
      Out[i].setLocalColorScheme(5);
      Actual.Numero=i+1;Actual.SorE=true;
      actualizar_funciones(Salida_datos[i],CS[i],0,0); 
      actualizar_dato_Funcion();
      DatosMod.RangoM.setText("["+str(0)+"   "+str(255)+"]");
      DatosMod.RangoM.setEnabled(false);
    }
  }
} 


  

void actualizar_funciones(Conjunto CON1,int Cant,int indexNum,int IndexFun){
      DatosMod.Numero.setItems(ObtenerNombre(CON1,Cant),indexNum);
      Funcion_boton.Numero_DelOrAgg[0].setItems(ObtenerNombre(CON1,Cant),IndexFun); 
      
}


public void handleTextEvents(GEditableTextControl textControl, GEvent event) { 
  displayEvent(textControl.tag, event);
}

public void displayEvent(String name, GEvent event) {
  switch(event) {
    case LOST_FOCUS:
      if(name=="Nombre"){//Nombre
        if(Actual.SorE==false){
          Entrada_datos[Actual.Numero-1].Funciones[DatosMod.Numero.getSelectedIndex()].nombre=DatosMod.Nombre.getText();
          //DatosMod.Nombre.setText(Entrada_datos[Actual.Numero-1].Funciones[DatosMod.Numero.getSelectedIndex()].nombre);
          actualizar_funciones(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1],DatosMod.Numero.getSelectedIndex(),Funcion_boton.Numero_DelOrAgg[0].getSelectedIndex());
          Entrada_Reglas.Selec[Actual.Numero-1].setItems(ListFunc(Entrada_datos[Actual.Numero-1],CE[Actual.Numero-1]),Entrada_Reglas.Selec[Actual.Numero-1].getSelectedIndex());
        }else{
          Salida_datos[Actual.Numero-1].Funciones[DatosMod.Numero.getSelectedIndex()].nombre=DatosMod.Nombre.getText();
          //////DatosMod.Nombre.setText(Salida_datos[Actual.Numero-1].Funciones[DatosMod.Numero.getSelectedIndex()].nombre);
          actualizar_funciones(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1],DatosMod.Numero.getSelectedIndex(),Funcion_boton.Numero_DelOrAgg[0].getSelectedIndex());
          Salida_Reglas.Selec[Actual.Numero-1].setItems(ListFunc(Salida_datos[Actual.Numero-1],CS[Actual.Numero-1]),Salida_Reglas.Selec[Actual.Numero-1].getSelectedIndex());
      }
        
      }else if(name=="Datos"){//Datos
        float[] Test1=SepararNumeros(DatosMod.Dat0s.getText());
        println(Test1[0],Test1[1],Test1[2]);
        if(Actual.SorE==false){
          if(DatosMod.Tipo.getSelectedText()=="     Triangulo"){
             if(Test1[0]<Test1[1]&&Test1[1]<Test1[2]){
               
               Entrada_datos[Actual.Numero-1].Funciones[DatosMod.Numero.getSelectedIndex()].Parametros=Guardar(Test1,0);
               println(DevString(Test1,3));
               DatosMod.Dat0s.setText(DevString(Test1,3));//DevString
              // setText(DevString(Test1,3));
               
             }else{
               DatosMod.Dat0s.setText(Temporal.Parame);
             }
          }else{
             if(Test1[0]<Test1[1]&&Test1[1]<Test1[2]&&Test1[2]<Test1[3]){
               Entrada_datos[Actual.Numero-1].Funciones[DatosMod.Numero.getSelectedIndex()].Parametros=Guardar(Test1,1);
               DatosMod.Dat0s.setText(DevString(Test1,4));
             }else{
               DatosMod.Dat0s.setText(Temporal.Parame);
             }
            
          }
        }else{
          
          if(DatosMod.Tipo.getSelectedText()=="     Triangulo"){
            
             if(Test1[0]<Test1[1]&&Test1[1]<Test1[2]){
               Salida_datos[Actual.Numero-1].Funciones[DatosMod.Numero.getSelectedIndex()].Parametros=Guardar(Test1,0);
               DatosMod.Dat0s.setText(DevString(Test1,3));
             }else{
               DatosMod.Dat0s.setText(Temporal.Parame);
             }
          }else{
             if(Test1[0]<Test1[1]&&Test1[1]<Test1[2]&&Test1[2]<Test1[3]){
               Salida_datos[Actual.Numero-1].Funciones[DatosMod.Numero.getSelectedIndex()].Parametros=Guardar(Test1,1);
               DatosMod.Dat0s.setText(DevString(Test1,4));
           }else{
               DatosMod.Dat0s.setText(Temporal.Parame);
             }
            
          }          
          
        }
//C=C.substring(C.indexOf("[")+1,C.indexOf("]"));
       //DatosMod.Nombre.setText(Temporal.Nombre);
      }else if(name=="Rango"){//Rango
      if(Actual.SorE==false){
          float[] Test1=SepararNumeros(DatosMod.RangoM.getText());
          if(Test1[0]<Test1[1]){
            for(int i=0;i<CE[Actual.Numero-1];i+=1){
              Entrada_datos[Actual.Numero-1].Funciones[i].Parametros=Redimensionar(Entrada_datos[Actual.Numero-1].Funciones[i].Parametros,Entrada_datos[Actual.Numero-1].Limite,Test1);
            }
            DatosMod.RangoM.setText(DevString(Test1,2));
            Entrada_datos[Actual.Numero-1].Limite=Test1;
            actualizar_dato_Funcion();

          }else{
            DatosMod.RangoM.setText(Temporal.Rang);
            
          }
        }
      }else if(name=="TxtEntrada"){
        float[] Test1=SepararNumeros(DatosMod.TxtEntrada.getText());
        if(Test1.length==CBE){
          DatosMod.entrada_Regla=Test1;
          DatosMod.TxtEntrada.setText(DevString(Test1,CBE));
        }else{
          DatosMod.TxtEntrada.setText(Temporal.Entrada_Txt);
        }
      }
      break;
    case GETS_FOCUS:
      if(name=="Nombre"){
      }else if(name=="Datos"){
       Temporal.Parame=DatosMod.Dat0s.getText();
      }else if(name=="Rango"){
        Temporal.Rang=DatosMod.RangoM.getText();
      }else if(name=="TxtEntrada"){
        Temporal.Entrada_Txt=DatosMod.TxtEntrada.getText();
 // print(Test3[0]);
      }      
      break;
    default:
    
  }
}



public void Vacio(GDropList droplist, GEvent event) {
}


public void Seleccion_Tipo(GDropList droplist, GEvent event) {
  int indx=DatosMod.Numero.getSelectedIndex(),indx2=DatosMod.Tipo.getSelectedIndex();
  float[] Test1=SepararNumeros(DatosMod.Dat0s.getText());
  if(Actual.SorE==false){
    int Ti=Entrada_datos[Actual.Numero-1].Funciones[indx].Tipo-1;
    if(Ti!=indx2){
      if(Ti==0&&indx2==1){//0 1 0
        Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[0]=Test1[0];
        Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[1]=Test1[0]+(Test1[2]-Test1[0])/4;
        Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[2]=Test1[2]-(Test1[2]-Test1[0])/4;
        Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[3]=Test1[2];
        Entrada_datos[Actual.Numero-1].Funciones[indx].Tipo=2;
      }else{//0 0 1
        Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[0]=Test1[0];
        Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[1]=(Test1[1]+Test1[2])/2;
        Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[2]=Test1[3];
        Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[3]=0;
        Entrada_datos[Actual.Numero-1].Funciones[indx].Tipo=1;
      }
    actualizar_dato_Funcion();  
   }  
  }else{
    int Ti=Salida_datos[Actual.Numero-1].Funciones[indx].Tipo-1;
    if(Ti!=indx2){
      if(Ti==0&&indx2==1){
        Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[0]=Test1[0];
        Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[1]=Test1[0]+(Test1[2]-Test1[0])/4;
        Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[2]=Test1[2]-(Test1[2]-Test1[0])/4;
        Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[3]=Test1[2];
        Salida_datos[Actual.Numero-1].Funciones[indx].Tipo=2;
        
      }else{
        
        Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[0]=Test1[0];
        Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[1]=(Test1[1]+Test1[2])/2;
        Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[2]=Test1[3];
        Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[3]=0;
        Salida_datos[Actual.Numero-1].Funciones[indx].Tipo=1;
      }
    actualizar_dato_Funcion();
   }
  
}
}
public void Seleccion_Funcion(GDropList droplist,GEvent event) {
    actualizar_dato_Funcion();
    
}
void actualizar_dato_Funcion(){
  String Show;int indx=DatosMod.Numero.getSelectedIndex();
  if(Actual.SorE==false){
    Show="["+str(Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[0])+"   "+str(Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[1])+"   "+str(Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[2]);
    if(Entrada_datos[Actual.Numero-1].Funciones[indx].Tipo==2){
      Show=Show+"   "+str(Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[3]);
    }
    Show=Show+"]";
    
    DatosMod.Nombre.setText(Entrada_datos[Actual.Numero-1].Funciones[indx].nombre);
    DatosMod.Tipo.setItems(S_Tip,Entrada_datos[Actual.Numero-1].Funciones[indx].Tipo-1);
    DatosMod.RangoM.setText("["+str(Entrada_datos[Actual.Numero-1].Limite[0])+"   "+str(Entrada_datos[Actual.Numero-1].Limite[1])+"]");
  }else{
      Show="["+str(Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[0])+"   "+str(Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[1])+"   "+str(Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[2]);
    if(Salida_datos[Actual.Numero-1].Funciones[indx].Tipo==2){
      Show=Show+"   "+str(Salida_datos[indx].Funciones[0].Parametros[3]);
    }
    Show=Show+"]";
    DatosMod.Nombre.setText(Salida_datos[Actual.Numero-1].Funciones[indx].nombre);
    DatosMod.Tipo.setItems(S_Tip,Salida_datos[Actual.Numero-1].Funciones[indx].Tipo-1);
    DatosMod.RangoM.setText("["+str(Salida_datos[Actual.Numero-1].Limite[0])+"   "+str(Salida_datos[Actual.Numero-1].Limite[1])+"]");
  }
  DatosMod.Dat0s.setText(Show);
  
}

void actualizar_dato_Funcion_1_In_OUT(){
  String Show;int indx=0;
  if(Actual.SorE==false){
    Show="["+str(Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[0])+"   "+str(Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[1])+"   "+str(Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[2]);
    if(Entrada_datos[Actual.Numero-1].Funciones[indx].Tipo==2){
      Show=Show+"   "+str(Entrada_datos[Actual.Numero-1].Funciones[indx].Parametros[3]);
    }
    Show=Show+"]";
    
    DatosMod.Nombre.setText(Entrada_datos[Actual.Numero-1].Funciones[indx].nombre);
    DatosMod.Tipo.setItems(S_Tip,Entrada_datos[Actual.Numero-1].Funciones[indx].Tipo-1);
    DatosMod.RangoM.setText("["+str(Entrada_datos[Actual.Numero-1].Limite[0])+"   "+str(Entrada_datos[Actual.Numero-1].Limite[1])+"]");
  }else{
      Show="["+str(Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[0])+"   "+str(Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[1])+"   "+str(Salida_datos[Actual.Numero-1].Funciones[indx].Parametros[2]);
    if(Salida_datos[Actual.Numero-1].Funciones[indx].Tipo==2){
      Show=Show+"   "+str(Salida_datos[indx].Funciones[0].Parametros[3]);
    }
    Show=Show+"]";
    DatosMod.Nombre.setText(Salida_datos[Actual.Numero-1].Funciones[indx].nombre);
    DatosMod.Tipo.setItems(S_Tip,Salida_datos[Actual.Numero-1].Funciones[indx].Tipo-1);
    DatosMod.RangoM.setText("["+str(Salida_datos[Actual.Numero-1].Limite[0])+"   "+str(Salida_datos[Actual.Numero-1].Limite[1])+"]");
  }
  DatosMod.Dat0s.setText(Show);
  
}

public void slider1_change1(GSlider slider, GEvent event) { 
}
