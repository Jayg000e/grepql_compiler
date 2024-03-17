; ModuleID = 'MicroC'
source_filename = "MicroC"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.1 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@tmp = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@tmp.3 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@tmp.4 = private unnamed_addr constant [8 x i8] c"goodbye\00", align 1
@tmp.5 = private unnamed_addr constant [6 x i8] c"world\00", align 1
@fmt.6 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.7 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.8 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@tmp.9 = private unnamed_addr constant [14 x i8] c"strings size:\00", align 1
@tmp.10 = private unnamed_addr constant [17 x i8] c"strings element:\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @printbig(i32)

declare i8* @concat(i8*, i8*)

declare { i8**, i32, i32 }* @newStrings()

declare i32 @append({ i8**, i32, i32 }*, i8*)

declare i32 @size({ i8**, i32, i32 }*)

declare i32 @show({ i8**, i32, i32 }*)

declare { i8**, i32, i32 }* @query(i8*)

define i32 @main() {
entry:
  %s = alloca i8*
  %a = alloca { i8**, i32, i32 }*
  %newStrings = call { i8**, i32, i32 }* @newStrings()
  store { i8**, i32, i32 }* %newStrings, { i8**, i32, i32 }** %a
  %a1 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %append = call i32 @append({ i8**, i32, i32 }* %a1, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @tmp, i32 0, i32 0))
  %a2 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %append3 = call i32 @append({ i8**, i32, i32 }* %a2, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @tmp.3, i32 0, i32 0))
  %a4 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  call void @display_strings_info({ i8**, i32, i32 }* %a4)
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @tmp.4, i32 0, i32 0), i8** %s
  %s5 = load i8*, i8** %s
  %a6 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %append7 = call i32 @append({ i8**, i32, i32 }* %a6, i8* %s5)
  %a8 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  call void @display_strings_info({ i8**, i32, i32 }* %a8)
  store i8* getelementptr inbounds ([6 x i8], [6 x i8]* @tmp.5, i32 0, i32 0), i8** %s
  %s9 = load i8*, i8** %s
  %a10 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %append11 = call i32 @append({ i8**, i32, i32 }* %a10, i8* %s9)
  %a12 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  call void @display_strings_info({ i8**, i32, i32 }* %a12)
  ret i32 0
}

define void @display_strings_info({ i8**, i32, i32 }* %strlist) {
entry:
  %strlist1 = alloca { i8**, i32, i32 }*
  store { i8**, i32, i32 }* %strlist, { i8**, i32, i32 }** %strlist1
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.8, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @tmp.9, i32 0, i32 0))
  %strlist2 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %strlist1
  %size = call i32 @size({ i8**, i32, i32 }* %strlist2)
  %printf3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.6, i32 0, i32 0), i32 %size)
  %printf4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt.8, i32 0, i32 0), i8* getelementptr inbounds ([17 x i8], [17 x i8]* @tmp.10, i32 0, i32 0))
  %strlist5 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %strlist1
  %show = call i32 @show({ i8**, i32, i32 }* %strlist5)
  ret void
}
