//go:build linux && !amd64

package cutting_go

import _ "unsafe"

// WallTime unix timestamp fast-call
//go:linkname WallTime runtime.nanotime
func WallTime() (sec int64, nsec int32)
