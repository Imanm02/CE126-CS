include 'emu8086.inc'

stackseg segment para stack 
        dw  256 dup (?)
stackseg ends       
                            
data segment para                                                     
        last_added      db      0               
        array           db      100 dup (0)     
        len             dw      0                
        size            dw      0               
        count           dw      0
data ends                                                                   

code segment                                                            
 
assume cs:code,ds:data,ss:stackseg                                      
        cld                     
        mov     ax,data                                             
        mov     ds,ax                         
        
        call    scan_num
        mov     size, cx                                                                
        mov     al,1                               
        call    add_item                                                
                                                                        
     build_array:                                                          
 	    cmp     ds:[len],0                 
       	jbe     exit                                       
     cont:                                                         
        call    is_array_valid     
 	    jc      invalid      
	    mov     al,ds:[size]    
        cbw                                      
	    cmp     ds:[len],ax     
	    ja      invalid      
	    je      found_solution
	    mov     al,1            
	    call    add_item                                                
	    jmp     build_array        
   invalid:                                                          
        call    backtrack       
      	jmp     build_array        
   found_solution:                                          
        inc     ds:[count]
        call    backtrack       
        jmp     build_array                          
       	jmp     exit         
   exit:
        mov     ax, count                                                    
        call    print_num                                                  
                                                                     
backtrack proc                                                       
  bk_retrack:                                                        
       	cmp     ds:[len],0                                           
     	je      bk_exit                                              
        mov     al,ds:[last_added]  
     	cmp     al,ds:[size]    
     	jne     bk_no_retrack   
     	call    remove_item     
     	jmp     bk_retrack      
  bk_no_retrack:                                                 
        inc     al              
        push    ax              
        call    remove_item     
        pop     ax              
        call    add_item        
  bk_exit:                                   
      	ret                     
backtrack endp                                                   
                                                                 
add_item proc                                                    
        mov     si,offset ds:[array]                             
        add     si,ds:[len]            
        mov     ds:[si],al             
        mov     ds:[last_added],al     
        inc     ds:[len]               
        ret                                                      
add_item endp                                                    
                                                                 
remove_item proc                                                 
        mov     si,offset ds:[array]   
        add     si,ds:[len]            
        dec     si                     
        mov     al,0                   
        mov     ds:[si],al                                       
        dec     ds:[len]               
        mov     al,ds:[si-1]           
        mov     ds:[last_added],al
        ret                                                      
remove_item endp                                                 
                                                                 
is_array_valid proc                                                 
        cmp     ds:[len],1              
      	jbe     valid_exit               
        mov     si,offset ds:[array]    
       	mov     cx,ds:[len]             
        dec     cx                      
        mov     dx,ds:[len]             
        mov     dh,0                     
   check_diag:                                                            
        inc     dh                                               
        lodsb                                                    
        mov     bh,al                    

	    cmp     al,ds:[last_added]                      
     	je      error_exit                                    
                                         
        mov     bl,bh                   
        sub     bl,ds:[last_added]                     
        sub     bl,dh                                  
        add     bl,dl                                  
        jz      error_exit                               
                                                       
        mov     bl,ds:[last_added]      
        sub     bl,bh                    
        sub     bl,dh                    
        add     bl,dl                    
        jz      error_exit                     
                                              
	    loop    check_diag                 
   valid_exit:
	    clc                             
	    ret                                                
   error_exit:                                               
        stc                             
     	ret                                             
is_array_valid endp                                        
                                                                                                                

DEFINE_SCAN_NUM
DEFINE_PRINT_NUM 
DEFINE_PRINT_NUM_UNS 
                                                                            
code ends                                                                     
end                                                                         
