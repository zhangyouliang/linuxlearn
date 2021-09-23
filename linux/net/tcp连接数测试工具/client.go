package main

import (
    "net"
    "fmt"
    "time"
    "strconv"
    "runtime"
)
// CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o dist/app client.go
func Connect(host string, port int) {
    _, err := net.Dial("tcp", host+":"+strconv.Itoa(port))
    if err != nil {
        fmt.Printf("Dial to %s:%d failed\n", host, port)
        return
    }

    for {
        //time.Sleep(30 * 1000 * time.Millisecond)
        time.Sleep(3600 * 1000 * time.Millisecond)
    }
}

func main() {
    count := 0
    for {
        go Connect("172.18.0.155", 8080)
        count++;
        fmt.Printf("Gorutue num:%d\n", runtime.NumGoroutine())
        time.Sleep(10 * time.Millisecond)
    }
}
