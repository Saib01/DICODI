
//Principal
//Funciones para calcular el valor de pertenencia de las entradas
void Entrada(byte CE[],float sign[],float In[][6],float limitIn[][2],float Out[][50],byte tam){//
  byte cont=0;
  for (byte j=0;j<tam;j++){
    sign[j]=constrain(sign[j],limitIn[j][0],limitIn[j][1]);
    for (byte i=0;i<CE[j];i++) {
     Out[j][i]=Clasificacion_Entrada(sign[j],In[i+cont][1],In[i+cont][2],In[i+cont][3],In[i+cont][4],In[i+cont][5]);
    }
    cont=cont+CE[j];
  }
}
void Salida_Reglas(byte R[][100],float Uin[][50],byte CE[],byte CS[],float Uout[][50],byte Tam[]){
  for(byte i=0;i<Tam[1]+1;i++){
    for(byte j=0;j<CS[i]+1;j++){
      Uout[i][j]=0;
    }
  }
  for(byte i=0;i<Tam[2];i++){
    float Acu;
    switch(R[i][0]){
          case 0:
              Acu=R_CaseN0(Uin,0,R[i][1]);
              for(byte j=2;j<Tam[0]+1;j++){
                  Acu=max(Acu,R_CaseN0(Uin,j-1,R[i][j]));
                  }
              break;
          case 1:
              Acu=R_CaseN1(Uin,0,R[i][1]);
              for(byte j=2;j<Tam[0]+1;j++){
                  Acu=min(Acu,R_CaseN1(Uin,j-1,R[i][j]));
              }
              break;
                   }
   for(byte j=0;j<Tam[1];j++){
        if(R[i][Tam[0]+1+j]!=0){
            Uout[j][R[i][1+Tam[0]+j]-1]=max(Uout[j][R[i][1+Tam[0]+j]-1],Acu);
                                }
                             }
                            }
}

//Funciones para calcular el valor de pertenencia de las Salidas
float R_CaseN0(float Ux[][50],byte fila,byte colm){
  float Acu=0.0;
  if(colm!=0){
      Acu=Ux[fila][colm-1];
              }
  return Acu;
}

float R_CaseN1(float Ux[][50],byte fila,byte colm){
  float Acu=1000.0;
  if(colm!=0){
      Acu=Ux[fila][colm-1];
              }
  return Acu;
}



float Salida_Fuzzy(float S[][5],float Ux[],byte CN){
  float Temp1[15],AFT=0,XCT=0,Vec_Temp1[2];
  for(byte j=0;j<CN;j++){ 
      for(byte i=j;i<CN;i++){
          if(j!=i&&Ux[j]!=0&&Ux[i]!=0){
              FuncionInterSelec(Ux[j],S[j][0],S[j][1],S[j][2],S[j][3],S[j][4],Ux[i],S[i][0],S[i][1],S[i][2],S[i][3],S[i][4],Temp1);
              if(Temp1[1]!=500){
                SalidaFun(Temp1,Vec_Temp1);
                AFT=AFT-Vec_Temp1[0];
                XCT=XCT-Vec_Temp1[1];
              }    
           }
       }
  }
  for(byte i=0;i<CN;i++){
      if(Ux[i]!=0){
        float Temp1[15]={S[i][0],S[i][1],S[i][2],S[i][3],S[i][4],Ux[i],5,1,0,0,0,0,0,0,0};
          SalidaFun(Temp1,Vec_Temp1);
          AFT=AFT+Vec_Temp1[0];
          XCT=XCT+Vec_Temp1[1];
      }
  }
  float Out=XCT/AFT;
  return Out;
}


//Funciones secundarias


float Clasificacion_Entrada(float sign,int ID,float a,float b,float c,float d){
  float Out; 
     switch(ID){
       case 1:
          Out=Funcion_Triangular(sign,a,b,c);
          break;
        case 2:
          Out=Funcion_Trapezoidal(sign,a,b,c,d);
          break;
         }
   return Out;
 }
 
float Funcion_Triangular(float sign,float a,float m,float b){//Ok
  float Out;
  if(sign<=a||sign>b){
      Out=0;
  }else if(sign<=m){
      Out=(sign-a)/(m-a);
  }else if(sign<=b){
      Out=(b-sign)/(b-m);
  }
  return Out;
}

float Funcion_Trapezoidal(float sign,float a,float b,float c,float d){//Ok
  float Out;
  if(sign<=a||sign>d){
      Out=0;
  }else if(sign<=b){
      Out=(sign-a)/(b-a);
  }else if (sign<=c){
      Out=1;
  }else if(sign<=d){
      Out=(d-sign)/(d-c);
  }
  return Out;
}



void FuncionInterSelec(float U1,byte ID1,float a1,float b1,float c1,float d1,float U2,byte ID2,float a2,float b2,float c2,float d2,float OUT[]){
  if(ID1==1&&ID2==1){
      InterTrian(U1,a1,b1,c1,U2,a2,b2,c2,OUT);
  }else if(ID1==1&&ID2==2){
      InterTrapTri(U1,a1,b1,c1,U2,a2,b2,c2,d2,OUT);
  }else if(ID1==2&&ID2==1){
      InterTrapTri(U2,a2,b2,c2,U1,a1,b1,c1,d1,OUT);
  }else if(ID1==2&&ID2==2){
    InterTrapTrap(U1,a1,b1,c1,d1,U2,a2,b2,c2,d2,OUT);
  }
}

float SalidaFun(float Par[],float OUT[]){
  if(Par[0]==1){
      SalidaTr(Par[1],Par[2],Par[3],Par[5],Par[6],Par[7],Par[8],Par[9],Par[10],Par[11],Par[12],Par[13],Par[14],OUT);
  }else if(Par[0]==2){
      SalidaTrap(Par[1],Par[2],Par[3],Par[4],Par[5],Par[6],Par[7],Par[8],Par[9],Par[10],Par[11],Par[12],Par[13],Par[14],OUT);
  }
}

void InterTrian(float U1,float a1,float m1,float b1,float U2,float a2,float m2,float b2,float OUT[]){
  float ax,bx,mx,U,Us,msx,asx,Us1,ms1x,as1x;
  int Case=0;
  if(b1>=a2&&b1<=b2&&a1<=a2&&m1<=m2){
      ax=a2;bx=b1;
      mx=(a2*(b1-m1)+b1*(m2-a2))/((b1-m1)+(m2-a2));
      U=(mx-a2)/(m2-a2); 
  }else if(b2>=a1&&b2<=b1&&a2<=a1&&m2<=m1){
      ax=a1;bx=b2;
      mx=(a1*(b2-m2)+b2*(m1-a1))/((b2-m2)+(m1-a1));
      U=(mx-a1)/(m1-a1); 
  }else if(b1>=a2&&b1<=b2&&a1<=a2&&m1>m2){
      ax=a1;bx=b2;asx=a2;as1x=b1;Case=2;
      mx=(b2*(m1-a1)+a1*(b2-m2))/((b2-m2)+(m1-a1));
      U=(mx-a1)/(m1-a1); 
      msx=(-a2*(m1-a1)+a1*(m2-a2))/((m2-a2)-(m1-a1));
      Us=(msx-a1)/(m1-a1);
      ms1x=(b2*(b1-m1)-b1*(b2-m2))/((b1-m1)-(b2-m2));
      Us1=(b1-ms1x)/(b1-m1);
  }else if(b2>=a1&&b2<=b1&&a2<=a1&&m2>m1){ 
      ax=a2;bx=b1;asx=a1;as1x=b2;Case=2;
      mx=(b1*(m2-a2)+a2*(b1-m1))/((b1-m1)+(m2-a2));
      U=(mx-a2)/(m2-a2); 
      msx=(-a1*(m2-a2)+a2*(m1-a1))/((m1-a1)-(m2-a2));
      Us=(msx-a2)/(m2-a2);
      ms1x=(b1*(b2-m2)-b2*(b1-m1))/((b2-m2)-(b1-m1));
      Us1=(b2-ms1x)/(b2-m2);    
  }else if(a2>=a1&&b1>=b2&&m1>=m2){
      ax=a1;asx=a2;bx=b2;Case=1;
      mx=(a1*(b2-m2)+b2*(m1-a1))/((b2-m2)+(m1-a1));
      U=(mx-a1)/(m1-a1);    
      msx=(a1*(m2-a2)-a2*(m1-a1))/((m2-a2)-(m1-a1));    
      Us=(msx-a1)/(m1-a1);
      if(msx==mx){
          ax=a2;Case=0;
      }
  }else if(a2>=a1&&b1>=b2&&m2>=m1){
      ax=a2;asx=b2; bx=b1;
      mx=(a2*(b1-m1)+b1*(m2-a2))/((b1-m1)+(m2-a2));
      U=(mx-a2)/(m2-a2);
      msx=(b1*(b2-m2)-b2*(b1-m1))/((b2-m2)-(b1-m1));    
      Us=(b2-msx)/(b2-m2);
      Case=1;
      if(msx==mx){
          bx=b2;Case=0;
      }
  }else if(a1>=a2&&b2>=b1&&m2>=m1){
      ax=a2;asx=a1;bx=b1;Case=1;
      mx=(a2*(b1-m1)+b1*(m2-a2))/((b1-m1)+(m2-a2));    
      U=(mx-a2)/(m2-a2);
      msx=(a2*(m1-a1)-a1*(m2-a2))/((m1-a1)-(m2-a2));    
      Us=(msx-a2)/(m2-a2);
      if(msx==mx){
          ax=a1;Case=0;
       }
  }else if(a1>=a2&&b2>=b1&&m1>=m2){
      ax=a1;bx=b2;asx=b1;
      mx=(a1*(b2-m2)+b2*(m1-a1))/((b2-m2)+(m1-a1));
      U=(mx-a1)/(m1-a1);
      msx=(b2*(b1-m1)-b1*(b2-m2))/((b1-m1)-(b2-m2));    
      Us=(b1-msx)/(b1-m1);
      Case=1;
      if(msx==mx){
          bx=b1;Case=0;
      }     
  }else{ 
      ax=500;mx=ax;bx=ax;U=ax;
      }
  if(Case!=2){
      Us1=500; ms1x=Us1;as1x=Us1;
    }
  if(Case==0){
      Us=500; msx=Us;asx=Us;
    }  
  float x[15]={1,ax,mx,bx,0,U1,U2,U,Us,msx,asx,Case,Us1,ms1x,as1x};
  TempVect(OUT,x,0,14);
}


void TempVect(float VectorTemp[],float Vect_Original[],byte Min,byte Max){
  for (int j=Min;j<=Max;j++){
    VectorTemp[j-Min]=Vect_Original[j];
  }
  }

void InterTrapTri(float U1,float a1,float m1,float b1,float U2,float a2,float b2,float c2,float d2,float OUT[]){
  float ax,bx,mx,U,Us,msx,asx,Us1,ms1x,as1x;
  byte Case;
  if(b1>=a2&&d2>=b1&&a1<=a2&&m1<=b2){
      ax=a2;bx=b1;Case=0;
      mx=(a2*(b1-m1)+b1*(b2-a2))/((b1-m1)+(b2-a2));
      U=(mx-a2)/(b2-a2); 
  }else if(d2>=a1&&d2<=b1&&a2<=a1&&c2<=m1){
      ax=a1;bx=d2;Case=0;
      mx=(a1*(d2-c2)+d2*(m1-a1))/((d2-c2)+(m1-a1));
      U=(mx-a1)/(m1-a1);
  }else if(d2>=a1&&d2<b1&&a2<a1&&b2>m1){ 
      ax=a2;bx=b1;asx=a1;as1x=d2;Case=2;
      mx=(a2*(b1-m1)+b1*(b2-a2))/((b2-a2)+(b1-m1));
      U=(mx-a2)/(b2-a2); 
      msx=(a1*(b2-a2)-a2*(m1-a1))/((b2-a2)-(m1-a1));
      Us=(msx-a1)/(m1-a1);
      ms1x=(b1*(d2-c2)-d2*(b1-m1))/((d2-c2)-(b1-m1));
      Us1=(b1-ms1x)/(b1-m1);
  }else if(a2>a1&&a2<b1&&b1<d2&&m1>c2){ 
      ax=a1;bx=d2;asx=a2;as1x=b1;Case=2;
      mx=(a1*(d2-c2)+d2*(m1-a1))/((m1-a1)+(d2-c2));
      U=(mx-a1)/(m1-a1); 
      msx=(a1*(b2-a2)-a2*(m1-a1))/((b2-a2)-(m1-a1));
      Us=(msx-a1)/(m1-a1);
      ms1x=(b1*(d2-c2)-d2*(b1-m1))/((d2-c2)-(b1-m1));
      Us1=(b1-ms1x)/(b1-m1);
  }else if(d2>=b1&&a2<a1&&b2>m1){ 
      ax=a2;bx=b1;asx=a1;Case=1;
      mx=(a2*(b1-m1)+b1*(b2-a2))/((b2-a2)+(b1-m1));
      U=(mx-a2)/(b2-a2); 
      msx=(a1*(b2-a2)-a2*(m1-a1))/((b2-a2)-(m1-a1));
      Us=(msx-a1)/(m1-a1);
  }else if(a1>=a2&&d2>=b1&&m1>c2){
      ax=a1;bx=d2;asx=b1;Case=1;
      mx=(a1*(d2-c2)+d2*(m1-a1))/((d2-c2)+(m1-a1));
      U=(mx-a1)/(m1-a1);
      msx=(b1*(d2-c2)-d2*(b1-m1))/((d2-c2)-(b1-m1));    
      Us=(d2-msx)/(d2-c2);
  }else if(a2>=a1&&b1>d2&&b2>m1){
      ax=a2;asx=d2;bx=b1;Case=1;
      mx=(a2*(b1-m1)+b1*(b2-a2))/((b1-m1)+(b2-a2));    
      U=(mx-a2)/(b2-a2);
      msx=(b1*(d2-c2)-d2*(b1-m1))/((d2-c2)-(b1-m1));  
      Us=(b1-msx)/(b1-m1);
  }else if(d2>=b1&&a1<=a2&&m1>=b2&&m1<=c2){
      ax=a1;mx=m1;bx=b1;U=1;asx=a2;Case=1;
      msx=(a1*(b2-a2)-a2*(m1-a1))/((b2-a2)-(m1-a1));
      Us=(msx-a1)/(m1-a1);
  }else if(a2>=a1&&d2<=b1&&m1>=b2&&m1<=c2){ 
      ax=a1;mx=m1;bx=b1;U=1;asx=a2;as1x=d2;Case=2; 
      msx=(a1*(b2-a2)-a2*(m1-a1))/((b2-a2)-(m1-a1));
      Us=(msx-a1)/(m1-a1);
      ms1x=(b1*(d2-c2)-d2*(b1-m1))/((d2-c2)-(b1-m1));
      Us1=(b1-ms1x)/(b1-m1); 
  }else if(a2>a1&&d2<=b1&&m1>c2){ 
      ax=a1;bx=d2;asx=a2;Case=1; 
      mx=(d2*(m1-a1)+a1*(d2-c2))/((d2-c2)+(m1-a1));
      U=(mx-a1)/(m1-a1); 
      msx=(a1*(b2-a2)-a2*(m1-a1))/((b2-a2)-(m1-a1));
      Us=(msx-a1)/(m1-a1);
  }else if(b1>d2&&a2<=a1&&m1>=b2&&m1<=c2){ 
      ax=a1;mx=m1;bx=b1;U=1;asx=d2;Case=1; 
      msx=(b1*(d2-c2)-d2*(b1-m1))/((d2-c2)-(b1-m1));
      Us=(msx-a1)/(m1-a1);
  }else if(d2>=b1&&a2<=a1&&m1>=b2&&m1<=c2){ 
      ax=a1;mx=m1;bx=b1;U=1;Case=0;
  }else{ 
      ax=500;mx=ax;bx=ax;U=ax;Case=0;
  }
  if(Case!=2){
      Us1=500; ms1x=Us1;as1x=Us1;
    }
  if(Case==0){
      Us=500; msx=Us;asx=Us;
    }  
  float x[15]={1,ax,mx,bx,0,U1,U2,U,Us,msx,asx,Case,Us1,ms1x,as1x};
  TempVect(OUT,x,0,14);
}


void InterTrapTrap(float U1,float a1,float b1,float c1,float d1,float U2,float a2,float b2,float c2,float d2,float OUT[]){
  float ax,bx,cx,dx,mx,U,Us,msx,asx,Us1,ms1x,as1x;
  byte Case;
  if(a2>=a1&&a2<=d1&&d1<=d2&&c1<=b2){
      ax=a2;bx=d1;Case=0;
      mx=(a1*(d2-c2)+d2*(b1-a1))/((d2-c2)+(b1-a1));
      U=(mx-a1)/(b1-a1); 
  }else if(a1>=a2&&a1<=d2&&d2<=d1&&c2<=b1){
      ax=a1;bx=d2;Case=0;
      mx=(a2*(d1-c1)+d1*(b2-a2))/((d1-c1)+(b2-a2));
      U=(mx-a2)/(b2-a2); 
  }else if(a2>=a1&&d1>=d2&&c1<=b2){
      ax=a2;bx=d1;asx=d2;Case=1;
      mx=(a2*(d1-c1)+d1*(b2-a2))/((d1-c1)+(b2-a2));
      U=(mx-a2)/(b2-a2);
      msx=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us=(d2-msx)/(d2-c2);
  }else if(a1>=a2&&d2>=d1&&c2<=b1){
      ax=a1;bx=d2;asx=d1;Case=1;
      mx=(a1*(d2-c2)+d2*(b1-a1))/((d2-c2)+(b1-a1));
      U=(mx-a1)/(b1-a1);
      msx=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us=(d2-msx)/(d2-c2);
  }else if(a2>=a1&&d1<=d2&&c1>=b2&&b2>=b1&&c2>=c1){
      ax=a2;bx=b2;cx=c1;dx=d1;U=1;Case=3;
  }else if(a1>=a2&&d2<=d1&&c2>=b1&&b1>=b2&&c1>=c2){
      ax=a1;bx=b1;cx=c2;dx=d2;U=1;Case=3;
  }else if(a2>=a1&&d1<=d2&&c1>=c2&&b2>=b1){
      ax=a2;bx=b2;cx=c2;dx=d2;U=1;asx=d1;Case=4;
      msx=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us=(d2-msx)/(d2-c2);
  }else if(a1>=a2&&d2<=d1&&c2>=c1&&b1>=b2){
      ax=a1;bx=b1;cx=c1;dx=d1;U=1;asx=d2;Case=4;
      msx=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us=(d2-msx)/(d2-c2);
  }else if(a2>=a1&&d2<=d1&&c2>=c1&&b2>=b1&&b2<=c1){
      ax=a2;bx=b2;cx=c1;dx=d1;U=1;asx=d2;Case=4;
      msx=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us=(d2-msx)/(d2-c2); 
  }else if(a1>=a2&&d1<=d2&&c1>=c2&&b1>=b2&&b1<=c2){
      ax=a1;bx=b1;cx=c2;dx=d2;U=1;asx=d1;Case=4;
      msx=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us=(d2-msx)/(d2-c2);
  }else if(a2>=a1&&d2<=d1&&c2<=c1&&b2>=b1){
      ax=a2;bx=b2;cx=c2;dx=d2;U=1;Case=3;
  }else if(a1>=a2&&d1<=d2&&c1<=c2&&b1>=b2){
      ax=a1;bx=b1;cx=c1;dx=d1;U=1;Case=3;
  }else if(a2>=a1&&d2>=d1&&c2>=c1&&b2<=b1){
      ax=a1;bx=b1;cx=c1;dx=d1;U=1;asx=a2;Case=4;
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
  }else if(a1>=a2&&d1>=d2&&c1>=c2&&b1<=b2){
      ax=a2;bx=b2;cx=c2;dx=d2;U=1;asx=a1;Case=4;
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
  }else if(a2>=a1&&d2>=d1&&c2<=c1&&c2>=b1&&b2<=b1){
      ax=a1;bx=b1;cx=c2;dx=d2;U=1;asx=a2;as1x=d1;Case=5;
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
      ms1x=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us1=(d2-ms1x)/(d2-c2);
  }else if(a1>=a2&&d1>=d2&&c1<=c2&&c1>=b2&&b1<=b2){
      ax=a2;bx=b2;cx=c1;dx=d1;U=1;asx=a1;as1x=d2;Case=5;
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
      ms1x=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us1=(d2-ms1x)/(d2-c2);
  }else if(a2>=a1&&d2<=d1&&c2>=c1&&b2<=b1){
      ax=a1;bx=b1;cx=c1;dx=d1;U=1;asx=a2;as1x=d2;Case=5;
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
      ms1x=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us1=(d2-ms1x)/(d2-c2);
  }else if(a1>=a2&&d1<=d2&&c1>=c2&&b1<=b2){
      ax=a2;bx=b2;cx=c2;dx=d2;U=1;asx=a1;as1x=d1;Case=5;
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
      ms1x=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us1=(d2-ms1x)/(d2-c2);
  }else if(a2>=a1&&d2<=d1&&c2<=c1&&c2>=b1&&b2<=b1){
      ax=a1;bx=b1;cx=c2;dx=d2;U=1;asx=a2;Case=4;
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
  }else if(a1>=a2&&d1<=d2&&c1<=c2&&c1>=b2&&b1<=b2){
      ax=a2;bx=b2;cx=c1;dx=d1;U=1;asx=a1;Case=4;
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
  }else if(a2<=a1&&d2<=d1&&c1<=b2){
      ax=a2;bx=d1;asx=a1;as1x=d2;Case=2;
      mx=(a2*(d1-c1)+d1*(b2-a2))/((d1-c1)+(b2-a2));
      U=(mx-a2)/(b2-a2);
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
      ms1x=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us1=(d2-ms1x)/(d2-c2);
  }else if(a1<=a2&&d1<=d2&&c2<=b1){   
      ax=a1;bx=d2;asx=a2;as1x=d1;Case=2;
      mx=(a1*(d2-c2)+d2*(b1-a1))/((d2-c2)+(b1-a1));
      U=(mx-a1)/(b1-a1);
      msx=(a1*(b2-a2)-a2*(b1-a1))/((b2-a2)-(b1-a1));
      Us=(msx-a2)/(b2-a2);
      ms1x=(d1*(d2-c2)-d2*(d1-c1))/((d2-c2)-(d1-c1));
      Us1=(d2-ms1x)/(d2-c2);
  }else{ 
      ax=500;mx=ax;bx=ax;U=ax;
      Case=0;
  }
  if(Case<=2){
    dx=0;
    }
  else{
    mx=bx;bx=cx;
      }
  if(Case!=2&&Case!=5){
      Us1=500; ms1x=Us1;as1x=Us1;
    }
  if(Case==0||Case==5){
      Us=500; msx=Us;asx=Us;
    }  
  float x[15]={1,ax,mx,bx,dx,U1,U2,U,Us,msx,asx,Case,Us1,ms1x,as1x};
  TempVect(OUT,x,0,14);
}

void SalidaTr(float ax,float mx,float bx,float U1,float U2,float U,float Us,float msx,float asx,float Case,float Us1,float ms1x,float as1x,float OUT[]){
  float TC1[2],TC2[2],TC3[2]={0,0},TC4[2]={0,0},TC5[2]={0,0},TC6[2]={0,0};
  float TC1q[2],TC2q[2],TC3q[2]={0,0},TC4q[2]={0,0},TC5q[2]={0,0},TC6q[2]={0,0},H_temp[2],UR;
  UR=min(min(U1,U2),U);
  PtosTr(ax,mx,bx,UR,U,H_temp);
  ATCT(ax,mx,U,2,TC1);
  ATCT(mx,bx,U,1,TC2);
  ATCT(H_temp[0],mx,U-UR,2,TC1q);
  ATCT(mx,H_temp[1],U-UR,1,TC2q);
  if(Case==1&&mx>msx||Case==2){
      ATCT(ax,msx,Us,2,TC3q);
      ATCT(asx,msx,Us,2,TC4);
      UR=min(min(U1,U2),Us);
      PtosTr(ax,msx,bx,UR,Us,H_temp);
      ATCT(H_temp[0],msx,Us-UR,2,TC3);
      PtosTr(asx,msx,bx,UR,Us,H_temp);
      ATCT(H_temp[0],msx,Us-UR,2,TC4q);
      if(Case==2){
          ATCT(ms1x,bx,Us1,1,TC5q);
          ATCT(ms1x,as1x,Us1,1,TC6);
          UR=min(min(U1,U2),Us1);
          PtosTr(ax,ms1x,bx,UR,Us1,H_temp);
          ATCT(ms1x,H_temp[1],Us1-UR,1,TC5);
          PtosTr(ax,ms1x,as1x,UR,Us1,H_temp);
          ATCT(ms1x,H_temp[1],Us1-UR,1,TC6q); 
      }
  }else if(Case==1&&mx<msx){
      ATCT(msx,bx,Us,1,TC3q);
      ATCT(msx,asx,Us,1,TC4);
      UR=min(min(U1,U2),Us);
      PtosTr(ax,msx,bx,UR,Us,H_temp);
      ATCT(msx,H_temp[1],Us-UR,1,TC3);
      PtosTr(ax,msx,asx,UR,Us,H_temp);
      ATCT(msx,H_temp[1],Us-UR,1,TC4q);
  }
  OUT[0]=TC1[0]+TC2[0]+TC3[0]+TC4[0]+TC5[0]+TC6[0]-TC1q[0]-TC2q[0]-TC3q[0]-TC4q[0]-TC5q[0]-TC6q[0];
  OUT[1]=(TC1[0]*TC1[1])+(TC2[0]*TC2[1])+(TC3[0]*TC3[1])+(TC4[0]*TC4[1])+(TC5[0]*TC5[1])+(TC6[0]*TC6[1]);
  OUT[1]=OUT[1]-(TC1q[0]*TC1q[1])-(TC2q[0]*TC2q[1])-(TC3q[0]*TC3q[1])-(TC4q[0]*TC4q[1])-(TC5q[0]*TC5q[1])-(TC6q[0]*TC6q[1]);
}

void PtosTr(float xa,float xm,float xb,float UR,float U,float OUT[]){
  OUT[0]=xa+UR*(xm-xa)/U;
  OUT[1]=xb-UR*(xb-xm)/U;
}

void ATCT(float L1,float L2,float U,float N,float OUT[]){
   float T1,C1,Ux,Tr,CTr,Re,CRe,Ux2;
    if(L2<=255.0&&L1>=0){
        T1=(L2-L1)*U/2;
        C1=L1+(L2-L1)*N/3;
    }else if(L2>255.0&&L1>=0&&L1<=255.0){
        if(N==1){
            Ux=U*(L2-255.0)/(L2-L1);
            Tr=(255.0-L1)*(U-Ux)/2;
            CTr=L1+(255.0-L1)*N/3;
            Re=(255.0-L1)*Ux;
            CRe=L1+(255.0-L1)*1/2;
            T1=Tr+Re;
            C1=(Re*CRe+Tr*CTr)/T1;
        }else{
            Ux=U*(255.0-L1)/(L2-L1);    
            T1=(255.0-L1)*Ux/2;
            C1=L1+(255.0-L1)*N/3;
        }
    }else if(L2<=255.0&&L2>0&&L1<0){
        if(N==2){
            Ux=U*(0-L1)/(L2-L1);
            Tr=(L2-0)*(U-Ux)/2;
            CTr=0+(L2-0)*N/3;
            Re=(L2-0)*Ux;
            CRe=0+(L2-0)*1/2;
            T1=Tr+Re;
            C1=(Re*CRe+Tr*CTr)/T1;
        }else{
            Ux=U*(L2-0)/(L2-L1);
            T1=(L2)*Ux/2;
            C1=0+(L2-0)*N/3;
        }
    }else if(L2>255.0&&L1<0){
        if(N==2){
            Ux=U*(0-L1)/(L2-L1);
            Ux2=U*(255.0-L1)/(L2-L1);
            Tr=(255.0-0)*(Ux2-Ux)/2;
            CTr=0+(255.0-0)*N/3;
            Re=(255.0-0)*Ux;

        }else{
            Ux=U*(L2-0)/(L2-L1);
            Ux2=U*(L2-255.0)/(L2-L1);
            Tr=(255.0-0)*(Ux-Ux2)/2;
            CTr=0+(255.0-0)*N/3;
            Re=(255.0-0)*Ux2;
        }
            CRe=0+(255.0-0)*1/2;
            T1=Tr+Re;
            C1=(Re*CRe+Tr*CTr)/T1;
    }else{
    T1=0;    
    }

   if(T1==0){
    C1=0;
   }
   OUT[0]=T1;
   OUT[1]=C1;
}

void SalidaTrap(float ax,float bx,float cx,float dx,float U1,float U2,float U,float Us,float msx,float asx,float Case,float Us1,float ms1x,float as1x,float OUT[]){
  float TC1[2],TC3[2]={0,0},TC4[2]={0,0},TC5[2]={0,0},TC6[2]={0,0};
  float TC1q[2],TC3q[2]={0,0},TC4q[2]={0,0},TC5q[2]={0,0},TC6q[2]={0,0},H_temp[2],UR;
  UR=min(min(U1,U2),U);
  PtosTrap(ax,bx,cx,dx,UR,U,H_temp);
  ARTRA(ax,bx,cx,dx,U,TC1);
  ARTRA(H_temp[0],bx,cx,H_temp[1],U-UR,TC1q);
  if(Case==4&&bx>msx||Case==5){
      ATCT(ax,msx,Us,2,TC3q);
      ATCT(asx,msx,Us,2,TC4);
      UR=min(min(U1,U2),Us);
      PtosTr(ax,msx,0,UR,Us,H_temp);
      ATCT(H_temp[0],msx,Us-UR,2,TC3);
      PtosTr(asx,msx,0,UR,Us,H_temp);
      ATCT(H_temp[0],msx,Us-UR,2,TC4q);
      if(Case==5){
          ATCT(ms1x,dx,Us1,1,TC5q);
          ATCT(ms1x,as1x,Us1,1,TC6);
          UR=min(min(U1,U2),Us1);
          PtosTr(0,ms1x,dx,UR,Us1,H_temp);
          ATCT(ms1x,H_temp[1],Us1-UR,1,TC5);
          PtosTr(0,ms1x,as1x,UR,Us1,H_temp);
          ATCT(ms1x,H_temp[1],Us1-UR,1,TC6q); 
      }
  }else if(Case==4&&bx<msx){
      ATCT(msx,dx,Us,1,TC3q);
      ATCT(msx,asx,Us,1,TC4);
      UR=min(min(U1,U2),Us);
      PtosTr(0,msx,dx,UR,Us,H_temp);
      ATCT(msx,H_temp[1],Us-UR,1,TC3);
      PtosTr(0,msx,asx,UR,Us,H_temp);
      ATCT(msx,H_temp[1],Us-UR,1,TC4q);
  }
  OUT[0]=TC1[0]+TC3[0]+TC4[0]+TC5[0]+TC6[0]-TC1q[0]-TC3q[0]-TC4q[0]-TC5q[0]-TC6q[0];
  OUT[1]=(TC1[0]*TC1[1])+(TC3[0]*TC3[1])+(TC4[0]*TC4[1])+(TC5[0]*TC5[1])+(TC6[0]*TC6[1]);
  OUT[1]=OUT[1]-(TC1q[0]*TC1q[1])-(TC3q[0]*TC3q[1])-(TC4q[0]*TC4q[1])-(TC5q[0]*TC5q[1])-(TC6q[0]*TC6q[1]);
}

void ARCR(float L1,float L2,float U,float Out[]){
  float L1p=constrain(L1,0,255);
  float L2p=constrain(L2,0,255);
  if(U>0){
      Out[0]=(L2p-L1p)*U;
      Out[1]=L1p+(L2p-L1p)*1/2;
  }else{
      Out[0]=0;    
  }
  if(Out[0]==0){
     Out[1]=0;
  }
}

void ARTRA(float a,float b,float c,float d,float U,float OUT[]){
  float TC1[2],RCT1[2],TC2[2];
  ATCT(a,b,U,2,TC1);
  ARCR(b,c,U,RCT1);
  ATCT(c,d,U,1,TC2);
  OUT[0]=TC1[0]+RCT1[0]+TC2[0];
  if(OUT[0]==0){
      OUT[1]=0;
  }else{
      OUT[1]=(TC1[0]*TC1[1]+RCT1[0]*RCT1[1]+TC2[0]*TC2[1])/OUT[0];
  }
}


void PtosTrap(float xa,float xb,float xc,float xd,float UR,float U,float OUT[]){
  OUT[0]=xa+UR*(xb-xa)/U;
  OUT[1]=xd-UR*(xd-xc)/U;
}




//Funciones para imprimir,recortar matrices y vectores
void TemporalMatriz(float MatrizTemp[][5],float M_Original[][6],byte Minimo,byte Maximo){
  for (byte i=Minimo;i<Maximo;i++) { 
  for (byte j=0;j<5;j++){
    MatrizTemp[i-Minimo][j]=M_Original[i][j+1];
  }
  }
}
  
void TemporalVector(float VectorTemp[],float V_Original[][50],byte Entrada,byte Cantidad){
  for (byte j=0;j<Cantidad;j++){
    VectorTemp[j]=V_Original[Entrada][j];
  }
  }

void imprimirMatriz(float MatrizTemp[][5],byte Minimo,byte Maximo){
for (byte j=0;j<Maximo-Minimo;j++){ 
  for (byte i=0;i<5;i++) {
  Serial.print(MatrizTemp[j][i]);
  Serial.print("  ");
  }
Serial.println(" ");
}
Serial.println(" ");
}

void imprimirVector(float VectorTemp[],byte Minimo,byte Maximo){
for (byte j=0;j<Maximo-Minimo;j++){ 
  Serial.print(VectorTemp[j]);
  Serial.print("  ");
  }
Serial.println(" ");
}
