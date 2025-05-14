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
#define PERFC_CONTROL_OFFSET  0X04  // Offset del registro CONTROL
#define PERFC_PRUEBA2_OFFSET 0x08  // Offset del registro PRUEBA2

int main(int argc, char *argv[])
{
    PRINTF("Ejemplo de uso del periférico perfc\n\r");
    volatile uint32_t *perfc = (volatile uint32_t *)PERFC_BASE_ADDR;

    // ESTO ES LO QUE FUNCIONA PARA ESCRIBIR Y LEER DESDE SW
    volatile uint32_t *prueba  = (uint32_t *)(PERFC_BASE_ADDR + PERFC_PRUEBA_OFFSET);
    volatile uint32_t *control = (uint32_t *)(PERFC_BASE_ADDR + PERFC_CONTROL_OFFSET);
    volatile uint32_t *prueba2 = (uint32_t *)(PERFC_BASE_ADDR + PERFC_PRUEBA2_OFFSET);

    *prueba  = 0x4;
    PRINTF("Valor PRUEBA: %d\n\r", *prueba);

    *control = 0x5;
    PRINTF("Valor CONTROL: %d\n\r", *control);

    *prueba2 = 0x6;
    PRINTF("Valor PRUEBA2: %d\n\r", *prueba2);

    // HASTA AQUI ES LO QUE FUNCIONA PARA ESCRIBIR Y LEER DESDE SW


    return EXIT_SUCCESS;
}
