.global lab1
.syntax unified

#define A 10
#define B 12
#define C 3

lab1:
	push {lr}
	mov r0, #A		// r0 = A
	mov r1, #B		// r1 = B
	mov r2, #C		// r2 = C
	
	and r3, r0, r1		// r3 = A & B
	lsr r4, r3, #1		// r4 = r3 >> 1 | Logical Shift Right by 1
	
	mov r5, #1		// Factorial result
	mov r6, r2		// r6 = C (counter)

factorial_loop:
	cmp r6, #1		// Compare r6 to 1
	ble result		// If r6 <= 1 then branch to loop result
	mul r5, r5, r6		// r5 = r5 * r6
	sub r6, r6, #1		// r6 = r6 - 1
	b factorial_loop	// Branch to loop factorial_loop

result:
	add r7, r4, r5		// r7 = (a & b) >> 1 + C!
	pop {pc}
