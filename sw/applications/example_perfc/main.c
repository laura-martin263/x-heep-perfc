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
#define PERFC_CONTROL_OFFSET  0X0               // Offset del registro CONTROL
#define PERFC_TOTAL_CYCLES_OFFSET  0x04         // Offset del registro TOTAL_CYCLES
#define PERFC_CPU_ACTIVE_CYCLES_OFFSET 0x08     // Offset del registro CPU_ACTIVE_CYCLES

void wait_cycles(volatile unsigned int cycles) {
    while(cycles--) {
        __asm__ volatile("nop");
    }
}


int main(int argc, char *argv[])
{
    PRINTF("Ejemplo de uso del periférico perfc\n\r");
    volatile uint32_t *perfc = (volatile uint32_t *)PERFC_BASE_ADDR;

    volatile uint32_t *control = (uint32_t *)(PERFC_BASE_ADDR + PERFC_CONTROL_OFFSET);
    volatile uint32_t *total_cycles  = (uint32_t *)(PERFC_BASE_ADDR + PERFC_TOTAL_CYCLES_OFFSET);
    volatile uint32_t *cpu_active_cycles = (uint32_t *)(PERFC_BASE_ADDR + PERFC_CPU_ACTIVE_CYCLES_OFFSET);

    PRINTF("Valor TOTAL_CYCLES 0: %d\n\r", *total_cycles);
    PRINTF("Valor CPU_ACTIVE_CYCLES 0: %d\n\r", *cpu_active_cycles);

    // Control OO -> Ni resetea ni se empieza a contar
    *control = 0x0;
    PRINTF("Valor TOTAL_CYCLES 1: %d\n\r", *total_cycles);
    PRINTF("Valor CPU_ACTIVE_CYCLES 1: %d\n\r", *cpu_active_cycles);

    // Control 01 -> Se resetea.
    *control = 0x1;
    PRINTF("Valor TOTAL_CYCLES 2: %d\n\r", *total_cycles);
    PRINTF("Valor CPU_ACTIVE_CYCLES 2: %d\n\r", *cpu_active_cycles);

    // Control 10 -> Se empieza a contar sin resetear
    *control = 0x2;
    wait_cycles(1000000);  // Tiempo de espera

    // Control 00 -> Para de contar
    *control = 0x0;
    PRINTF("Valor TOTAL_CYCLES 3: %d\n\r", *total_cycles);
    PRINTF("Valor CPU_ACTIVE_CYCLES 3: %d\n\r", *cpu_active_cycles);
    
    wait_cycles(1000000);  // Tiempo de espera

    PRINTF("Valor TOTAL_CYCLES 4: %d\n\r", *total_cycles);
    PRINTF("Valor CPU_ACTIVE_CYCLES 4: %d\n\r", *cpu_active_cycles);

    // Control 11 -> Se resetea
    *control = 0x3;
    PRINTF("Valor TOTAL_CYCLES 5: %d\n\r", *total_cycles);
    PRINTF("Valor CPU_ACTIVE_CYCLES 5: %d\n\r", *cpu_active_cycles);


    /*
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
    */


    return EXIT_SUCCESS;
}
