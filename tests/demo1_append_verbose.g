int main()
{ 
  strings a;
  a = newStrings();
  append(a, "hello");
  append(a, "world");
  show(a);
  print(size(a));
  return 0;
}