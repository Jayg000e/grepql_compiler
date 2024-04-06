int main()
{ 
  string s;
  strings a;

  a = newStrings();
  append(a,"hello");
  append(a,"world");

  CHECK a;
  return 0;
}