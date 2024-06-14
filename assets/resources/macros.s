@ COMP2300 macros
@ version 1.2
@ (c) Ben Swift
@ MIT Licence

.macro write_bit reg_addr offset bit data
	ldr r1, =(\reg_addr + \offset)
	ldr r0, [r1]
	orr r0, #(\data << \bit)
	str r0, [r1]
.endm

.macro set_bit reg_addr offset bit
	ldr r1, =(\reg_addr + \offset)
	ldr r0, [r1]
	orr r0, #(1 << \bit)
	str r0, [r1]
.endm

.macro clear_bit reg_addr offset bit
	ldr r1, =(\reg_addr + \offset)
	ldr r0, [r1]
	bic r0, #(1 << \bit)
	str r0, [r1]
.endm

.macro toggle_bit reg_addr offset bit
	ldr r1, =(\reg_addr + \offset)
	ldr r0, [r1]
	eor r0, #(1 << \bit)
	str r0, [r1]
.endm

@ sets flags, leaves read bit in lsb of r0
.macro read_bit reg_addr offset bit
	ldr r1, =(\reg_addr + \offset)
	ldr r0, [r1]
  lsr r0, #\bit
	ands r0, #1
.endm

@ example: if you want to insert the pattern "0b0110" into bits 5:2 into the
@ memory or register wired to 0x2000000C, you could do it like:
@
@ insert_bits 0x20000000, 0xC, 0b0110, 2, 4
@
.macro insert_bits reg_addr offset bits lsb width
	ldr r1, =(\reg_addr + \offset)
	ldr r0, [r1]
  ldr r2, =\bits
  @ this is the bitfield insert instruction
  bfi r0, r2, #\lsb, #\width
	str r0, [r1]
.endm

@ some discoboard-specific GPIO macros

.set SYSCFG_BASE_ADDRESS, 0x40010000
.set RCC_BASE_ADDRESS, 0x40021000
.set EXTI_BASE_ADDRESS, 0x40010400
.set NVIC_BASE_ADDRESS, 0xE000E100
.set MPU_BASE_ADDRESS, 0xE000ED90
.set SYSTICK_BASE_ADDRESS, 0xE000E010

.set GPIOA_BASE_ADDRESS, 0x48000000
.set GPIOB_BASE_ADDRESS, 0x48000400
.set GPIOC_BASE_ADDRESS, 0x48000800
.set GPIOD_BASE_ADDRESS, 0x48000C00
.set GPIOE_BASE_ADDRESS, 0x48001000
.set GPIOF_BASE_ADDRESS, 0x48001400
.set GPIOG_BASE_ADDRESS, 0x48001800
.set GPIOH_BASE_ADDRESS, 0x48001C00

.set GPIOA_PIN_INDEX, 0
.set GPIOB_PIN_INDEX, 1
.set GPIOC_PIN_INDEX, 2
.set GPIOD_PIN_INDEX, 3
.set GPIOE_PIN_INDEX, 4
.set GPIOF_PIN_INDEX, 5
.set GPIOG_PIN_INDEX, 6
.set GPIOH_PIN_INDEX, 7

@ helper macros for writing to useful registers

.macro RCC_AHB2ENR_write position value
  write_bit RCC_BASE_ADDRESS, 0x4C, \position, \value
.endm

.macro RCC_AHB2ENR_set position
  set_bit RCC_BASE_ADDRESS, 0x4C, \position
.endm

.macro RCC_AHB2ENR_clear position
  clear_bit RCC_BASE_ADDRESS, 0x4C, \position
.endm

.macro RCC_APB2ENR_write position value
  write_bit RCC_BASE_ADDRESS, 0x60, \position, \value
.endm

.macro RCC_APB2ENR_set position
  set_bit RCC_BASE_ADDRESS, 0x60, \position
.endm

.macro RCC_APB2ENR_clear position
  clear_bit RCC_BASE_ADDRESS, 0x60, \position
.endm

@ ICSR

.macro ICSR_set pos
  set_bit 0xE000ED00, 0x4, \pos
.endm

.macro ICSR_clear pos
  clear_bit 0xE000ED00, 0x4, \pos
.endm

@ GPIO helpers

.macro GPIOx_clock_enable port
  RCC_AHB2ENR_set GPIO\port\()_PIN_INDEX
.endm

.macro GPIOx_MODER_write port pin mode
  insert_bits GPIO\port\()_BASE_ADDRESS, 0x0, \mode, (\pin * 2), 2
.endm

.macro GPIOx_PUPDR_write port pin mode
  insert_bits GPIO\port\()_BASE_ADDRESS, 0xC, \mode, (\pin * 2), 2
.endm

.macro GPIOx_ODR_write port pin data
  write_bit GPIO\port\()_BASE_ADDRESS, 0x14, \pin, \data
.endm

.macro GPIOx_ODR_set port pin
  set_bit GPIO\port\()_BASE_ADDRESS, 0x14, \pin
.endm

.macro GPIOx_ODR_clear port pin
  clear_bit GPIO\port\()_BASE_ADDRESS, 0x14, \pin
.endm

.macro GPIOx_ODR_toggle port pin
  toggle_bit GPIO\port\()_BASE_ADDRESS, 0x14, \pin
.endm

.macro GPIOx_IDR_read port pin
  read_bit GPIO\port\()_BASE_ADDRESS, 0x10, \pin
.endm

@ NVIC/EXTI & interrupts
@ (most of these are only valid for EXTI interrupts 0-31, but that covers all the GPIO pins)

.macro SYSCFG_EXTIxCR_write port pin
	ldr r1, =(SYSCFG_BASE_ADDRESS + 0x8 + 4 * (\pin / 4))
	ldr r0, [r1]
  ldr r2, =GPIO\port\()_PIN_INDEX
  @ this is the bitfield insert instruction
  bfi r0, r2, 4 * (\pin % 4), #3
	str r0, [r1]
.endm

@ enable interrupt in EXTI interrupt mask register
.macro EXTI_IMR_enable number
  set_bit EXTI_BASE_ADDRESS, 0, \number
.endm

@ disable interrupt in EXTI interrupt mask register
.macro EXTI_IMR_disable number
  clear_bit EXTI_BASE_ADDRESS, 0, \number
.endm

.macro EXTI_set_rising_edge_trigger pin
  set_bit EXTI_BASE_ADDRESS, 0x8, \pin
.endm

.macro EXTI_set_falling_edge_trigger pin
  set_bit EXTI_BASE_ADDRESS, 0xC, \pin
.endm

@ to see if an interrupt has been triggered
.macro EXTI_PR_check_pending, pin
	read_bit EXTI_BASE_ADDRESS, 0x14 , \pin
.endm

@ to trigger a software interrupt
.macro EXTI_PR_set_pending, pin
	set_bit EXTI_BASE_ADDRESS, 0x10, \pin
.endm

@ to clear an already-triggered interrupt
@ (note: to *clear* a "pending" interrupt, you need to *set* the bit in EXTI_PR1)
.macro EXTI_PR_clear_pending, pin
	set_bit EXTI_BASE_ADDRESS, 0x14, \pin
.endm

@ generic NVIC helpers

@ set-enable
.macro NVIC_ISER_read position
  read_bit NVIC_BASE_ADDRESS, 4 * (\position / 32), \position % 32
.endm

.macro NVIC_ISER_set position
  set_bit NVIC_BASE_ADDRESS, 4 * (\position / 32), \position % 32
.endm

@ clear-enable
.macro NVIC_ICER_set position
  set_bit NVIC_BASE_ADDRESS, 0x80 + 4 * (\position / 32), \position % 32
.endm

@ set-pending
.macro NVIC_ISPR_read position
  read_bit NVIC_BASE_ADDRESS, 0x100 + 4 * (\position / 32), \position % 32
.endm

.macro NVIC_ISPR_set position
  set_bit NVIC_BASE_ADDRESS, 0x100 + 4 * (\position / 32), \position % 32
.endm

@ clear-pending
.macro NVIC_ICPR_set position
  set_bit NVIC_BASE_ADDRESS, 0x180 + 4 * (\position / 32), \position % 32
.endm

@ interrupt-active
.macro NVIC_IABR_read position
  read_bit NVIC_BASE_ADDRESS, 0x200 + 4 * (\position / 32), \position % 32
.endm

@ specific helpers for EXTI interrupts

.macro NVIC_EXTI0_enable
	ldr r1, =NVIC_BASE_ADDRESS
	mov r0, #(1 << 6)
	str r0, [r1]
.endm

.macro NVIC_EXTI0_disable
	ldr r1, =(NVIC_BASE_ADDRESS + 0x80)
	mov r0, #(1 << 6)
	str r0, [r1]
.endm

.macro NVIC_EXTI1_enable
	ldr r1, =NVIC_BASE_ADDRESS
	mov r0, #(1 << 7)
	str r0, [r1]
.endm

.macro NVIC_EXTI1_disable
	ldr r1, =(NVIC_BASE_ADDRESS + 0x80)
	mov r0, #(1 << 7)
	str r0, [r1]
.endm

.macro NVIC_EXTI2_enable
	ldr r1, =NVIC_BASE_ADDRESS
	mov r0, #(1 << 8)
	str r0, [r1]
.endm

.macro NVIC_EXTI2_disable
	ldr r1, =(NVIC_BASE_ADDRESS + 0x80)
	mov r0, #(1 << 8)
	str r0, [r1]
.endm

.macro NVIC_EXTI3_enable
	ldr r1, =NVIC_BASE_ADDRESS
	mov r0, #(1 << 9)
	str r0, [r1]
.endm

.macro NVIC_EXTI3_disable
	ldr r1, =(NVIC_BASE_ADDRESS + 0x80)
	mov r0, #(1 << 9)
	str r0, [r1]
.endm

.macro NVIC_EXTI4_enable
	ldr r1, =NVIC_BASE_ADDRESS
	mov r0, #(1 << 10)
	str r0, [r1]
.endm

.macro NVIC_EXTI4_disable
	ldr r1, =(NVIC_BASE_ADDRESS + 0x80)
	mov r0, #(1 << 10)
	str r0, [r1]
.endm

@ EXTI9_5 and EXTI15_10 are special cases
.macro NVIC_EXTI9_5_enable
	ldr r1, =NVIC_BASE_ADDRESS
	mov r0, #(1 << 23)
	str r0, [r1]
.endm

.macro NVIC_EXTI9_5_disable
	ldr r1, =(NVIC_BASE_ADDRESS + 0x80)
	mov r0, #(1 << 23)
	str r0, [r1]
.endm

.macro NVIC_EXTI15_10_enable
	ldr r1, =(NVIC_BASE_ADDRESS + 0x4)
	mov r0, #(1 << 8)
	str r0, [r1]
.endm

.macro NVIC_EXTI15_10_disable
	ldr r1, =(NVIC_BASE_ADDRESS + 0x84)
	mov r0, #(1 << 8)
	str r0, [r1]
.endm

@ NVIC interrupt priorities

.macro NVIC_IPR_set_priority position priority
	ldr r1, =(NVIC_BASE_ADDRESS + 0x300 + 4 * (\position / 4))
	ldr r0, [r1]
  ldr r2, =\priority
  bfi r0, r2, (8 * (\position % 4) + 4), #4
	str r0, [r1]
.endm

@ setting the priority of the system handlers (e.g. SysTick, PendSV,
@ SVCall) is a bit different

.macro SHPR_set_priority position priority
	ldr r1, =(0xE000ED14 + 4 * (\position / 4))
	ldr r0, [r1]
  ldr r2, =\priority
  bfi r0, r2, 8 * (\position % 4) + 4, #4
	str r0, [r1]
.endm

@ high-level helper macros

.macro declare_output_pin port pin
  GPIOx_MODER_write \port, \pin, 0b01
.endm

.macro declare_input_pin port pin
  GPIOx_MODER_write \port, \pin, 0b00
  GPIOx_PUPDR_write \port, \pin, 0b10
.endm

@ this one also triggers the interrupts
.macro declare_input_pin_it port pin
  declare_input_pin \port, \pin
  SYSCFG_EXTIxCR_write \port, \pin @ set port as source for this interrupt
  set_bit EXTI_BASE_ADDRESS, 0x0, \pin @ enable interrupt in EXTI_IMR1
.endm
