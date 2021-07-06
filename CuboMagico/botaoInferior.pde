class BotaoInferior {
  int rectX, rectY;      // Position of square button
  int rectSizeX = 50;     // Diameter of rect
  int rectSizeY = 50;
  
  color rectColor, baseColor, currentColor;
  color rectHighlight;
  
  boolean rectOver = false;
  
  String texto;
  
  BotaoInferior(int rectX, int rectY, String texto){
    this.rectX = rectX;
    this.rectY = rectY;
    this.texto = texto;
    // this.rectSizeX = this.texto.length()*30;
  }
  
  void setupBotao() {
    rectColor = color(200,200,200,150);
    rectHighlight = color(200,200,200,80);
  }
  
  void atualizarBotao() {
    if ( overRect(rectX, rectY, rectSizeX, rectSizeY) ) {
      rectOver = true;
    } else {
      rectOver = false;
    }
  }
  
  boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
  void desenharBotao() {
    atualizarBotao();
    
    if (rectOver) {
      fill(rectHighlight);
    } else {
      fill(rectColor);
    }
    //stroke(255);
    rect(rectX, rectY, rectSizeX, rectSizeY);
    
    textSize(20);
    fill(0, 0, 0);
    text(this.texto, this.rectX+10, this.rectY+this.rectSizeY/2+10); 
  }
}
