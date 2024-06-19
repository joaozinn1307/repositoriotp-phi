.data
  resultado: .asciiz "O valor do fibonacci de"
  razao: .asciiz "O valor da razao aurea de"
  pularLinha: .asciiz "\n"
  branco: .asciiz " "
  esimo: .asciiz "n-esimo"
  igual: .asciiz "="
  
.text
.globl main
main: 
  li $a0, 30
  jal fibonacci
  move $s1, $v0 # valor do 30° termo de fibonacci
   
  li $a0, 41
  jal fibonacci
  move $s2, $v0 # valor do 41° termo de fibonacci

  li $a0, 40
  jal fibonacci
  move $s3, $v0 # valor do 40° termo de fibonacci

  move $a0, $s3
  move $a1, $s2
  jal razao_aurea # fazer o calculo da proporcao e colocando no $f0

  li $a0, 30
  move $a1, $s1
  jal imprimirFibonacci #imprimindo fibonacci de 30

  li $a0, 41
  move $a1, $s2
  jal imprimirFibonacci #imprimindo fibonacci de 41

  li $a0, 40
  move $a1, $s3
  jal imprimirFibonacci #imprimindo fibonacci de 40

  
  li $a0, 40
  li $a1, 41
  jal imprimirRazaoAurea #imprimindo a razao aurea

  # finalizacao do programa
  jal endProgram

  endProgram:
    li $v0, 10 
    syscall

  imprimirInt: 
    li $v0, 1
    syscall
    jr $ra

  imprimirFloat: 
    li $v0, 2
    mov.s $f12, $f0 # move o valor de f0 para o f12 para ser impresso
    syscall
    jr $ra

  imprimirString: 
    li $v0, 4
    syscall
    jr $ra

  imprimirFibonacci:
    # salva os registradores da funcao
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    move $t0, $a0

    la $a0, resultado # imprimindo o resultado
    jal imprimirString
    la $a0, branco
    jal imprimirString
    move $a0, $t0
    jal imprimirInt
    la $a0, branco
    jal imprimirString
    la $a0, igual
    jal imprimirString
    la $a0, branco
    jal imprimirString
    move $a0, $a1
    jal imprimirInt
    la $a0, pularLinha
    jal imprimirString

    lw $ra, 0($sp) # recuperando os registradores da funcao
    addi $sp, $sp, 4
    jr $ra

  imprimirRazaoAurea:
    # salva os registradores da funcao
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    move $t0, $a0

    la $a0, razao 
    jal imprimirString   
    la $a0, branco
    jal imprimirString
    move $a0, $t0
    jal imprimirInt
    la $a0, branco
    jal imprimirString
    move $a0, $a1
    jal imprimirInt
    la $a0, branco
    jal imprimirString
    la $a0, igual
    jal imprimirString
    la $a0, branco
    jal imprimirString
    jal imprimirFloat

    lw $ra, 0($sp) # recuperando os registradores da funcao
    addi $sp, $sp, 4
    jr $ra

  fibonacci:
    li $t0, 2 # contador do loop
    li $t1, 1 # para a soma do loop
    li $t2, 1 # para a soma do loop
    ble $a0, $zero, zero
    fibonacci_loop:
      beq $a0, $t0, end_loop
      add $t3, $t1, $t2
      move $t1, $t2
      move $t2, $t3
      addi $t0, $t0, 1
      j fibonacci_loop
    end_loop:
      move $v0, $t3 # retornando o valor do n-esimo fibonacci
      j pos_zero

    zero:
      move $v0, $zero # se for 0 ou menor, retorna 0
    pos_zero:
    jr $ra 

  razao_aurea:
    beq $a1,$zero, return_aurea

    mtc1  $a0, $f1
    cvt.s.w $f1, $f1 # convertendo os valores inteiros para float
    mtc1 $a1, $f2
    cvt.s.w $f2, $f2

    div.s  $f0, $f2, $f1 # divisao de ponto flutuante, resultado fica em $f0
    j end_return_aurea

    
    return_aurea:
      move $v0, $zero # voltar 0 se for o primeiro termo
    end_return_aurea:

    jr $ra
