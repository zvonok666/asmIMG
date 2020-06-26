code segment
begin:
	assume cs:code, ds:data
	
	mov ax, data
	mov ds,ax
	
	;Сохраняем и включаем 13h графический режим VGA
	mov ah, 0Fh
	int 10h
	mov vr, al
	mov ax,0013h
	int 10h
	
	;открытие фала
	mov dx, offset file
	call openFile
	mov ax, fileID
	mov fileIdFon, ax
	;вывод картинки 320х200
	call filFul
	
	;открытие фала
	mov dx, offset file1
	call openFile
	;установка координат и вывод картинки
	mov x, 60
	mov y, 100
	call filStr
	
	
    mov  ah, 10h			
	int  16h	 			
	call exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openFile proc             ;;
	push ax				  ;;
						  ;;
	mov ax, 3d00h         ;;
	int 21h               ;;
	JB _error             ;;
	mov fileID, ax        ;; открытие файла file 
						  ;; на вход
	pop ax				  ;;	dx -> file 
ret                       ;; на выход
openfile endp             ;;	fileID
_error:                   ;; если ошибка
	mov  dx, OFFSET errMsg;;	пишет error и выходит после нажатия клавиши 
	mov  ah, 9	 		  ;;
	int  21h              ;;
	mov  ah, 10h	 	  ;;
	int  16h			  ;;
	call exit             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
filFul proc			;;
	push ds			;;
	push ax			;;закрашивает экран 
	push cx			;;цветами из файла 
	push bx			 ;;на вход 
	mov bx, fileIdFon ;;	fileIdFon
					 ;;
	mov ah, 42h		;;
	mov cx, 0		;;
	mov dx, 0		;;
	mov al, 0		;;
	int 21h			;;
					;;
	mov ax, 0A000h	;;		
	mov ds, ax		;;
	mov cx, 0FA00h	;;
	mov dx, 0h		;;
	mov ah, 3fh		;;
	int 21h			;;
					;;
	pop bx			;;
	pop cx			;;
	pop ax			;;
	pop ds			;;
ret					;;
filFul endp			;;
;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Рисует катинку из файла
filStr proc							;;в указаных координатах
	push ds							;;на вход
	push ax							;;		fileID
	push cx							;;		координаты в x y
	push dx							;;		наличие переменной wIMG и hIMG
	push bx							;;
	call getSize					;;
	mov count, 0;;;;;;;;;;отсчет 	;;
	mov bx, fileID					;;
	mov ah, 42h						;;
	mov cx, 0	;;установка			;;
	mov dx, 2	;;начала картинки	;;
	mov al, 0						;;
	int 21h							;;
									;;
filStrFor: ;;;;;;;;;;;;;;;;;;		;;
	mov ax, 320		;;подсет;		;;
	mul y 			;;offset;		;;
	add ax, x		;;;;;;;;;		;;
	mov dx, ax;;;;;;;;;;;;;;;		;;
									;;											
	push ds;;;;;;;;;;;;;;;;;;;;;	;;
	mov ch, 0		;;;;;;;;;;;;	;;
	mov cl, wIMG ;;;;;;;;;;;;		;;
	mov ax, 0A000h	;;отрисовка;	;;
	mov ds, ax		;;строчки;;;	;;
	mov ah, 3fh		;;;;;;;;;;;;	;;
	int 21h			;;;;;;;;;;;;	;;
	pop ds;;;;;;;;;;;;;;;;;;;;;;	;;
									;;
	inc y;;;;;;;;;;;;;;;;;;;;;;;;	;;
	inc count		;;переход;;;;	;;
	mov ax, hIMG	;;на новую;;;	;;
	cmp count, ax	;;выход;;;;;;	;;
	je filStrForEnd	;;если конец;	;;
	jmp filStrFor;;;;;;;;;;;;;;;;	;;
									;;	
filStrForEnd: ;;;;;;;;;;;;;;		;;
	pop bx			;;конец;		;;
	pop dx			;;;;;;;;		;;
	pop cx			;;;;;;;;		;;
	pop ax			;;;;;;;;		;;
	pop ds;;;;;;;;;;;;;;;;;;		;;
ret									;;
filStr endp							;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getSize proc				;;
	push ax					;;Получение размера изображения
	push bx					;;на вход
	push cx					;;	fileID
	push dx					;;
							;;
	mov ah, 42h				;;
	mov cx, 0				;;
	mov dx, 0				;;
	mov al, 0				;;
	int 21h					;;
							;;
	mov ah, 3fh				;;на выходе
	mov bx, fileID			;;	wIMG (ширина)
	mov cx, 1				;;	hIMG (высота)
	mov dx, offset wIMG		;;
	int 21h					;;
	mov ah, 3fh				;;
	mov dx, offset hIMG		;;
	int 21h					;;
							;;
	pop dx 					;;
	pop cx					;;
	pop bx					;;
	pop ax					;;
ret							;;
getSize endp				;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
exit proc 			;;Выход из программы
	mov ah,00h		;;
	mov al, vr		;;
	int 10h			;;
	mov  ax, 4c00h	;;	
	int  21h		;;
exit endp			;;
;;;;;;;;;;;;;;;;;;;;;;

code ENDS 
data SEGMENT
	vr db 0 ;преведущий графический режим
	file db 'fon.dat',0 ;путь к файлу
	file1 db 'selector.dat',0
	fileID dw 0 ;id открытого файла
	fileIdFon dw 0;id открытого файла 320*200
	x dw 0 ;координаты
	y dw 0 ;положения картинки
	count dw 0 ;счетчик
	wIMG db 0 ;ширина
	hIMG dw 0 ;и высота картинки
	errMsg db 'error file code(0)', 13, 10,'$' ;messege
data ENDS
end begin
