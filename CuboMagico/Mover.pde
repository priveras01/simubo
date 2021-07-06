class Mover { 
 float angulo = 0;
 int x = 0;
 int y = 0;
 int z = 0;
 int dir;
 boolean movendo = false;
 boolean terminou = false;
 float velocidade = 0.5;
 
 Mover(int x, int y, int z, int dir) {
  this.x = x;
  this.y = y;
  this.z = z;
  this.dir = dir;
 }
 
 Mover copiar(){
   return new Mover(x, y, z, dir);
 }
 
 void inverter(){
   dir *= -1;
 }
 
 void iniciar(){
   movendo = true;
   terminou = false;
   this.angulo = 0;
 }
 
 boolean getTerminou(){
   return this.terminou;
 }
 
 void atualizar(){
   if (movendo){
     angulo += dir * velocidade;
     if (abs(angulo) > HALF_PI){
       angulo = 0;
       movendo = false;
       terminou = true;
       
       if(abs(z) > 0) {
         vira('z', this.z, this.dir);  
       } else if(abs(y) > 0) {
         vira('y', this.y, this.dir);  
       } else if(abs(x) > 0) {
         vira('x', this.x, this.dir);  
       }
     }
   }
 }
}
