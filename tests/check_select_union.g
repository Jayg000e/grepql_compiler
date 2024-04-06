
int main()
{ 
  strings a;
  string s;
  string t;
  s = ".";
  t = "2024-03-16";
  CHECK SELECT FROM s WHERE DATE GREATER THAN t @ SELECT FROM s WHERE SIZE GREATER THAN 10000 @ SELECT FROM s WHERE SIZE LESS THAN 50000;
  return 0;
}