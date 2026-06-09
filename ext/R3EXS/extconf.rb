require 'mkmf'

$ARCH_FLAG << '-march=native -std=c++23'

create_makefile('R3EXS/R3EXS')
