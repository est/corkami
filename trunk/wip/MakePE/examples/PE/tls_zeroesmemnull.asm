; empty entry point file, looks buggy as much as possible
; but TLS is allocating memory at offset 0, so ADD EAX, [AL] will be valid

; on Win7, eax is not null so the TLS adds

%include '../../onesec.hdr'

stub:
    push MB_ICONINFORMATION     ; UINT uType
    push aEntryPoint            ; LPCTSTR lpCaption
    push helloworld             ; LPCTSTR lpText
    push 0                      ; HWND hWnd
    call MessageBoxA
    push 0                      ; UINT uExitCode
    call ExitProcess
_c

;%IMPORT user32.dll!MessageBoxA
;%IMPORT kernel32.dll!ExitProcess
_c
aEntryPoint db "Entry Point", 0
helloworld db "Hello World!", 0
_d

MEM_RESERVE               equ 2000h
MEM_TOP_DOWN              equ 100000h

TLS:
    pushad
    push PAGE_READWRITE     ; ULONG Protect
    push MEM_RESERVE|MEM_COMMIT|MEM_TOP_DOWN     ; ULONG AllocationType
    push zwsize             ; PSIZE_T RegionSize
    push 0                  ; ULONG_PTR ZeroBits
    push lpBuffer3          ; PVOID *BaseAddress
    push -1                 ; HANDLE ProcessHandle
    call ZwAllocateVirtualMemory
_
    mov eax, [zwsize]
    mov byte [eax - 6], 068h
    mov dword [eax - 5], stub
    mov byte [eax - 1], 0c3h
_
    mov eax, [fs:18h]
    mov ecx, [eax + 030h]
    xor eax, eax
    or eax, [ecx + 0a8h]
    shl eax,8
    or eax, [ecx + 0a4h]
    cmp eax, 0106h               ; Win7 ?
    jz W7
_
    popad
    retn
W7:
    mov word [EntryPoint], 0c033h
    popad
    retn
_c

;%IMPORT ntdll.dll!ZwAllocateVirtualMemory
_c

lpBuffer3 dd 1
zwsize dd 1000h
Image_Tls_Directory32:
    StartAddressOfRawData dd Characteristics
    EndAddressOfRawData   dd Characteristics
    AddressOfIndex        dd Characteristics
    AddressOfCallBacks    dd SizeOfZeroFill
    SizeOfZeroFill        dd TLS
    Characteristics       dd 0
_d

;Can't be in headers
;%IMPORTS
_d

EntryPoint:
    times 20h add [eax], al
    jmp eax
_c

SECTION0SIZE equ $ - Section0Start
SIZEOFIMAGE equ $ - IMAGEBASE

; Ange Albertini, Creative Commons BY, 2010