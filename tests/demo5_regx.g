
int main()
{ 
  string s;
  string t;
  s = ".";
  t = "^sast.*";
  CHECK SELECT FROM s WHERE LIKE t;
  t = ".*\.c$";
  CHECK SELECT FROM s WHERE LIKE t;
  return 0;
}