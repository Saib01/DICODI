
public void Exportar_Controlador(GButton button, GEvent event){
PrintWriter output=createWriter("Codigo.txt");
  output.println("float E[][6]={");//Entrada
  for(int i=0;i<CBE;i+=1){
    for(int k=0;k<CE[i];k+=1){
      String Show="{"+str(i+1)+","+str(Entrada_datos[i].Funciones[k].Tipo)+",";
      for(int j=0;j<4;j+=1){ 
        Show=Show+str(Entrada_datos[i].Funciones[k].Parametros[j]);
        if(j!=3){
          Show=Show+",";
        }else if(j==3){
          Show=Show+"}";
        }
      }
      output.print(Show);
      if(i+1!=CBE||k+1<CE[CBE-1]){
          output.println(",");   
      }
    }
    if(i+1==CBE){
          output.println("};");
      }
    
  }
  //output.
  output.println("float S[][6]={");//Salida
  for(int i=0;i<CBS;i+=1){
    for(int k=0;k<CS[i];k+=1){
      String Show="{"+str(i+1)+","+str(Salida_datos[i].Funciones[k].Tipo)+",";
      for(int j=0;j<4;j+=1){ 
        Show=Show+str(Salida_datos[i].Funciones[k].Parametros[j]);
        if(j!=3){
          Show=Show+",";
        }else if(j==3){
          Show=Show+"}";
        }
      }
      output.print(Show);
      if(i+1!=CBS||k+1<CS[CBS-1]){
          output.println(",");   
      }
    }
    if(i+1==CBS){
          output.println("};");
      }
    
  }  
//output.
output.println("byte R[][100] ={");
    int[] Cant={CBE,CBS};
    for(int k=0;k<Cont_Reglas.Cantidad;k+=1){//Reglas
      String Show="{"+str(Cont_Reglas.Tipo_Operacion[k])+",";
      for(int i=0;i<2;i+=1){
        for(int j=0;j<Cant[i];j+=1){//Recorre entrada o salidaa
          if(i==0){
            Show=Show+str(Cont_Reglas.Definicion_Reglas_Entrada[k].R[j])+",";
        }else{
          Show=Show+str(Cont_Reglas.Definicion_Reglas_Salida[k].R[j]);// print(Show);
          if(j<Cant[i]-1){
            Show=Show+",";   
          }else if(j==Cant[i]-1&&k<Cont_Reglas.Cantidad-1){
            Show=Show+"},";  
          }else if(j==Cant[i]-1&&k==Cont_Reglas.Cantidad-1){
            Show=Show+"}};";  
          }
          
        }
      }
    }
    output.println(Show);
}
//output.
output.print("byte CE[]={");
for(int i=0;i<CBE;i+=1){
  output.print(str(CE[i]));
if(i!=CBE-1){
  output.print(",");
}else{
  output.print("},");
}
}

output.print("CS[]={");
for(int i=0;i<CBS;i+=1){
  output.print(str(CS[i]));
if(i!=CBS-1){
  output.print(",");
}else{
  output.print("},");
}
}
int[] Tam={CBE,CBS,Cont_Reglas.Cantidad};
output.print("Tam[]={");
for(int i=0;i<3;i+=1){
  output.print(str(Tam[i]));
if(i!=2){
  output.print(",");
}else{
  output.println("};");
}
}

output.print("float LimE"+"["+str(CBE)+"]"+"[2]={");
for(int i=0;i<CBE;i+=1){
  output.print("{"+str(Entrada_datos[i].Limite[0])+","+str(Entrada_datos[i].Limite[1])+"}");
if(i==CBE-1){
  output.println("};");
}else{
  output.print(",");
}
}
//float ={1,0} 
output.print("float x[]={");
for(int i=0;i<CBE;i+=1){
  output.print("Ingrese Entrada "+str(i+1));
if(i!=CBE-1){
  output.print(",");
}else{
  output.print("},");
}
}
output.println("OUTF["+str(CBS)+"];"); 
output.println("float S_Temp[100][5],U_Temp[50];");


output.println("void setup(){");
output.println("float Uin["+str(CBE)+"][50],Uout["+str(CBS)+"][50];");
output.println("Entrada(CE,x,E,LimE,Uin,Tam[0]);");
output.println("Salida_Reglas(R,Uin,CE,CS,Uout,Tam);");
output.println("byte con=0;");
output.println("for(byte i=0;i<Tam[1];i++){");
output.println("TemporalMatriz(S_Temp,S,con,con+CS[i]);");
output.println("TemporalVector(U_Temp,Uout,i,CS[i]);");
output.println("con=con+CS[i];");
output.println("Salida_Fuzzy(S_Temp,U_Temp,CS[i],OUTF);");
output.println("}");
output.println("}");

output.println("void loop(){}");

  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
}
