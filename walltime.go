//go:build amd64 && linux

package cutting_go

import (
	_ "unsafe"
)

// WallTime unix timestamp fast-call
func WallTime() (sec int64, nsec int32)
