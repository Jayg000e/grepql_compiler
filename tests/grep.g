
int main()
{ 
  strings a;
  string s;
  string t;
  s = ".";
  t = "string_of";
  a = GREP t FROM s;
  print(size(a));
  show(a);
  return 0;
}