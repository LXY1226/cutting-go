// modified from runtime
#include "textflag.h"

// Copyright 2021 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Constants for fetching time values on Windows for use in asm code.

// See https://wrkhpi.wordpress.com/2007/08/09/getting-os-information-the-kuser_shared_data-structure/
// Archived copy at:
// http://web.archive.org/web/20210411000829/https://wrkhpi.wordpress.com/2007/08/09/getting-os-information-the-kuser_shared_data-structure/

// Must read hi1, then lo, then hi2. The snapshot is valid if hi1 == hi2.
// Or, on 64-bit, just read lo:hi1 all at once atomically.
#define _INTERRUPT_TIME 0x7ffe0008
#define _SYSTEM_TIME 0x7ffe0014
#define time_lo 0
#define time_hi1 4
#define time_hi2 8

// Read time from KUSER_SHARED_DATA
TEXT ·WallTimeNano(SB),NOSPLIT,$0-8
	MOVQ	$_SYSTEM_TIME, DI
	MOVQ	time_lo(DI), AX
	MOVQ	$116444736000000000, DI
	SUBQ	DI, AX
	// SUBQ	$116444736000000000, AX
	IMULQ	$100, AX
	MOVQ	AX, nsec+0(FP)
	RET

TEXT ·WallTime(SB),NOSPLIT,$0-12
	MOVQ	$_SYSTEM_TIME, DI
	MOVQ	time_lo(DI), AX
	MOVQ	$116444736000000000, DI
	SUBQ	DI, AX
	IMULQ	$100, AX

	// generated code for
	//	func f(x uint64) (uint64, uint64) { return x/1000000000, x%1000000000 }
	// adapted to reduce duplication
	MOVQ	AX, CX
	MOVQ	$1360296554856532783, AX
	MULQ	CX
	ADDQ	CX, DX
	RCRQ	$1, DX
	SHRQ	$29, DX
	MOVQ	DX, sec+0(FP)
	IMULQ	$1000000000, DX
	SUBQ	DX, CX
	MOVL	CX, nsec+8(FP)
	RET
