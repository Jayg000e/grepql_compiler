
int main()
{ 
  strings a;
  string s;
  string t;
  s = ".";
  t = "2024-03-16";
  a = SELECT FROM s WHERE DATE EQUAL t;
  print(size(a));
  show(a);
  return 0;
}