function Key_Struct = keyboard_template(Ori_ClK)
% KEYBOARD_TEMPLATE generate a keyboard template give a color image of a
% keyboard. The funcion returns a struct containing keys's coordinate and
% name
%

%% Key - segmentation
F = Key_Segment(Ori_ClK);

%% Make data structure for keys
Key_Struct = Struct_Key(F);