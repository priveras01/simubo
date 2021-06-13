/**
*  Instanciação de cada lado da Caixa
**/

class Lado {
    PVector normal;
    color c;
    
    Lado(PVector normal, color c) {
      this.normal = normal;
      this.c = c;
    }
    
    /**
    *  rotaciona o lado de acordo com a Caixa
    *  @param eixo: corresponde ao eixo no qual o Lado será rotacionado
    *  @param angulo: o ângulo da rotação
    **/
    void vira(char eixo, float angulo) {
      // v2 será a normal do Lado depois da rotação
      PVector v2 = new PVector();
      
      // Para rotacionar uma caixa, é utilizada a matriz de rotação
      // Exemplo no eixo z
      //   |  cos(t) sen(t)    0   |
      //   | -sen(t) cos(t)    0   |
      //   |    0      0       1   |
      
      switch (eixo) {
        case 'x':
          v2.y = round(normal.y * cos(angulo) - normal.z * sin(angulo));
          v2.z = round(normal.y * sin(angulo) + normal.z * cos(angulo));
          v2.x = round(normal.x);
        break;
        case 'y':
          v2.x = round(normal.x * cos(angulo) - normal.z * sin(angulo));
          v2.z = round(normal.x * sin(angulo) + normal.z * cos(angulo));
          v2.y = round(normal.y);
        break;
        case 'z':
          v2.x = round(normal.x * cos(angulo) - normal.y * sin(angulo));
          v2.y = round(normal.x * sin(angulo) + normal.y * cos(angulo));
          v2.z = round(normal.z);
        break;
      }
      normal = v2;
    }
    
    /**
    *  apresenta graficamente o Lado
    **/
    void show() {
      pushMatrix();
      fill(c);
      stroke(0);
      strokeWeight(0.1);
      rectMode(CENTER);
      translate(normal.x*0.5, normal.y*0.5, normal.z*0.5);
      // Para ver em qual direção vamos rodar o Lado antes de preencher
      // se abs(normal.z)>0, não é necessária a rotação
      if(abs(normal.x) > 0) {
        rotateY(HALF_PI);
      } else if (abs(normal.y) > 0) {
        rotateX(HALF_PI);
      }
      square(0, 0, 1);
      popMatrix();
    }
}
