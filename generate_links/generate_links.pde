// IMPORT THE ZXING4PROCESSING LIBRARY AND DECLARE A ZXING4P OBJECT
import com.cage.zxing4p3.*;
ZXING4P zxing4p;
// You need to import the PDF library to get access to the PageTize persets
import processing.pdf.*;


int start_id = 1;
//String type = "experiments";
String type = "database";

PImage  QRCode;

PrintWriter output;
String database_url = "https://128.199.174.133/database.php?mode=view&id=";
String experiments_url = "https://128.199.174.133/experiments.php?mode=view&id=";
String origin_url = "https://digitalmanufacturinglab.github.io/redirects/";

int amount = 10;
float cell_height = 27.0;
float cell_width = 30.0;
float cell_gutter = 3.0;

void settings() {
  size(mmToPix(210.0), mmToPix(297.0));
}

void setup() {
  // Create a new file in the sketch directory
  // ZXING4P ENCODE/DECODER INSTANCE
  zxing4p = new ZXING4P();
}

void draw() {
  background(255, 255, 255);

  int top = mmToPix(13);
  int left = mmToPix(7);
  int right = mmToPix(210)-mmToPix(7);
  int bottom = mmToPix(297)-mmToPix(13);

  /*
  //line(10, 150, 500, 50);
   line(left, top, right, top);
   line(left, top, left, bottom);
   line(right, top, right, bottom);
   line(left, bottom, right, bottom);
   
   //rows
   for (int i=1; i<10; i++) {
   line(left, top+(i*mmToPix(cell_height)), right, top+(i*mmToPix(cell_height)));
   }
   
   //columns end
   for (int j=1; j<6; j++) {
   line(left+(mmToPix(cell_width)*j)+(mmToPix(cell_gutter)*(j-1)), top, left+(mmToPix(cell_width)*j)+(mmToPix(cell_gutter)*(j-1)), bottom);
   }
   
   //columns start
   for (int k=1; k<6; k++) {
   line(left+(mmToPix(cell_width)*k) + (mmToPix(cell_gutter)*k), top, left+(mmToPix(cell_width)*k) + (mmToPix(cell_gutter)*k), bottom);
   }*/

  int current_id = start_id;

  for (int l=1; l<=10; l++) {
    for (int m=1; m<=6; m++) {
      int y = top+(l*mmToPix(cell_height))-(mmToPix(cell_height)/2);
      int x = left+(mmToPix(cell_width)*m) + (mmToPix(cell_gutter)*m) - (mmToPix(cell_width)/2) - 35;
      generateQRcode(current_id, x, y);
      generateHTML(current_id);
      current_id++;
    }
  }

  saveFrame("../QR_" + type + "_" + start_id + "_"+ (current_id-1) +" (print at 25%).png");
  exit();
}

int mmToPix(float input_mm) {
  float inch = input_mm / 25.4;
  int pix = round(inch * 288);
  return pix;
}

void generateQRcode(int myid, int x, int y) {
  //Generate QR code
  String qrcode_url = origin_url + type + "_" + myid + ".html";
  QRCode = zxing4p.generateQRCode(qrcode_url, mmToPix(cell_width), mmToPix(cell_width));

  PImage c = QRCode.get(9, 9, mmToPix(cell_width)-18, mmToPix(cell_width)-18);

  pushMatrix();
  imageMode(CENTER);
  translate(x, y);
  rotate(radians(270));
  image(c, 0, 0);
  textSize(36);
  fill(0, 0, 0);
  textAlign(CENTER, CENTER);
  if (type == "database") {
    text("db " + myid, 0, 150);
  } else if (type == "experiments") {
    text("exp " + myid, 0, 150);
  } 
  popMatrix();
}

void generateHTML(int myid) {
  String html_url = "";

  if (type == "database") {
    html_url = database_url + myid;
  } else if (type == "experiments") {
    html_url = experiments_url + myid;
  }

  output = createWriter("../" + type + "_" + myid + ".html");

  output.print("<!DOCTYPE html>\n");
  output.print("<html>\n<head>\n");
  output.print("<script type=\"text/javascript\">\n");
  output.print("  window.location.href = \'" + html_url + "\';");
  output.println("\n</script>\n</head>\n\n<body>\nRedirecting..\n</body>\n\n</html>"); // Write the coordinate to the file

  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}