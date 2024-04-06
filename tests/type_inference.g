/* the grepql compiler will perform type inference and correct this automatically*/ 
/* the following can be successfully compiled */ 
strings add(int x, int y) {
  return x + y;
}
int main()
{ 
  int x;
  int y;
  x = 1;
  y = 2;
  print(x + y);
  return 0;
}