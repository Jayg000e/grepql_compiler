int main()
{
    string tmp_directory;
    tmp_directory = "/tmp";


    /* Check for files in /tmp that are larger than a certain size to identify unusual space usage. */
    CHECK SELECT FROM tmp_directory WHERE SIZE GREATER THAN 1000;

    /* Save the results to a file for further inspection. */
    SAVE SELECT FROM tmp_directory WHERE SIZE GREATER THAN 1000 TO "large_tmp_files.txt";

    /* Additionally, look for any executable files in /tmp, which could be a security concern. */
    CHECK SELECT FROM tmp_directory WHERE LIKE ".*\.exe$" $ SELECT FROM tmp_directory WHERE LIKE ".*\.sh$";

    /* Save the findings of executable files. */
    SAVE SELECT FROM tmp_directory WHERE LIKE ".*\.exe$" $ SELECT FROM tmp_directory WHERE LIKE ".*\.sh$" TO "executable_tmp_files.txt";

    /* Load and display a summary of large files. */
    CHECK LOAD "large_tmp_files.txt";
    prints("Large files in /tmp:");
    print(COUNT LOAD "large_tmp_files.txt");

    /* Load and display details about executable files. */
    CHECK LOAD "executable_tmp_files.txt";
    prints("Executable files in /tmp:");
    print(COUNT LOAD "executable_tmp_files.txt");

    return 0;
}
