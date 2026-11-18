#include <stdio.h>
#include <zlib.h>

#include "calc.h"

int main() {
    const char text[] = "Prosoft Prosoft Prosoft";
    uLong len = compressBound((uLong)sizeof text);
    Bytef buf[64];
    compress(buf, &len, (const Bytef *)text, sizeof text);
    printf("%d %lu -> %lu\n", calc_add(1, 2),
           (unsigned long)sizeof text, (unsigned long)len);
}
