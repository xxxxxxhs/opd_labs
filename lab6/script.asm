ORG 0x0
V0: WORD $default, 0X180
V1: WORD $int1, 0X180
V2: WORD $int2, 0X180
V3: WORD $default, 0x180
V4: WORD $default, 0X180
V5: WORD $default, 0X180
V6: WORD $default, 0X180
V7: WORD $default, 0X180

ORG 0x038
X: WORD 0x00FF;
max: WORD 0x0020 ; 32, максимальное значение Х
min: WORD 0xFFE1 ; -31, минимальное значение Х
default: IRET ; Обработка прерывания по умолчанию

START: DI
    CLA
    OUT 0x1 ; Запрет прерываний для неиспользуемых ВУ
    OUT 0x3
    OUT 0xB
    OUT 0xE
    OUT 0x12
    OUT 0x16
    OUT 0x1A
    OUT 0x1E
    LD #0x9 ; Загрузка в аккумулятор MR (1000|0001=1001)
    OUT 5 ; Разрешение прерываний для 2 ВУ
    LD #0xA ; Загрузка в аккумулятор MR (1000|0010=1010)
    OUT 7 ; Разрешение прерываний для 3 ВУ
    EI
main: DI ; Запрет прерываний чтобы обеспечить атом. операции
    LD X
    DEC
    CALL check
    ST X
    EI
    JUMP main
int1: DI ; Обработка прерывания на ВУ-2 (52)
    IN 4;
    NOP;
    AND X;
    NOT;
    ST X;
    NOP;
    EI
    IRET
int2: DI ; Обработка прерывания на ВУ-3 (5B)
    LD X;
    NOP;
    ASL;
    ASL;
    DEC;
    DEC;
    NOP;
    OUT 6;
    EI
    IRET

check: ; Проверка принадлежности X к ОДЗ
check_max: CMP max ; Проверка пересечения верхней границы X
    BMI check_min ; Если x < max переход
ld_max: LD max ; Загрузка максимального значения в X
check_min: CMP min ; Если x > min переход
    BPL return;
    JUMP ld_max ; Иначе загрузка max в аккумулятор

return: RET ; Метка возврата из проверки на ОДЗ