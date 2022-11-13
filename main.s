	.intel_syntax noprefix # ustanavlivaem sintaksis
	.text # sekciya s tekstom
	.globl	size
	.bss # vydelenie pamyati
	.align 4 # vyravnivanie steka
	.type	size, @object # ustanovlenie tipa
	.size	size, 4	# i razmera
size:
	.zero	4 # zapolnnenie nulyami
	.text
	.globl	read
	.type	read, @function
read:
        push    rbp # standartnoe nachalo
        mov     rbp, rsp
        sub     rsp, 32 # vydelenie steka
        mov     r12, rdi  # kladem r12 v argument funkcii
        mov     r13d, 0	# r13d aka i = 0
.L2:
        mov     rax, QWORD PTR stdin[rip]
        mov     rdi, rax # kladem rax = stdin v argument funkcii
        call    fgetc@PLT # vyzyvaem funkciyu
        mov     DWORD PTR -8[rbp], eax # ch = rezul'tat funkcii
        mov     eax, r13d
        lea     edx, 1[rax]
        mov     r13d, edx
        movsx   rdx, eax
        mov     rax, r12
        add     rax, rdx # berem str[i++]
        mov     edx, DWORD PTR -8[rbp]
        mov     BYTE PTR [rax], dl
        mov     eax, DWORD PTR size[rip]
        add     eax, 1 # delaem size++
        mov     DWORD PTR size[rip], eax
        cmp     DWORD PTR -8[rbp], -1 # sravnivaem ch i -1
        jne     .L2 # esli ne ravny idem zanovo
        mov     eax, r13d
        cdqe
        lea     rdx, -1[rax]
        mov     rax, r12
        add     rax, rdx # str[i - 1]
        mov     BYTE PTR [rax], 0
        leave
	ret # vyhod
	.size	read, .-read
	.globl	brackets
	.type	brackets, @function
brackets:
	push	rbp # standartnoe
	mov	rbp, rsp
	mov	QWORD PTR -24[rbp], rdi # poluchaem stroku
	mov	r12d, 0 # r12d aka checker = 0
	mov	r13d, 0 # i = 0
	jmp	.L4
.L9:
	mov	eax, r13d
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx # poluchaem string[i]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 40 # sravnivaem s "("
	jne	.L5 # esli ne ravny idem dalshe
	add	r12d, 1 # checker++
.L5:
	mov	eax, r13d
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx # opyat' poluchaem string[i]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 41 # sravnivaem s ")"
	jne	.L6 # esli ne ravny uhodim
	sub	r12d, 1 # checker--
.L6:
	cmp	r12d, 0 # sravnivaem checker s nulem
	jns	.L7 # esli checker >= 0 uhodim
	mov	eax, 1 # vyvodim 1
	jmp	.L8
.L7:
	add	r13d, 1 # i++
.L4:
	mov	eax, DWORD PTR size[rip]
	cmp	r13d, eax # sravnivaem v uslovii cikla i and size
	jl	.L9 # esli i < size idem v cikl
	cmp	r12d, 0 # sravnivaem checker s 0
	jne	.L10 # uhodim esli oni ne ravny
	mov	eax, 0 # vyvodim nol'
	jmp	.L8
.L10:
	mov	eax, 1 # vyvodim odin
.L8:
	pop	rbp # udalyaem pointer
	ret
	.size	brackets, .-brackets
	.section	.rodata
.LC0:
	.string	"Correct\n" # delaem metku dlya stroki
.LC1:
	.string	"Incorrect\n"
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp
	mov	rbp, rsp
	lea	r11, -999424[rsp]
.LPSRL0:
	sub	rsp, 4096 # vydelyaem na steke mesto
	or	DWORD PTR [rsp], 0
	cmp 	rsp, r11
	jne     .LPSRL0
        sub     rsp, 592
        lea     rax, -1000016[rbp]
        mov     rdi, rax # kladem v argument str
	call	read # vyzyvaem funkciyu
	lea	rax, -1000016[rbp]
	mov	rdi, rax # kladem str v argument brackets
	call	brackets
	mov	r13d, eax # result v r13d
	cmp	r13d, 0 # sravnivaem s nulem
	jne	.L12 # esli ne ravny uhodim
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT # vyzyvaem printf ot .LC0
	jmp	.L13
.L12:
	lea	rax, .LC1[rip]
	mov	rdi, rax
	call	puts@PLT # vyzyvaem printf ot .LC1
.L13:
	mov	eax, 0
	leave
	ret
