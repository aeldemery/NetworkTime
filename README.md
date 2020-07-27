# Network Time

## Table of Contents

- [About](#about)
- [Usage](#usage)

## About <a name = "about"></a>

Network Time is one of coding examples in the book 'Introducing Vala Programming, by Dr Michael Lauer'.

The [Network Time Protocol](https://en.wikipedia.org/wiki/Network_Time_Protocol) is a networking protocol for clock synchronization between computer systems over packet-switched, variable-latency data networks.

This Example uses Linux low-level Socket networking API to communicate with the server.

### Installing

This is a simple `meson` project.

```
> meson --prefix=/usr builddir
> ninja -C builddir
> ./networktime
> Found 4 IP address(es) for pool.ntp.org
> Using pool.ntp.org IP address 195.50.171.101
> Current UTC time is Mon Jul 27 12:06:00 2020
```
