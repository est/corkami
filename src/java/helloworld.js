;// HelloWorld in Java (jasmin) and Javascript

;// Ange Albertini, BSD 2012

; alert("Hello World! [Javascript]");
; /*

.class public HelloWorld
.super java/lang/Object

.method public <init>()V
   aload_0
   invokenonvirtual java/lang/Object/<init>()V
   return
.end method

.method public static main([Ljava/lang/String;)V
   .limit stack 2
   getstatic java/lang/System/out Ljava/io/PrintStream;
   ldc "Hello World! [Java]"
   invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
   return
.end method
;*/