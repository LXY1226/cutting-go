package cutting_go

import (
	"testing"
	"time"
)

func TestWallTime(t *testing.T) {
	println(WallTimeNano())
	for i := 0; i < 10000000; i++ {
	} // waste some time
	println(WallTime())
	time.Sleep(time.Second)
	println(WallTime())
}

func BenchmarkWallTime(b *testing.B) {
	for i := 0; i < b.N; i++ {
		WallTime()
	}
}

func BenchmarkTimeNow(b *testing.B) {
	for i := 0; i < b.N; i++ {
		time.Now()
	}
}
