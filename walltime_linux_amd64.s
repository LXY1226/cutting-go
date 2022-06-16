#include "textflag.h"

// modify from runtime/sys_linux_amd64.s
// g_* macro generated from go 1.18.3 windows/amd64
TEXT ·WallTime(SB),NOSPLIT,$16-12
    // We don't know how much stack space the VDSO code will need,
	// so switch to g0.
	// In particular, a kernel configured with CONFIG_OPTIMIZE_INLINING=n
	// and hardening can use a full page of stack space in gettime_sym
	// due to stack probes inserted to avoid stack/heap collisions.
	// See issue #20427.
	MOVQ	SP, R12	// Save old SP; R12 unchanged by C code.

    MOVQ	0x30(R14), BX   // g_m(R14), BX     // BX unchanged by C code.

    CMPQ	R14, 0xc0(BX)   // R14, m_curg(BX)  // Only switch if on curg.
    JNE	noswitch

    MOVQ	0x0(BX), DX     // m_g0(BX), DX
    MOVQ	0x38(DX), SP    // (g_sched+gobuf_sp)(DX), SP	// Set SP to g0 stack

noswitch:
    SUBQ	$16, SP		// Space for results
    ANDQ	$~15, SP	// Align for C code

    MOVL	$0, DI // CLOCK_REALTIME
    LEAQ	0(SP), SI
    MOVQ	runtime·vdsoClockgettimeSym(SB), AX
    CALL	AX
ret:
    MOVQ	0(SP), AX	// sec
    MOVQ	8(SP), DX	// nsec
    MOVQ	R12, SP		// Restore real SP

    MOVQ	AX, ret+0(FP)
    MOVQ	DX, ret+8(FP)
    RET
