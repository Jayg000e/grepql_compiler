/* string list basic usage*/
void display_strings_info(strings strlist){
  prints("strings size:");
  print(size(strlist));
  prints("strings element:");
  show(strlist);
}

int main()
{ 
  string s;
  strings a;
  strings b;

  a = newStrings();
  "hello" -> a;
  "world" -> a;
  display_strings_info(a);
  
  b = newStrings();
  "good bye" -> b;
  "world" -> b; 
  display_strings_info(b);
  
  CHECK a $ b @ b;
  
  CHECK a @ b $ b;
  
  return 0;
}