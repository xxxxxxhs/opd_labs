ORG 0x100;
isdrew: WORD 0x0000;
count: WORD 0x20;
check: LD &1;
    ROR;
    BLO even;
    LD isdrew;
    BNE return;
    LD #0x60;
    OUT 0x10;
    LD #0xB8;
    OUT 0x10;
    LD #0xAC;
    OUT 0x10;
    LD #0x54;
    OUT 0x10;
    LD #0xAC;
    OUT 0x10;
    LD #0xB8;
    OUT 0x10;
    LD #0x60;
    OUT 0x10;
    LD #0x01;
    ST isdrew;
    JUMP return;
even: LD isdrew;
    BEQ return;
    LD #0x00;
loopback: OUT 0x10;
    LOOP count;
    JUMP loopback;
    LD #0x00;
    ST isdrew;
    LD #0x20;
    ST count;
return: RET;

ORG 0x513; Адрес начала программы
result: WORD 0x5B9; Ссылка на результат
stop: WORD 0x0D; Стоп-символ
temp: WORD ?; временное хранилище
start: CLA; Очистка аккумулятора
s1: IN 5; Ожидание ввода первого символа
    AND #0x40; Проверка 6 бита - SR ("Готов"?)
    BEQ s1; Нет - спин-луп, ожидание "Готов"
    IN 4; Ввод байта в AC
    SWAB; Перенос первого символа в старший байт
    ST (result); Сохраняем символ в результат
    ST temp; Сохраняем так же во временное хранилище
    SWAB;
    PUSH;
    CALL $check;
    POP;
    SWAB; Перенос обратно для корректной проверки на стоп
    CMP stop; Проверка на стоп-символ
    BEQ exit; Если введен стоп-символ - завершение
    CLA; очистка аккумулятора
s2: IN 5; Ожидание ввода второго символа
    AND #0x40; Проверка 6 бита - SR ("Готов"?)
    BEQ s2; Нет - спин-луп, ожидание "Готов"
    IN 4; Ввод байта в AC
    OR temp; объединение двух символов
    ST (result); Сохранение в результат
    SUB temp; Убираем первый символ для проверки
    PUSH;
    CALL $check;
    POP;
    CMP stop; Проверка на стоп-символ
    BEQ exit; Если введен стоп-символ - завершение
    LD (result)+; Инкремент адреса результата
    CLA; Очистка аккумулятора
    JUMP s1; Переход в начало цикла
exit: LD(result)+; Инкремент адреса результата
    HLT; Остановка программы