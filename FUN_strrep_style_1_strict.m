function str = FUN_strrep_style_1_strict( str, replaced_by )
% str = FUN_strrep_style_1_strict( str, replaced_by )
% V1.00 by L. Chi


if ~exist('replaced_by','var') || isempty( replaced_by )
    replaced_by = '_';
end

str = regexprep( str, '[^a-zA-Z0-9_]','_');