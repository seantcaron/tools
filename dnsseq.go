//
// Sequential DNS zone file entry generator, Sean Caron, scaron@umich.edu
//

package main

import (
    "fmt"
    "os"
    "strconv"
    "strings"
    "flag"
)

func main() {
  var a, ptr bool
  flag.BoolVar(&a, "a", false, "Generate A-records")
  flag.BoolVar(&ptr, "ptr", false, "Generate PTR-records")

  var prefix, suffix, baseip, domain string
  flag.StringVar(&prefix, "prefix", "", "Prefix for host names")
  flag.StringVar(&suffix, "suffix", "", "Suffix for host names")
  flag.StringVar(&baseip, "baseip", "192.168.1.1", "Base IP address")
  flag.StringVar(&domain, "domain", "localhost.localdomain", "Domain for constructing PTR-records")

  var base, numhosts, places int
  flag.IntVar(&base, "base", 0, "Base to count up from for host name")
  flag.IntVar(&numhosts, "num-hosts", 10, "Number of hosts to generate")
  flag.IntVar(&places, "places", 2, "Number of places in sequential component of host name")

  flag.Parse()

  if !a && !ptr {
    fmt.Printf("Fatal: No record type (a, ptr) specified\n")
    os.Exit(1)
  }

  octets := strings.Split(baseip, ".")
  lastoctet, _ := strconv.Atoi(octets[3])

  var format string
  format = "%s%0" + strconv.Itoa(places) + "d%s\tIN\tA\t%s.%s.%s.%s\n"

  // Generate A-records
  if a {
    for i := 0; i < numhosts; i++ {
      fmt.Printf(format, prefix, i+base, suffix, octets[0],octets[1],octets[2],strconv.Itoa(lastoctet+i))
    }
  }

  // Generate PTR records
  if ptr {
    for i := 0; i < numhosts; i++ {
      fmt.Printf("%s\tIN\tPTR\t%s%02d%s.%s.\n", strconv.Itoa(lastoctet+i), prefix, i+base, suffix, domain)
    }
  }

}
