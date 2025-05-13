// Copyright EPFL contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdio.h>
#include <stdlib.h>

#include "core_v_mini_mcu.h"
#include "x-heep.h"

/* By default, printfs are activated for FPGA and disabled for simulation. */
#define PRINTF_IN_FPGA 1
#define PRINTF_IN_SIM 0

#if TARGET_SIM && PRINTF_IN_SIM
#define PRINTF(fmt, ...) printf(fmt, ##__VA_ARGS__)
#elif PRINTF_IN_FPGA && !TARGET_SIM
#define PRINTF(fmt, ...) printf(fmt, ##__VA_ARGS__)
#else
#define PRINTF(...)
#endif

// Dirección base del periférico perfc
#define PERFC_BASE_ADDR  (PERIPHERAL_START_ADDRESS + 0x00080000)
#define PERFC_PRUEBA_OFFSET  0x00  // Offset del registro PRUEBA

int main(int argc, char *argv[])
{
    PRINTF("Ejemplo de uso del periférico perfc\n\r");
    volatile uint32_t *perfc = (volatile uint32_t *)PERFC_BASE_ADDR;

    // Leer valor del registro PRUEBA
    uint32_t prueba_val = perfc[PERFC_PRUEBA_OFFSET];  // División por 4 porque el acceso es por palabras

    PRINTF("Valor leído del registro PRUEBA: %d\n\r", prueba_val);

    return EXIT_SUCCESS;
}
