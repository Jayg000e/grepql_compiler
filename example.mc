string s2;

int main()
{ 
  string s;
  string t;
  string st;
  s = "abc";
  s2 = s;
  t = "cba";
  st = concat(s,t);
  prints(st);
  st = concat(t,s);
  st = concat(t,st);
  prints(st);
  printbig(100);
  prints(s2);
  return 0;
}