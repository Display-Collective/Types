Lake lake;

PImage src;
float scalar = 1.0;

void setup() {
  src = loadImage("image.png");
  size( (int)(src.width*scalar),
        (int)(src.height*scalar),
        OPENGL
  );
  
  
  frameRate(30);

  src.resize(width, height);
  lake = new Lake(src, 1.0, 1.0, 10);

}


void draw() {

  image(lake.output(), 0, 0);
  lake.update();

}
