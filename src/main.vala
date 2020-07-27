// Copyright (c) 2020 Ahmed Eldemery
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT


/**
 * Network Time Protocol Packet
 */
struct NtpPacket 
{
    uint8 li_vn_mode;
    uint8 stratum;
    uint8 poll;
    uint8 precision;
    uint32 rootDelay;
    uint32 rootDispersion;
    uint32 refId;
    uint32 refTm_s;
    uint32 refTm_f;
    uint32 origTm_s;
    uint32 origTm_f;
    uint32 rxTm_s;
    uint32 rxTm_f;
    uint32 txTm_s;
    uint32 txTm_f;
}


int main (string[] args)
{
    var packet = NtpPacket ();
    assert (sizeof (NtpPacket) == 48 );
    packet.li_vn_mode = 0x1b;
    
    const string hostname = "pool.ntp.org";
    const uint16 portno = 123; // NTP
    
    unowned Posix.HostEnt server = Posix.gethostbyname (hostname);
    if (server == null)
    {
        error( @"Can't resolve host $hostname: $(Posix.errno)" );
    }
    print( @"Found $(server.h_addr_list.length) IP address(es) for $hostname\n" );
    
    var address = Posix.SockAddrIn ();
    address.sin_family = Posix.AF_INET;
    address.sin_port = Posix.htons (portno);
    Posix.memcpy (&address.sin_addr, server.h_addr_list[0], server.h_length);
    var stringAddress = Posix.inet_ntoa (address.sin_addr);
    print (@"Using $hostname IP address $stringAddress\n");
    
    var sockfd = Posix.socket (Posix.AF_INET, Posix.SOCK_DGRAM, Posix.IPProto.UDP);
    if (sockfd < 0)
    {
        error (@"Can't creat socket: $(Posix.errno)");
    }
    
    var ok = Posix.connect (sockfd, address, sizeof (Posix.SockAddrIn));
    if (ok < 0)
    {
        error (@"Can't connect: $(Posix.errno)");
    }
    
    var written = Posix.write (sockfd, &packet, sizeof (NtpPacket));
    if (written < 0)
    {
        error (@"Can't send UDP packet: $(Posix.errno)");
    }
    
    var received = Posix.read (sockfd, &packet, sizeof (NtpPacket));
    if (received < 0)
    {
        error (@"Can't read form socket: $(Posix.errno)");
    }
    
    packet.txTm_s = Posix.ntohl (packet.txTm_s);
    packet.txTm_f = Posix.ntohl (packet.txTm_f);
    const uint64 NTP_TIMESTAMP_DELTA = 2208988800ull;
    time_t txTm = (time_t) (packet.txTm_s - NTP_TIMESTAMP_DELTA);
    
    var time_str = Posix.ctime (ref txTm);
    print (@"Current UTC time is $time_str");
    
    return 0;
}
