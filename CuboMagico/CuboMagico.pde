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

/**
*  Instancia o cubo com dimensões 3*3*3
**/
Caixa[] cubo = new Caixa[3*3*3];
void setup() {
  // frameRate para que funcione em todos os computadores
  frameRate(40);
  size(600, 600, P3D);
  //Instancia a camera
  cam = new PeasyCam(this, 400);
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
    case 't': // trás
      vira('z', -1, -1);
      break;
    case 'T':
      vira('z', -1, 1);
      break;
    case 'f': // frente
      vira('z', 1, 1);
      break;
    case 'F':
      vira('z', 1, -1);
      break;
    case 'b': // baixo
      vira('y', 1, -1);
      break;
    case 'B':
      vira('y', 1, 1);
      break;
    case 'c': // cima
      vira('y', -1, 1);
      break;
    case 'C':
      vira('y', -1, -1);
      break;
    case 'e': // esquerda
      vira('x', -1, -1);
      break;
    case 'E':
      vira('x', -1, 1);
      break;
    case 'd': // direita
      vira('x', 1, 1);
      break;
    case 'D':
      vira('x', 1, -1);
      break;
  }
}

/**
*  desenha o cubo em toda sua glória
**/
void draw() {
  background(16, 60, 74);
  scale(50);
  for(int i = 0; i < cubo.length; i++) {  
    cubo[i].show();
  }
}
