int main()
{ 
  SAVE GREP "string_of" FROM "." TO "result.txt";
  CHECK LOAD "result.txt";
  return 0;
}