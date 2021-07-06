/**
*  Projeto PCS3539 - Tecnologia de Computação Gráfica
*
*  Felipe Monjardim
*  Fernanda Parodi
*  Gabriel Duarte
*  Priscila Veras
*  Ricardo Lemos
*
*
*  Representação de Cubo Mágico
*
*  Esse projeto busca criar, apresentar e atualizar um cubo mágico de
*  acordo com a interação do usuário
**/

/**
* PeasyCam é uma biblioteca que facilita a visualização do cubo 360º/180º
**/
import peasy.*;
PeasyCam cam;

PFont    nomeEixo;
PVector  eixoDireita;
PVector  eixoEsquerda;
PVector  eixoFrente;
PVector  eixoTras;
PVector  eixoBaixo;
PVector  eixoCima;
PVector  origemEixo;

int larguraDoBotao = 150;


Botao[] botoes = new Botao[]{
  new Botao(0,0, "Mostrar Eixos"),
  new Botao(larguraDoBotao,0, "Embaralhar"),
  new Botao(larguraDoBotao*2,0, "Resolver"),
  new Botao(larguraDoBotao*3,0, "Embaralhar"),
  new Botao(larguraDoBotao*4,0, "Embaralhar"),
  new Botao(larguraDoBotao*5,0, "Reset"),
  
};

Mover moverAtual;
Mover[] movimentos = new Mover[] {
  new Mover(0, 1, 0, 1), //0 baixo horario
  new Mover(0, 1, 0, -1), //1 baixo anti-horario
  new Mover(0, -1, 0, 1), //2 cima horário
  new Mover(0, -1, 0, -1), //3 cima anti-horário
  new Mover(1, 0, 0, 1), //4 direito horário
  new Mover(1, 0, 0, -1), //5 direito anti-horário
  new Mover(-1, 0, 0, 1), //6 esquerda horário
  new Mover(-1, 0, 0, -1), //7 esquerda anti-horário
  new Mover(0, 0, 1, 1),  //8 frente horário
  new Mover(0, 0, 1, -1), //9 frente anti-horário
  new Mover(0, 0, -1, 1), //10 trás horário
  new Mover(0, 0, -1, -1) //11 trás anti-horário
};

Mover[] pilhaDesfazer;
ArrayList<Mover> sequencia = new ArrayList<Mover>();
int contador = 0;
boolean resolvendo = false;
boolean embaralhando = false;
boolean visualizarEixo = false;
/**
*  Instancia o cubo com dimensões 3*3*3
**/
Caixa[] cubo = new Caixa[3*3*3];
void setup() {
  // frameRate para que funcione em todos os computadores
  frameRate(40);
  size(900, 900, P3D);
  //Instancia a camera
  cam = new PeasyCam(this, 400);
  
  for (int i = 0; i < botoes.length; i++){
    botoes[i].setupBotao();
  }
  
  int index = 0;
  for(int x = -1; x <= 1 ; x++) {
    for(int y = -1; y <= 1; y++) {
      for(int z = -1; z <= 1; z++) {
        PMatrix3D matriz = new PMatrix3D();
        matriz.translate(x, y, z);
        // Instancia cada uma das Caixas na posição correta x, y, z de -1 a 1
        cubo[index] = new Caixa(matriz, x, y, z);
        index++;
      }
    }
  }
  
   nomeEixo = createFont( "Arial", 14 );
   eixoDireita   = new PVector();
   eixoFrente    = new PVector();
   eixoBaixo     = new PVector();
   eixoEsquerda  = new PVector();
   eixoTras      = new PVector();
   eixoCima      = new PVector();
   origemEixo    = new PVector();
  
  moverAtual = movimentos[0];  
}


/**
*  função encarregada de girar um Lado do cubo.
*  @param eixo: o eixo no qual o lado vai rotacionar
*  @param andar: -1 | 1, corresponde ao andar do cubo no eixo
*  @param dir: -1 | 1, direção na qual rotacionar
**/
void vira(char eixo, int andar, int dir) {
  for(int i = 0 ; i < cubo.length; i++) {
    // Só rotacionará as caixas presentes no andar selecionado
    if(cubo[i].x == andar && eixo == 'x') {
      PMatrix2D matriz = new PMatrix2D();
      matriz.rotate(dir*HALF_PI);
      matriz.translate(cubo[i].y, cubo[i].z);
      cubo[i].atualizar(cubo[i].x, round(matriz.m02), round(matriz.m12));
      cubo[i].viraLados('x',dir);
    } else if(cubo[i].y == andar && eixo == 'y') {
      PMatrix2D matriz = new PMatrix2D();
      matriz.rotate(dir*HALF_PI);
      matriz.translate(cubo[i].x, cubo[i].z);
      cubo[i].atualizar(round(matriz.m02), cubo[i].y, round(matriz.m12));
      cubo[i].viraLados('y',dir);
    } else if(cubo[i].z == andar && eixo == 'z') {
      PMatrix2D matriz = new PMatrix2D();
      matriz.rotate(dir*HALF_PI);
      matriz.translate(cubo[i].x, cubo[i].y);
      cubo[i].atualizar(round(matriz.m02), round(matriz.m12), cubo[i].z);
      cubo[i].viraLados('z',dir);
    }
  }
}

/**
*  resposta à interação do usuário
*  @param: key, tecla clicada pelo usuário
**/
void keyPressed() {
  switch(key) {
    // minúsculo na ordem horária
    // maiúsculo na ordem anti-horária
    case 'a': // mostra os eixos
      visualizarEixo = !visualizarEixo;
      break;
    case ' ': // resolver o cubo de forma automática
      if (sequencia.size() == 0){ break; }
      resolvendo = true;
      contador = sequencia.size()-1;
      break;
    case 'r': // aleatorizar
      contador = sequencia.size(); 
      aleatorizar(20);
      embaralhando = true;
      moverAtual = sequencia.get(contador);
      moverAtual.iniciar();
      break;
    case 'z': // remove o ultimo movimento da lista e executa o movimento (desfazer)
      if (sequencia.size() == 0){ break; }
      moverAtual = desfazerMovimento();
      moverAtual.iniciar();
      break;
    case 't': // trás
      moverAtual = movimentos[10];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer  
      moverAtual.iniciar();
      break;
    case 'T':
      moverAtual = movimentos[11];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'f': // frente
      moverAtual = movimentos[8];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'F':
      moverAtual = movimentos[9];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'b': // baixo
      moverAtual = movimentos[0];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'B':
      moverAtual = movimentos[1];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'c': // cima
      moverAtual = movimentos[2];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'C':
      moverAtual = movimentos[3];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'e': // esquerda
      moverAtual = movimentos[6];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'E':
      moverAtual = movimentos[7];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'd': // direita
      moverAtual = movimentos[4];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
    case 'D':
      moverAtual = movimentos[5];
      sequencia.add(moverAtual.copiar()); //adiciona na pilha de desfazer 
      moverAtual.iniciar();
      break;
  }
}

/**
*  desenha o cubo em toda sua glória
**/
void draw() {
  background(16, 60, 74);

  moverAtual.atualizar();
  // Lógica de resolver o cubo automaticamente
  if (moverAtual.getTerminou() && resolvendo) {
    if (contador >= 0){
      moverAtual = sequencia.remove(contador).copiar();
      moverAtual.inverter();
      moverAtual.iniciar();
      contador--;
    } else {
      resolvendo = false;
    }
  }
  // fim da resolução
  
  // Lógica de emabaralhar o cubo automaticamente
  if (moverAtual.getTerminou() && embaralhando) {
    if (contador < sequencia.size()-1){
      contador++;
      moverAtual = sequencia.get(contador);
      moverAtual.iniciar();
    } else {
      embaralhando = false;
    }
  }
  // fim da resolução
  
  if (visualizarEixo){
   calculandoEixo(200);

   cam.beginHUD();
      desenhoEixo( 2 );
   cam.endHUD();
  }
  
   cam.beginHUD();
      for (int i = 0; i < botoes.length; i++){
        botoes[i].desenharBotao();
      }
   cam.endHUD();
  
  scale(50);
  for(int i = 0; i < cubo.length; i++) {  
    push();
    if (abs(cubo[i].z) > 0 && cubo[i].z == moverAtual.z){
      rotateZ(moverAtual.angulo);
    } else if (abs(cubo[i].y) > 0 && cubo[i].y == moverAtual.y){
      rotateY(-moverAtual.angulo);
    } else if (abs(cubo[i].x) > 0 && cubo[i].x == moverAtual.x){
      rotateX(moverAtual.angulo);
    }
    cubo[i].show();
    pop();
  }
}

void aleatorizar(int nm){
  for (int i = 0; i < nm; i++){
    int a = int(random(movimentos.length));
    Mover m = movimentos[a];
    sequencia.add(m.copiar());
  }
  
  //moverAtual = sequencia.get(contador);
  
  //for (int i = sequencia.size()-1; i >= 0; i--){
  //  Mover proximoMover = sequencia.get(i).copiar();
  //  proximoMover.inverter();
  //  sequencia.add(proximoMover);
  //}
}

Mover desfazerMovimento(){
  Mover proximoMover = sequencia.remove(sequencia.size()-1).copiar();
  proximoMover.inverter();
  return proximoMover;
}


void calculandoEixo( float length ){  
   eixoDireita.set( screenX(length,0,0), screenY(length,0,0), 0 );
   eixoEsquerda.set(screenX(-length,0,0), screenY(-length,0,0), 0);
   eixoFrente.set( screenX(0,0,length), screenY(0,0,length), 0 );
   eixoTras.set(screenX(0,0,-length), screenY(0,0,-length), 0 );
   eixoBaixo.set( screenX(0,length,0), screenY(0,length,0), 0 );
   eixoCima.set(screenX(0,-length,0), screenY(0,-length,0), 0 );
   origemEixo.set( screenX(0,0,0), screenY(0,0,0), 0 );
}

void desenhoEixo( float larg ){
     pushStyle();   

     strokeWeight( larg );      

     stroke( 230,   170,   0 );     
     line( origemEixo.x, origemEixo.y, eixoDireita.x, eixoDireita.y );
 
     stroke( 255,   0,   0 );     
     line( origemEixo.x, origemEixo.y, eixoEsquerda.x, eixoEsquerda.y );
 
     stroke(   0, 255,   0 );
     line( origemEixo.x, origemEixo.y, eixoFrente.x, eixoFrente.y );
     
     stroke(   0, 0,  255 );
     line( origemEixo.x, origemEixo.y, eixoTras.x, eixoTras.y );

     stroke(   255,   255, 255 );
     line( origemEixo.x, origemEixo.y, eixoBaixo.x, eixoBaixo.y );
     
     stroke(   230, 230,   0 );
     line( origemEixo.x, origemEixo.y, eixoCima.x, eixoCima.y );


      fill(255);                   
      textFont( nomeEixo );   

      text( "D", eixoDireita.x, eixoDireita.y );
      text( "E", eixoEsquerda.x, eixoEsquerda.y );
      text( "F", eixoFrente.x, eixoFrente.y );
      text( "T", eixoTras.x, eixoTras.y );
      text( "B", eixoBaixo.x, eixoBaixo.y );
      text( "C", eixoCima.x, eixoCima.y );

   popStyle();    
}

void mousePressed(){
  if (botoes[0].rectOver) {
    visualizarEixo = !visualizarEixo;
  }
  if (botoes[1].rectOver) {
    contador = sequencia.size(); 
    aleatorizar(20);
    embaralhando = true;
    moverAtual = sequencia.get(contador);
    moverAtual.iniciar();
  }
  if(botoes[2].rectOver){
    if (sequencia.size() != 0){ 
      resolvendo = true;
      contador = sequencia.size()-1;
    }
  }
  if(botoes[3].rectOver){
  }
  if(botoes[4].rectOver){
  }
  if(botoes[5].rectOver){
  }
}
