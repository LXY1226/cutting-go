//go:build !linux && !windows

package cutting_go

import (
	_ "unsafe"
)

// use time.now from runtime
//go:linkname now time.now
func now() (sec int64, nsec int32, mono int64)

func WallTime() (sec int64, nsec int32) {
	sec, nsec, _ = now()
	return
}
