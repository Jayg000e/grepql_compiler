int main()
{ 
  strings a;
  INIT a;
  "hello" -> a;
  "world" -> a;
  CHECK a;
  print(size(a));
  return 0;
}