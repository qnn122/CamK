function name = Key_name(numb)
% Input
%   numb : position of key
% Output
%   name : name of key

switch(numb)
    case 1
        name = 'Del';
    case 2
        name = '=';
    case 3
        name = '-';
    case 4
        name = '0';
    case 5
        name = '9';
    case 6
        name = '8';
    case 7
        name = '7';
    case 8
        name = '6';
    case 9
        name = '5';
    case 10
        name = '4';
    case 11
        name = '3';
    case 12
        name = '2';
    case 13
        name = '1';
    case 14
        name = '`';
    case 15
        name = '\';
    case 16
        name = ']';
    case 17
        name = '[';
    case 18
        name = 'p';
    case 19
        name = 'o';
    case 20
        name = 'i';
    case 21
        name = 'u';
    case 22
        name = 'y';
    case 23
        name = 't';
    case 24
        name = 'r';
    case 25
        name = 'e';
    case 26
        name = 'w';
    case 27
        name = 'q';
    case 28
        name = 'Tab';
    case 29
        name = 'Enter';
    case 30
        name = '''';
    case 31
        name = ';';
    case 32
        name = 'l';
    case 33
        name = 'k';
    case 34
        name = 'j';
    case 35
        name = 'h';
    case 36
        name = 'g';
    case 37
        name = 'f';
    case 38
        name = 'd';
    case 39
        name = 's';
    case 40
        name = 'a';
    case 41
        name = 'Cap';
    case 42
        name = 'Shi';
    case 43
        name = '/';
    case 44
        name = '.';
    case 45
        name = ',';
    case 46
        name = 'm';
    case 47
        name = 'n';
    case 48
        name = 'b';
    case 49
        name = 'v';
    case 50
        name = 'c';
    case 51
        name = 'x';
    case 52
        name = 'z';
    case 53
        name = 'Shi';
    case 54
        name = 'Up';
    case 55
        name = 'Opt';
    case 56
        name = 'Com';
    case 57
        name = 'Spa';
    case 58
        name = 'Com';
    case 59
        name = 'Opt';
    case 60
        name = 'Ctr';
    case 61
        name = 'Fn';
    case 62
        name = 'Right';
    case 63
        name = 'Down';
    case 64
        name = 'Left';
    otherwise
        name = 'NULL';
end