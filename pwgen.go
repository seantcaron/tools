//
// Quick password generator, Sean Caron, scaron@umich.edu
//

package main

import (
    "fmt"
    "time"
    "math/rand"
    "os"
    "strconv"
)

func main() {
    lc := "abcdefghijklmnopqrstuvwxyz"
    uc := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    nm := "0123456789"
    p := "!@#$%^&*()_+-=[];',./{}:<>?"

    // Default length unless overridden by args
    length := 12

    passwd := ""
    chars := ""

    if len(os.Args) == 1 {
        fmt.Printf("Usage: %s [-lc] [-uc] [-n] [-p] [-l len]\n", os.Args[0])
	os.Exit(1)
    }

    for i := 0; i < len(os.Args); i++ {
        switch os.Args[i] {
	    case "-lc":
	        chars = chars + lc
            case "-uc":
	        chars = chars + uc
            case "-n":
	        chars = chars + nm
            case "-p":
	        chars = chars + p
            case "-l":
	        length, _ = strconv.Atoi(os.Args[i+1])
        }
    }

    // Default set of sane options if user didn't specify any sensible args
    if len(chars) == 0 {
        chars = lc + uc + nm
    }

    rand.Seed(time.Now().UnixNano())

    for i := 0; i < length; i++ {
	passwd = passwd + string(chars[rand.Int() % len(chars)])
    }

    fmt.Printf("%s\n", passwd)
}
