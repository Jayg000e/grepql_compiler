
int main()
{ 
  strings a;
  string s;
  string t;
  s = ".";
  t = "2024-03-16";
  CHECK SELECT FROM s WHERE DATE GREATER THAN t;
  return 0;
}