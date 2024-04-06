int main()
{ 
  SAVE GREP "string_of" FROM "." TO "result.txt";
  CHECK LOAD "result.txt";
  print(COUNT LOAD "result.txt");
  return 0;
}