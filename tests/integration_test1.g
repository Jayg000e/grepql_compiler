/* Function to collect logs based on a file path and keyword. */
void collectLogs(string log_file, string keyword, string output_file)
{
    CHECK GREP keyword FROM log_file;
    SAVE GREP keyword FROM log_file TO output_file;
}

/* Function to print the log summary from a file. */
void printLogs(string output_file, string log_description)
{
    CHECK LOAD output_file;
    prints(log_description);
    print(COUNT LOAD output_file);
}

int main()
{
    /* Define the list of log files to check. */
    string syslog_file;
    string kernlog_file;

    syslog_file = "/var/log/syslog";
    kernlog_file = "/var/log/kern.log";

    /* Collect logs for each type. */
    collectLogs(syslog_file, "error|warning", "syslog_errors_warnings.txt");
    collectLogs(kernlog_file, "fail|critical", "kernlog_issues.txt");

    /* Print summaries for each log type. */
    printLogs("syslog_errors_warnings.txt", "Syslog Errors and Warnings:");
    printLogs("kernlog_issues.txt", "Kernel Log Issues:");

    return 0;
}
