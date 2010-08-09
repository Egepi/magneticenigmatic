void debugCode()
{
  // Memory Check
  int debugX = 0;
  int debugY = 0;
  int fontSize = 16;
  stroke(0);
  fill(100,100,100,200);
  rect(debugX, debugY, Runtime.getRuntime().maxMemory()/3000000 + fontSize*2, 150);
  fill(255);
  textFont(loadFont("Courier-Bold-48.vlw"),fontSize);
  text("Resolution: "+screen.width+" , "+screen.height, debugX + fontSize, debugY + fontSize*1);  
  //text("MousePos: "+mouseX+" , "+mouseY, debugX + fontSize, debugY + fontSize*2);
  //text("# touches: "+nTouches, debugX + fontSize, debugY + fontSize*2);
  text("FPS: "+frameRate, debugX + fontSize, debugY + fontSize*3);

  fill(0,255,255);
  text("Total Allocated: "+Runtime.getRuntime().totalMemory()/1000/1000 + " (MB)", debugX + fontSize, debugY + fontSize*4);
  rect(debugX + fontSize, debugY + fontSize*4, Runtime.getRuntime().totalMemory()/3000000, 10);
  fill(255,255,0);
  text("Total Free: "+Runtime.getRuntime().freeMemory()/1000/1000 + " (MB)", debugX + fontSize, debugY + fontSize*6);
  rect(debugX + fontSize, debugY + fontSize*6, Runtime.getRuntime().freeMemory()/3000000, 10);
  fill(0,255,0);
  text("Max Memory: "+Runtime.getRuntime().maxMemory()/1000/1000 + " (MB)", debugX + fontSize, debugY + fontSize*8);
  rect(debugX + fontSize, debugY + fontSize*8, Runtime.getRuntime().maxMemory()/3000000, 10);
}

