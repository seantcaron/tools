//
// Disk beacon, Sean Caron (scaron@umich.edu)
//

package main

import (
    "fmt"
    "os"
    "syscall"
    "strconv"
    "path/filepath"
)

var ( MINORBITS = uint(20)
      MINORMASK = uint((uint(1) << MINORBITS) - 1)
)

func main() {
    if (len(os.Args) != 3) {
        fmt.Printf("Usage: %s disk [on|off]\n", os.Args[0])
        os.Exit(1)
    }

    // Get major and minor number of specified disk
    stat := syscall.Stat_t{}
    
    _ = syscall.Stat("/dev/" + os.Args[1], &stat)

    major := uint64((stat.Rdev >> 8) & 0xfff)
    minor := uint64((stat.Rdev & 0xff) | ((stat.Rdev >> 12) & 0xfff00))

    // Construct the path to the fault LED control file
    pathToDrive := "/sys/dev/block/" + strconv.FormatUint(major,10) + ":" + strconv.FormatUint(minor,10) + "/device/block/" + os.Args[1] + "/device/enclosure*/fault"

    paths, _ := filepath.Glob(pathToDrive)

    if (paths == nil) {
        fmt.Printf("Failed finding enclosure/fault in /sys/dev/block\n")
        os.Exit(1)
    }

    // Arm fault LED
    if (os.Args[2] == "on") {
        infile, _ := os.OpenFile(paths[0], os.O_WRONLY, 0666)
        fmt.Fprintf(infile, "1")
        infile.Close()
    }

    // Disarm fault LED
    if (os.Args[2] == "off") {
        infile, _ := os.OpenFile(paths[0], os.O_WRONLY, 0666)
        fmt.Fprintf(infile, "0")
        infile.Close()
    }
}
