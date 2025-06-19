/* search standard input fast for C/C++ directives such as #define, #include etc. */
/* This search uses search acceleration algorithms and SIMD (SSE2/AVX2/AVX512BW/NEON/AArch64) */
/* > ./fastfind < someinputfile.cpp */
%{
#include <stdio.h>
%}

/* specify option find to search input, not to scan the input */
%o fast find main

directive       ^\h*#\h*\w+(.|\\\r?\n)*\n

%%

{directive}     echo();

%%
