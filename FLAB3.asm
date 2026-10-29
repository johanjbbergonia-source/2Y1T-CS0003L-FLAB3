%macro PRINT 1
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %1_end - %1
    int 80h
%endmacro

%macro WRITE 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro PRINTBUF 1
    mov ecx, %1
    xor edx, edx
%%find_end:
    cmp byte [ecx + edx], 0
    je %%write_buffer
    inc edx
    jmp %%find_end
%%write_buffer:
    mov eax, 4
    mov ebx, 1
    int 80h
%endmacro

%macro READ 3
    PRINT %1
    mov eax, 3
    mov ebx, 0
    mov ecx, %2
    mov edx, %3
    int 80h
    cmp eax, 0
    jle %%read_done
    mov edx, eax
    dec edx
    cmp byte [%2 + edx], 10
    je %%remove_newline
    cmp byte [%2 + edx], 13
    jne %%terminate
%%remove_newline:
    mov byte [%2 + edx], 0
    jmp %%read_done
%%terminate:
    mov byte [%2 + eax], 0
%%read_done:
%endmacro

%macro EXIT 0
    mov eax, 1
    xor ebx, ebx
    int 80h
%endmacro

section .data

prompt_status db "Enrollment Status: ", 0
prompt_status_end:
prompt_student db "Student #: ", 0
prompt_student_end:
prompt_college db "College: ", 0
prompt_college_end:
prompt_program db "Program: ", 0
prompt_program_end:
prompt_name db "Name: ", 0
prompt_name_end:
prompt_year db "Year Level: ", 0
prompt_year_end:
prompt_phone db "Phone: ", 0
prompt_phone_end:
prompt_zip db "Zip Code: ", 0
prompt_zip_end:
prompt_address db "Address: ", 0
prompt_address_end:
prompt_units db 10, "Enter Total No. of Units: ", 0
prompt_units_end:

title db 10, "============================================================", 10
      db "                    ENROLLMENT FORM", 10
      db "============================================================", 10, 0
title_end:

label_status db "Enrollment Status: ", 0
label_status_end:
label_student db "Student #: ", 0
label_student_end:
label_college db "College: ", 0
label_college_end:
label_program db "Program: ", 0
label_program_end:
label_name db "Name: ", 0
label_name_end:
label_year db "Year Level: ", 0
label_year_end:
label_phone db "Phone: ", 0
label_phone_end:
label_zip db "Zip Code: ", 0
label_zip_end:
label_address db "Address: ", 0
label_address_end:

course_table db 10, "+---------+---------------------------------------------+--------+------+------+------------------------------------------+----------------+", 10
              db "| COURSE  | TITLE                                       | SECTION| UNITS| DAYS | TIME                                     | ROOM           |", 10
              db "+---------+---------------------------------------------+--------+------+------+------------------------------------------+----------------+", 10
              db "| CCS0021 | INFORMATION MANAGEMENT (LEC)                | TN24   | 2    | T    | 16:00:00-18:40:00                        | ONLINE         |", 10
              db "| CCS0021L| INFORMATION MANAGEMENT (LAB)                | TN24   | 1    | F    | 16:00:00-18:50:00                        | ONLINE         |", 10
              db "| CS0001  | DISCRETE STRUCTURES 1                       | TN24   | 3    | S / W| 15:00:00-16:50:00 / 15:00:00-18:50:00    | F710 / F710    |", 10
              db "| CS0003  | COMPUTER SYSTEMS & ARCHITECTURE             | TN24   | 2    | F    | 10:00:00-12:40:00                        | ONLINE         |", 10
              db "| CS0003L | COMPUTER SYSTEMS & ARCHITECTURE (LAB)       | TN24   | 1    | TH   | 10:00:00-12:50:00                        | E610           |", 10
              db "| CS0070  | OBJECT ORIENTED PROGRAMMING                 | TN24   | 2    | F    | 07:00:00-09:40:00                        | ONLINE         |", 10
              db "| CS0070L | OBJECT ORIENTED PROGRAMMING-LAB             | TN24   | 1    | TH   | 07:00:00-09:50:00                        | E609           |", 10
              db "| GED0021 | SPECIALIZED ENGLISH PROGRAM 2               | TN24   | 3    | S / W| 11:00:00-12:50:00 / 11:00:00-12:50:00    | F607 / F607    |", 10
              db "| GED0075 | LINEAR ALGEBRA                              | TN24   | 3    | F / T| 13:00:00-14:50:00 / 13:00:00-14:50:00    | ONLINE / ONLINE|", 10
              db "| GED0081 | COLLEGE PHYSICS 1 LECTURE                   | TN24   | 2    | T    | 07:00:00-09:40:00                        | ONLINE         |", 10
              db "| GED0081L| COLLEGE PHYSICS 1 LABORATORY                | TN24   | 1    | S    | 07:00:00-09:50:00                        | F1003          |", 10
              db "+---------+---------------------------------------------+--------+------+------+------------------------------------------+----------------+", 10
              db "| TOTAL UNITS: 21                                                                                                         |                |", 10
              db "+---------+---------------------------------------------+--------+------+------+------------------------------------------+----------------+", 10, 0
course_table_end:

tuition_rate db 10, "Tuition Fee Price: Php 1000 per unit", 10, 0
tuition_rate_end:
tuition_total db "Total Tuition Fee: Php ", 0
tuition_total_end:
newline db 10, 0
newline_end:

section .bss

status resb 64
student resb 64
college resb 64
program resb 64
student_name resb 128
year_level resb 32
phone resb 64
zip_code resb 32
address resb 256
units_text resb 32
tuition_text resb 32

section .text
global _start

_start:
    READ prompt_status, status, 63
    READ prompt_student, student, 63
    READ prompt_college, college, 63
    READ prompt_program, program, 63
    READ prompt_name, student_name, 127
    READ prompt_year, year_level, 31
    READ prompt_phone, phone, 63
    READ prompt_zip, zip_code, 31
    READ prompt_address, address, 255

    PRINT title
    PRINT label_status
    PRINTBUF status
    PRINT newline
    PRINT label_student
    PRINTBUF student
    PRINT newline
    PRINT label_name
    PRINTBUF student_name
    PRINT newline
    PRINT label_college
    PRINTBUF college
    PRINT newline
    PRINT label_program
    PRINTBUF program
    PRINT newline
    PRINT label_year
    PRINTBUF year_level
    PRINT newline
    PRINT label_phone
    PRINTBUF phone
    PRINT newline
    PRINT label_zip
    PRINTBUF zip_code
    PRINT newline
    PRINT label_address
    PRINTBUF address
    PRINT newline
    PRINT course_table

    READ prompt_units, units_text, 31
    mov esi, units_text
    call ascii_to_integer
    push eax
    call compute_tuition
    mov edi, tuition_text
    call integer_to_ascii
    pop eax

    PRINT tuition_rate
    PRINT tuition_total
    PRINTBUF tuition_text
    PRINT newline
    EXIT

ascii_to_integer:
    push ebx
    push ecx
    push edx
    xor eax, eax
    xor ecx, ecx
.convert_loop:
    mov bl, [esi + ecx]
    cmp bl, 0
    je .convert_done
    imul eax, 10
    sub bl, '0'
    movzx edx, bl
    add eax, edx
    inc ecx
    jmp .convert_loop
.convert_done:
    pop edx
    pop ecx
    pop ebx
    ret

compute_tuition:
    imul eax, 1000
    ret

integer_to_ascii:
    push ebx
    push ecx
    push edx
    cmp eax, 0
    jne .build_number
    mov byte [edi], '0'
    mov byte [edi + 1], 0
    jmp .ascii_done
.build_number:
    mov ebx, 10
    xor ecx, ecx
.divide_loop:
    xor edx, edx
    div ebx
    push edx
    inc ecx
    cmp eax, 0
    jne .divide_loop
.write_loop:
    pop eax
    add al, '0'
    mov [edi], al
    inc edi
    loop .write_loop
    mov byte [edi], 0
.ascii_done:
    pop edx
    pop ecx
    pop ebx
    ret
