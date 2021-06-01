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
    var pathToDrive string
    var uname syscall.Utsname

    if (len(os.Args) != 3) {
        fmt.Printf("Usage: %s disk [on|off]\n", os.Args[0])
        os.Exit(1)
    }

    // Get major and minor number of specified disk
    stat := syscall.Stat_t{}

    _ = syscall.Stat("/dev/" + os.Args[1], &stat)

    major := uint64((stat.Rdev >> 8) & 0xfff)
    minor := uint64((stat.Rdev & 0xff) | ((stat.Rdev >> 12) & 0xfff00))

    // Get major Linux kernel version. We need this to determine the location of the
    // fault LED control file
    _ = syscall.Uname(&uname)

    majorversion,_ := strconv.Atoi(string(uname.Release[0]))

    // Construct the path to the fault LED control file
    if (majorversion >= 5) {
        // Linux kernel 5.x and newer
        pathToDrive = "/sys/dev/block" + strconv.FormatUint(major,10) + ":" + strconv.FormatUint(minor,10) + "/device/enclosure*/fault"
    } else {
        // Linux kernel 3.x and 4.x
        pathToDrive = "/sys/dev/block/" + strconv.FormatUint(major,10) + ":" + strconv.FormatUint(minor,10) + "/device/block/" + os.Args[1] + "/device/enclosure*/fault"
    }

    paths, _ := filepath.Glob(pathToDrive)

    if (paths == nil) {
        fmt.Printf("Failed finding fault LED control file:\n%s\n", pathToDrive)
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
