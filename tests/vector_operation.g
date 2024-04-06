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
  strings c;

  a = newStrings();
  append(a,"hello");
  append(a,"world");
  display_strings_info(a);
  
  b = newStrings();
  append(b,"good bye");
  append(b,"world");
  display_strings_info(b);
  
  c = a $ b;
  display_strings_info(c);

  c = a @ b;
  display_strings_info(c);
  
  return 0;
}