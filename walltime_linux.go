//go:build linux && !amd64

package edge

import _ "unsafe"

// WallTime unix timestamp fast-call
//go:linkname WallTime runtime.nanotime
func WallTime() (sec int64, nsec int32)
