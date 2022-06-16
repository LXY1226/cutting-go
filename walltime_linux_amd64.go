//go:build linux && amd64

package edge

func WallTime() (sec int64, nsec int32)

func WallTimeNano() (nsec int64)
