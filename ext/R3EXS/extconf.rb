require 'mkmf'

$ARCH_FLAG << '-march=native'

create_makefile('R3EXS/R3EXS')
