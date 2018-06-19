import processing.serial.*;

int Width = 800;
int Height = 480;
float [] Distances={20,30,40,50,60};
float [] BoardLengths={20,30,40};
Board firstBoard = new Board(Width/2-BoardLengths[0]/2,Height/2,BoardLengths[0]);
Board secondBoard = new Board(Width/2+firstBoard.board_length+Distances[0],Height/2,BoardLengths[1]);
Map map = new Map(firstBoard,secondBoard);
Ball ball = new Ball(Width/2,Height/2);
Engine engine = new Engine(map,ball);
Serial myPort;

void setup(){
  size(800, 480);  
  background(255); 
  engine.start();
  myPort = new Serial(this, "/dev/cu.usbmodem14111", 9600);
}

void draw(){
  
  background(255);  
  engine.display();
  
  if(myPort.available()>0){  
    if(engine.score!=-1){
       ball.rotateR = myPort.read(); 
       println(ball.rotateR);
       ball.rotateX = ball.x + ball.rotateR;
       ball.rotateY = ball.y;
       engine.next();
    }
  }
}


class Engine{
  
  int score = -1;
  Map map;
  Ball ball;
  
  Engine(Map m,Ball b){
    map = m;
    ball = b;
  }
  
  void start(){ 
    if(score!=-1) return;  
    score = 0;
     
  }
  
  void next(){
    //
    if(ball.x + ball.rotateR*2>=map.next.x&&ball.x + ball.rotateR*2<=map.next.x+map.next.board_length){
      score++;
      map.addBoard(new Board(Width/2+firstBoard.board_length+Distances[(int)random(5)],Height/2,BoardLengths[(int)random(3)]));
      return ;
    }
    
    end();
      
  }
 
  void end(){  
    println(score);
    score = -1;
  }
  
  void display(){
      map.display();     
      ball.display();
      if(score!=-1){
        map.moveLeftWithBall(ball);
      } 
      ball.rotateRight();    
  }
  
}

class Map{
  
  Board current;
  
  Board next;
  
  Map(Board b,Board n){
    current = b;
    next = n;
    
  }
  
  void moveLeftWithBall(Ball b){
    if(b.rotateR==0&&current.x+current.board_length/2>width/2){
      b.x-=1;
      Board helpBoard = current;
        while(helpBoard!=null){
          helpBoard.x-=1;
          helpBoard = helpBoard.pre;
        } 
        
    } 
  }
  
  void display(){
    Board helpBoard = current;
    while(helpBoard!=null){
      helpBoard.display();
      helpBoard = helpBoard.pre;
    }   
    
    if(current.x<=width/2){
      next.display();
    }
  }
  
  void addBoard(Board b){
    next.pre = current;
    current = next;
    next = b;
  }
  
}

class Board{
  float x,y;
  float board_length;
  Board pre;
  Board(float x0,float y0,float l){
    x = x0;
    y = y0;
    board_length = l;
  }
  
  void display(){
    strokeWeight(5);
    line(x,y,x+board_length,y);
  }
}

class Ball{
  float x,y;
  float rotateX,rotateY,rotateR=0;
  float angle=180.0;
  
  Ball(float x0,float y0){
    x = x0;
    y = y0-8; 
  }
 
  void rotateRight(){
    if(rotateR!=0){
        angle+=10.0;
        x = rotateX+rotateR*cos(radians(angle));
        y = rotateY+rotateR*sin(radians(angle));
        if(angle==360){
            rotateR=0;
            rotateY=0;
            rotateX=0;
            angle=180.0;
          
        }
    }
  }
  
  void display(){
    strokeWeight(10);
    point(x,y);
  }
  
}
