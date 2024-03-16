string s2;
string cat3 (string a) {
  string b;
  b = concat(a,a);
  b = concat(b,a);
  return b;
}
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
  prints(cat3(s));
  printbig(100);
  prints(s2);
  return 0;
}