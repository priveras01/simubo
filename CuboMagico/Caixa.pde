/**
* Instanciação de Caixa. A Caixa representa um dos 27 cubos do cubo mágico
* Cada Caixa tem 6 Lados, mesmo que nem todos apareçam
**/

class Caixa {
  PMatrix3D matriz;
  int x = 0;
  int y = 0;
  int z = 0;
  // Cada Caixa tem 6 Lados
  Lado[] lados = new Lado[6];
  Caixa(PMatrix3D m, int x, int y, int z) {
    matriz = m;
    this.x = x;
    this.y = y;
    this.z = z;
    // Definindo a cor de cada Lado da caixa
    lados[0] = new Lado(new PVector(0, 0, -1), color(0, 0, 200));
    lados[1] = new Lado(new PVector(0, 0, 1), color(0, 200, 0));
    lados[2] = new Lado(new PVector(0, 1, 0), color(255, 255, 255));
    lados[3] = new Lado(new PVector(0, -1, 0), color(230, 230, 0));
    lados[4] = new Lado(new PVector(1, 0, 0), color(230, 170, 0));
    lados[5] = new Lado(new PVector(-1, 0, 0), color(200, 0, 0));
  }
  
  
  /**
  * rotaciona cada um dos Lados
  **/
  void viraLados(char eixo, int dir) {
    for (Lado l : lados) {
      l.vira(eixo, HALF_PI*dir);
    }
  }
  
  /**
  * atualiza as variáveis de posição da Caixa
  **/
  void atualizar(int x, int y, int z) {
    matriz.reset();
    matriz.translate(x, y, z);
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  /**
  *  apresenta graficamente a Caixa
  **/
  void show() {
    pushMatrix();
    applyMatrix(matriz);
    for (Lado l: lados) {
      l.show();
    }
    popMatrix();
  }
}
