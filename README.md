# asmIMG
## Быстрый вывод изображения.

Вывода изображения работает с 19 режимом видеокарты VGA. Код написан под TASM.
Для вывода необходимо преобразовать картинку в файл. Для этого можно воспользоватся моим готовым решением (CoventToVGA) или любым другим способом.
В файле ViewIMG.asm представлены 2 основные процедуры для вывода изображений.

## Соержание файла
- для картинки 320*200 каждый байт соответствует цвету пикселя (00h-ffh 256цветов VGA)
- для картинки любого размера в первых 2-х байтах указывается ширина и высота картинки. Далее цвета пикселей.
## Процедуры
- filFul выводит картинку 320*200
- filStr выводит изображение не более 255*200 в координатах Х и Y.
- openFile открывает файл и запсывает его descriptor в fileID
- getSize читает из файла ширину (hIMG) и длину (wIMG)
- exit выход из программы с фозвращением преведущего графического режима
## Сигмент данных
* **vr** преведущий графический режим *(db)*
* **file file1** путь к файлу *(db)*
* **fileID** descriptor открытого файла *(dw)*
* **fileIdFon** descriptor открытого файла 320*200 *(dw)*
* **x y** координаты положения картинки *(dw)*
* **count** счетчик *(dw)*
* **wIMG hIMG** ширина и высота картинки *(dw)*
