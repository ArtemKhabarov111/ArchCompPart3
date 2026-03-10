.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

.global bootload
.section .rodata
image: .incbin "kernel.bin"
end_of_image:
str_boot_start: .asciz "bootloader started"
str_boot_end: .asciz "bootloader end"
str_boot_indicate: .asciz "#"

.section .text
bootload:
	ldr r0, =str_boot_start		// Load address of 'str_boot_start' into r0
	bl dbgput_line			// Print "bootloader started" in console
	ldr r0, =end_of_image		// End address of kernel image in Flash
	ldr r1, =image			// Start address of kernel image in Flash
	ldr r2, =_ram_start		// Load address of '_ram_start' into r2

	sub r3, r0, r1			// r3 = r0 - r1. Kernel image size in bytes
	add r1, r1, r3			// r1 = r1 + r3. Last byte in image
	add r2, r2, r3			// r2 = r2 + r3. Last byte in RAM
	
loop:
	ldmdb r1!, {r4, r5}		// Load multiple registers, decrement before. Write r1 address back into Rn
	stmdb r2!, {r4, r5}		// Store multiple registers, decrement before. Write r2 address back into Rn

	subs r3, r3, #8			// r3 = r3 - 8. Update condition code flags
	bgt loop			// if r3 > 0 -> loop

	bl newline			// Print newline
	ldr r0, =str_boot_end		// Load address of 'str_boot_end' into r0
	bl dbgput_line			// Print "bootloader end" in console

	ldr lr, =bootload_end		// Load address of 'bootload_end' into lr
	add lr, #1			// lr = lr + 1

	ldr r2, =_ram_start		// Load address of '_ram_start' into r2
	add r2, #4			// r2 = r2 + 4

	ldr r0, [r2]
	bx r0

bootload_end:
	b bootload_end
