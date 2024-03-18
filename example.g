
int main()
{ 
  strings a;
  string s;
  string t;
  s = ".";
  t = "^sast.*";
  a = SELECT FROM s WHERE LIKE t;
  show(a);
  t = ".*\.c$";
  a = SELECT FROM s WHERE LIKE t;
  show(a);
  return 0;
}