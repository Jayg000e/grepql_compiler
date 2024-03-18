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

  a = newStrings();
  append(a,"hello");
  append(a,"world");
  display_strings_info(a);
  
  s = "goodbye";
  
  append(a,s);
  display_strings_info(a);
  
  s = "world";
  append(a,s);
  display_strings_info(a);
  
  return 0;
}