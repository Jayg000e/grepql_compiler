; ModuleID = 'MicroC'
source_filename = "MicroC"

@fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@fmt.1 = private unnamed_addr constant [4 x i8] c"%g\0A\00", align 1
@fmt.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@tmp = private unnamed_addr constant [7 x i8] c"asdasd\00", align 1
@tmp.3 = private unnamed_addr constant [44 x i8] c"/home/jayg/Documents/cs4115/grepql_compiler\00", align 1
@tmp.4 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@tmp.5 = private unnamed_addr constant [8 x i8] c"nononon\00", align 1

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
  %x = alloca i32
  %s = alloca i8*
  %a = alloca { i8**, i32, i32 }*
  store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @tmp, i32 0, i32 0), i8** %s
  %newStrings = call { i8**, i32, i32 }* @newStrings()
  store { i8**, i32, i32 }* %newStrings, { i8**, i32, i32 }** %a
  store i8* getelementptr inbounds ([44 x i8], [44 x i8]* @tmp.3, i32 0, i32 0), i8** %s
  %a1 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %append = call i32 @append({ i8**, i32, i32 }* %a1, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @tmp.4, i32 0, i32 0))
  %a2 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %append3 = call i32 @append({ i8**, i32, i32 }* %a2, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @tmp.5, i32 0, i32 0))
  %a4 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %show = call i32 @show({ i8**, i32, i32 }* %a4)
  %a5 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %size = call i32 @size({ i8**, i32, i32 }* %a5)
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %size)
  %s6 = load i8*, i8** %s
  %query = call { i8**, i32, i32 }* @query(i8* %s6)
  store { i8**, i32, i32 }* %query, { i8**, i32, i32 }** %a
  %a7 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %size8 = call i32 @size({ i8**, i32, i32 }* %a7)
  %printf9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @fmt, i32 0, i32 0), i32 %size8)
  %a10 = load { i8**, i32, i32 }*, { i8**, i32, i32 }** %a
  %show11 = call i32 @show({ i8**, i32, i32 }* %a10)
  ret i32 0
}
