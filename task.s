.include "defs.h"

.section .bss # =0
fd:  .quad 0
length: .quad 0
ptr: .quad 0

.section .text 

.global _start 

_start:
	cmpq $2, (%rsp)		#compare 2 to amount of parametrs
	movq $1, %rdi		#set exit code 1
	jne exit		#if amount of parametrs < 2 goto exit

	movq $SYS_OPEN, %rax	#set syscall to sys_open
	movq 16(%rsp), %rdi	#rdi = filename	
	movq $O_RDONLY, %rsi	#rsi (flags) = readonly 
	xor  %rdx, %rdx		#rsi (mode) = 0
	syscall			#open file return to rax
	movq %rax, fd		#saving rsx in fd variable

	movq $SYS_LSEEK, %rax	#set syscall to sys_lseek
	movq fd, %rdi		#fd = fd
	xor  %rsi, %rsi		#rsi (offset) = 0
	movq $SEEK_END, %rdx	#origin = SEEK_END
	syscall			
	movq %rax, length	#len = length of file
	
	movq $SYS_MMAP, %rax	#set syscall to sys_mmap to map file into memory
	xor  %rdi, %rdi		#rdi (addr) = 0
	movq length, %rsi	#rsi (len) = length
	movq $PROT_READ, %rdx	#rdx (prot) = prot_read
	movq $MAP_SHARED, %r10	#r10 (flags) = map_shared
	movq fd, %r8		#r8 (fd) = fd
	xor  %r9, %r9		#r9 (off) = 0
	syscall
	movq %rax, ptr		#pointer = rax
	
	movq $SYS_WRITE, %rax	#set syscall to sys_write
	movq $STDOUT, %rdi	#rdi (fd) = stdout
	movq ptr, %rsi		#rsi (buf) = pointer
	movq length, %rdx	#rdx (count) = length
	syscall

	movq $SYS_MUNMAP, %rax	#set syscall to sys_unmap to unmap file
	movq ptr, %rdi		#rdi (addr) = ptr
	movq length, %rsi	#rsi (len) = length
	syscall

	movq $SYS_CLOSE, %rax	#set syscall to sys_close  
	movq fd, %rdx		#rdx (fd) = fd
	syscall

	xor  %rdi, %rdi		#rdi (exitcode) = 0
exit:
	movq $SYS_EXIT, %rax	#set syscall to exit
	syscall
