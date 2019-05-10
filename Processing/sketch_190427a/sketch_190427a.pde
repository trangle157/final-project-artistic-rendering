import processing.opengl.*;
import codeanticode.glgraphics.*;


float brushSize = 40;
float[][] colorinfo = {{.22, 1.47, .57, .05, .003, .03, .02, 5.5, .81}, 
                   {.46, 1.07, 1.5, 1.28, .38, .21, .05, 7, .4},
                   {.1, .36, 3.45, .97, .65, .007, .05, 3.4, .81},
                   {1.62, .61, 1.64, .01, .012, .003, .09, 1.0, .41},
                   {1.52, .32, .25, .06, .26, .40, .01, 1, .31},
                   {.74, 1.54, 2.1, .09, .09, .004, .09, 9.3, .9},
                   {.14, 1.08, 1.68, .77, .015, .018, .02, 1, .63},
                   {0.13, 0.81, 3.45, 0.005, 0.009, 0.007, 0.01, 1.0, 0.14},
                   {0.06, 0.21, 1.78, 0.50, 0.88, 0.009, 0.06, 1.0, 0.08},
                   {1.55, 0.47, 0.63, 0.01, 0.05, 0.035, 0.02, 1.0, 0.12},
                   {0.86, 0.86, 0.06, 0.005, 0.005, 0.09, 0.01, 3.1, 0.91},
                   {0.08, 0.11, 0.07, 1.25, 0.42, 1.43, 0.06, 1.0, 0.08}};
int colorSelection = 0;
GLTexture DF1to4A;
GLTexture DF1to4B;
GLTexturePingPong DF1to4PP;
GLTexture DF5to8A;
GLTexture DF5to8B;
GLTexturePingPong DF5to8PP;
GLTexture velocitypwfA;
GLTexture velocitypwfB;
GLTexturePingPong velocitypwfPP;
GLTexture DFblockpwsA;
GLTexture DFblockpwsB;
GLTexturePingPong DFblockpwsPP;
GLTexture canvas;
GLTexture heightboundaryA;
GLTexture heightboundaryB;
GLTexturePingPong heightboundaryPP;
GLTexture reflectanceA;
GLTexture reflectanceB;
GLTexturePingPong reflectancePP;
GLTexture dryLayer;
GLTexture[] streamCollideShaderReadTexs = new GLTexture[5];
GLTexture[] streamCollideShaderWriteTexs = new GLTexture[4];
GLTexture[] boundaryShaderReadTexs = new GLTexture[5];
GLTexture[] boundaryShaderWriteTexs = new GLTexture[2];
GLTexture[] brushShaderReadTexs = new GLTexture[4];
GLTexture[] brushShaderWriteTexs = new GLTexture[4];
GLTexture[] pigmentSecondShaderReadTexs = new GLTexture[6];
ArrayList<GLTexturePingPong> pigmentsPPs;
ArrayList<Integer> pigmentsSet;
GLTextureFilter streamCollideShader;
GLTextureFilter boundaryShader;
GLTextureFilter brushShader;
GLTextureFilter colorShader;
GLTextureFilter pigmentFirstShader;
GLTextureFilter pigmentSecondShader;
GLTextureFilter initHeight;
GLTextureFilter densityShader;
boolean dryCanvas = false;
GLTextureParameters texParams;
GLTextureParameters colorParams;
GLTextureFilter copyFilter;

void setup() {
  size(1280, 900, GLConstants.GLGRAPHICS);
  copyFilter = new GLTextureFilter(this, "copyFS.xml");
  //background(1);
  noStroke();
  pigmentsPPs = new ArrayList<GLTexturePingPong>();
  pigmentsSet = new ArrayList<Integer>();
  streamCollideShader = new GLTextureFilter(this, "streamCollideShader.xml");
  boundaryShader = new GLTextureFilter(this, "boundaryShader.xml");
  brushShader = new GLTextureFilter(this, "brushShader.xml");
  colorShader = new GLTextureFilter(this, "colorShader.xml");
  pigmentFirstShader = new GLTextureFilter(this, "pigmentFirstShader.xml");
  pigmentSecondShader = new GLTextureFilter(this, "pigmentSecondShader.xml");
  initHeight = new GLTextureFilter(this, "initheight.xml");
  densityShader = new GLTextureFilter(this, "densityShader.xml");
  texParams = new GLTextureParameters();
  texParams.minFilter = GLTexture.NEAREST_SAMPLING;
  texParams.magFilter = GLTexture.NEAREST_SAMPLING;
  texParams.format = GLTexture.FLOAT;
  colorParams = new GLTextureParameters();
  colorParams.minFilter = GLTexture.NEAREST_SAMPLING;
  colorParams.magFilter = GLTexture.NEAREST_SAMPLING;
  colorParams.format = GLTexture.COLOR;
  DF1to4A = new GLTexture(this, 1080, 900, texParams);
  DF1to4B = new GLTexture(this, 1080, 900, texParams);
  DF1to4A.setZero();
  DF1to4B.setZero();
  DF1to4PP = new GLTexturePingPong(DF1to4A, DF1to4B);
  DF5to8A = new GLTexture(this, 1080, 900, texParams);
  DF5to8B = new GLTexture(this, 1080, 900, texParams);
  DF5to8A.setZero();
  DF5to8B.setZero();
  DF5to8PP = new GLTexturePingPong(DF5to8A, DF5to8B);
  velocitypwfA = new GLTexture(this, 1080, 900, texParams);
  velocitypwfB = new GLTexture(this, 1080, 900, texParams);
  velocitypwfA.clear(0., 0., 0., 0.);
  velocitypwfB.setZero();
  velocitypwfPP = new GLTexturePingPong(velocitypwfA, velocitypwfB);
  DFblockpwsA = new GLTexture(this, 1080, 900, texParams);
  DFblockpwsB = new GLTexture(this, 1080, 900, texParams);
  DFblockpwsA.setZero();
  DFblockpwsB.setZero();
  DFblockpwsPP = new GLTexturePingPong(DFblockpwsA, DFblockpwsB);
  canvas = new GLTexture(this, "paper.png");
  heightboundaryA = new GLTexture(this, 1080, 900, texParams);
  heightboundaryB = new GLTexture(this, 1080, 900, texParams);
  heightboundaryA.setZero();
  heightboundaryB.setZero();
  heightboundaryPP = new GLTexturePingPong(heightboundaryA, heightboundaryB);
  reflectanceA = new GLTexture(this, 1080, 900, texParams);
  reflectanceB = new GLTexture(this, 1080, 900, texParams);
  reflectanceB.setZero();
  reflectancePP = new GLTexturePingPong(reflectanceA, reflectanceB);
  dryLayer = new GLTexture(this, "white.png", texParams);
  dryLayer.clear(255.0, 255.0, 255.0, 255.0);
  //dryLayer.loadPixels();
  //for (int i = 0; i < dryLayer.width * dryLayer.height; i++) dryLayer.pixels[i] = 0xffffffff;
  //dryLayer.loadTexture();
  makePalette();
  initHeight.apply(canvas, heightboundaryPP.getWriteTex());
  heightboundaryPP.swap();

}

void draw() {
  
  //rect(0,0,1080,900);
  if (mousePressed) {
    if (mouseX < 1110){
      applyBrush();
    }
  }
  
  boundaryShaderReadTexs[0] = DF1to4PP.getReadTex();
  boundaryShaderReadTexs[1] = DF5to8PP.getReadTex();
  boundaryShaderReadTexs[2] = velocitypwfPP.getReadTex();
  boundaryShaderReadTexs[3] = DFblockpwsPP.getReadTex();
  boundaryShaderReadTexs[4] = heightboundaryPP.getReadTex();
  boundaryShaderWriteTexs[0] = DFblockpwsPP.getWriteTex();
  boundaryShaderWriteTexs[1] = heightboundaryPP.getWriteTex();
  boundaryShader.apply(boundaryShaderReadTexs, boundaryShaderWriteTexs);
  DFblockpwsPP.swap();
  heightboundaryPP.swap();
  
  streamCollideShaderReadTexs[0] = DF1to4PP.getReadTex();
  streamCollideShaderReadTexs[1] = DF5to8PP.getReadTex();
  streamCollideShaderReadTexs[2] = velocitypwfPP.getReadTex();
  streamCollideShaderReadTexs[3] = DFblockpwsPP.getReadTex();
  streamCollideShaderReadTexs[4] = heightboundaryPP.getReadTex();
  streamCollideShaderWriteTexs[0] = DF1to4PP.getWriteTex();
  streamCollideShaderWriteTexs[1] = DF5to8PP.getWriteTex();
  streamCollideShaderWriteTexs[2] = velocitypwfPP.getWriteTex();
  streamCollideShaderWriteTexs[3] = DFblockpwsPP.getWriteTex();
  streamCollideShader.apply(streamCollideShaderReadTexs, streamCollideShaderWriteTexs);
  DF1to4PP.swap();
  DF5to8PP.swap();
  velocitypwfPP.swap();
  DFblockpwsPP.swap();
  
  
  
  for (int i = 0; i < pigmentsPPs.size(); i++) {
    pigmentFirstShader.apply(new GLTexture[] {pigmentsPPs.get(i).getReadTex(), velocitypwfPP.getReadTex()}, new GLTexture[] {pigmentsPPs.get(i).getWriteTex()});
    pigmentsPPs.get(i).swap();
  }
  
  
  for (int i = 0; i < pigmentsPPs.size(); i++) {
    pigmentSecondShaderReadTexs[0] = pigmentsPPs.get(i).getReadTex();
    pigmentSecondShaderReadTexs[1] = DF1to4PP.getReadTex();
    pigmentSecondShaderReadTexs[2] = DF5to8PP.getReadTex();
    pigmentSecondShaderReadTexs[3] = velocitypwfPP.getReadTex();
    pigmentSecondShaderReadTexs[4] = DFblockpwsPP.getReadTex();
    pigmentSecondShaderReadTexs[5] = heightboundaryPP.getReadTex();
    pigmentSecondShader.apply(pigmentSecondShaderReadTexs, new GLTexture[] {pigmentsPPs.get(i).getWriteTex()});
    pigmentsPPs.get(i).swap();
  }
  
  
  densityShader.apply(new GLTexture[] {velocitypwfPP.getReadTex(), DFblockpwsPP.getReadTex()}, new GLTexture[] {DFblockpwsPP.getWriteTex()});
  DFblockpwsPP.swap();
  
  if (pigmentsPPs.size() > 0) {
    float[] pigmentinfo = colorinfo[pigmentsSet.get(0)];
    colorShader.setParameterValue("K", new float[]{pigmentinfo[0], pigmentinfo[1], pigmentinfo[2]});
    colorShader.setParameterValue("S", new float[]{pigmentinfo[3], pigmentinfo[4], pigmentinfo[5]});
    colorShader.apply(new GLTexture[] {dryLayer, pigmentsPPs.get(0).getReadTex()}, new GLTexture[] {reflectancePP.getWriteTex()});
    reflectancePP.swap();
    for (int i = 1; i < pigmentsPPs.size(); i++) {
      pigmentinfo = colorinfo[pigmentsSet.get(i)];
      colorShader.setParameterValue("K", new float[]{pigmentinfo[0], pigmentinfo[1], pigmentinfo[2]});
      colorShader.setParameterValue("S", new float[]{pigmentinfo[3], pigmentinfo[4], pigmentinfo[5]});
      colorShader.apply(new GLTexture[] {reflectancePP.getReadTex(), pigmentsPPs.get(i).getReadTex()}, new GLTexture[] {reflectancePP.getWriteTex()});
      reflectancePP.swap();
    }
    if (dryCanvas) {
      reflectancePP.getReadTex().filter(copyFilter, dryLayer);
      pigmentsPPs.clear();
      pigmentsSet.clear(); 
      DF1to4PP.getReadTex().setZero();
      DF5to8PP.getReadTex().setZero();
      velocitypwfPP.getReadTex().clear(0., 0., 0., 0.);
      DFblockpwsPP.getReadTex().setZero();
    }
    image(reflectancePP.getReadTex(), 0, 0, 1080, 900);
    println("reflectance");
  }
  else {
    image(dryLayer, 0, 0, 1080, 900);
    println("drylayer");
  }
  dryCanvas = false;
  //println(mouseX + "  " + mouseY);
}

void mousePressed() {
  if (mouseX < 1110){
    applyBrush();
  }
  if(mouseX >= 1110 && mouseX <= 1250 && mouseY <= 725){
      colorSelection = (mouseY - 10) / 60;
  }
  else if(mouseX >= 1110 && mouseX <= 1250 && mouseY > 805 && mouseY < 840){
      brushSize = max(10, brushSize - 10);
  }
  else if(mouseX >= 1110 && mouseX <= 1250 && mouseY > 760 && mouseY < 790){
      brushSize = min(80, brushSize + 10);
  }
  else if(mouseX >= 1155 && mouseY > 870) {
      dryCanvas = true;
  }
} 

void applyBrush() {
    GLTexturePingPong pigmentToModify;
    if (!pigmentsSet.contains(colorSelection)) {
      //make new pigment layer
      pigmentsSet.add(colorSelection);
      pigmentToModify = new GLTexturePingPong(new GLTexture(this, 1080, 900, texParams), new GLTexture(this, 1080, 900, texParams));
      pigmentToModify.getReadTex().setZero();
      pigmentToModify.getWriteTex().setZero();
      pigmentsPPs.add(pigmentToModify);
    }
    else {
      //use existing pigment layer
      pigmentToModify = pigmentsPPs.get(pigmentsSet.indexOf(colorSelection));
    }
    brushShader.setParameterValue("brushPosition", new float[]{mouseX, mouseY});
    brushShader.setParameterValue("brushSize", brushSize);
    brushShader.setParameterValue("brushVector", new float[]{mouseX - pmouseX, mouseY - pmouseY});
    brushShaderReadTexs[0] = DF1to4PP.getReadTex();
    brushShaderReadTexs[1] = DF5to8PP.getReadTex();
    brushShaderReadTexs[2] = DFblockpwsPP.getReadTex();
    brushShaderReadTexs[3] = pigmentToModify.getReadTex();
    brushShaderWriteTexs[0] = DF1to4PP.getWriteTex();
    brushShaderWriteTexs[1] = DF5to8PP.getWriteTex();
    brushShaderWriteTexs[2] = DFblockpwsPP.getWriteTex();
    brushShaderWriteTexs[3] = pigmentToModify.getWriteTex();
    brushShader.apply(brushShaderReadTexs, brushShaderWriteTexs);
    DF1to4PP.swap();
    DF5to8PP.swap();
    DFblockpwsPP.swap();
    pigmentToModify.swap();
}

void makePalette() {
    fill(155, 34, 97);
    ellipse(1180, 40, 140, 50);
    fill(126, 58, 34);
    ellipse(1180, 100, 140, 50);
    fill(185, 133, 5);
    ellipse(1180, 160, 140, 50);
    fill(24, 90, 23);
    ellipse(1180, 220, 140, 50);
    fill(32, 133, 150);
    ellipse(1180, 280, 140, 50);
    fill(71, 26, 10);
    ellipse(1180, 340, 140, 50);
    fill(175, 55, 32);
    ellipse(1180, 400, 140, 50);
    fill(174, 69, 7);
    ellipse(1180, 460, 140, 50);
    fill(195, 162, 26);
    ellipse(1180, 520, 140, 50);
    fill(29, 108, 88);
    ellipse(1180, 580, 140, 50);
    fill(67, 67, 193);
    ellipse(1180, 640, 140, 50);
    fill(154, 124, 159);
    ellipse(1180, 700, 140, 50);
    textSize(16);
    fill(0);
    text("Increase Brush", 1125, 780);
    text("Decrease Brush", 1125, 830);
    text("DRY CANVAS", 1160, 890);
}
