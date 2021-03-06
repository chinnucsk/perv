# Easily capture media for offline viewing. Your's and possibly everyone else's too.

perv watches the network for web traffic and dumps the content to your
hard drive. On a hubbed or public wifi network, this includes everyone
else's web browsing too. perv works with any media streamed over HTTP
including Internet radio and streaming video sites like YouTube and InfoQ.

perv is really just a drifnet clone
(http://www.ex-parrot.com/~chris/driftnet/) written in Erlang but differs
in that it parses the HTTP response rather than pulling media types out
of a binary stream.


## HOW TO BUILD IT

1. Get the source code

    git clone git://github.com/msantos/perv.git

2. Compile perv

    make


## HOW TO USE IT

### perv:start() -> ok
### perv:start(Options) -> ok

    Types   Options = [EpcapArgs | Keyword]
            EpcapArgs = list()
            Keyword = [exclude]

    See epcap documentation for options.

    perv will try to find the default interface to snoop (and will
    probably get it wrong if there is more than one network interface). To
    exclude the local host from packet dumps, use:

    > perv:start(exclude).

    To override the defaults, manually specify the device using the
    epcap options, e.g.:

    > perv:start([
            {interface, "eth0"},
            {filter, "tcp and src port 80 and not host 10.11.11.11"}]).

    Content is written to priv/files/<mime type>.

    A trace file containing the HTTP response is written to priv/tmp. The
    trace file can be unpacked by using pervon:content/3.


### pervon:content(Path, Name, Response) -> ok

    Types   Path = string()
            Name = string()
            Response = binary()

    "Path" is a directory where the media in the HTTP response will
    be unpacked.

    "Name" is the suffix prepended to file names. Since the HTTP response
    can contain many files, the result of erlang:now/0 is appended to the
    name with the file type as the extension. The file type is derived
    from the "Content-Type" header.

    "Response" is the HTTP response.


### peep:start() -> ok


## EXAMPLES

* To start sniffing, specify the interface to use:

    > perv:start([{interface, "eth0"}]).


* By default, all traffic on port 80 is captured. If you want to exclude
  your IP address, modify the pcap filter. For example, if you are using
  the device "en1" with an IP address of "192.168.10.11":

    > perv:start([{interface, "en1"}, {filter, "tcp and port 80 and not 192.168.10.11"}]).


* To replay data from a pcap file (for example, captured using tcpdump):

    > perv:start([{file, "/path/to/file.pcap"}]).


* perv includes a very basic web interface:

    > peep:start().

Then open a browser: http://localhost:8889/


* To unpack the HTTP response:

    > {ok, Response} = file:read_file("priv/tmp/192.168.1.100:80-10.11.11.11:4343-1284292665354797.http").
    > pervon:content("/tmp/content_dir", "suffix", Response).


## TODO

* peep is really ugly, fix it

* handle large files, possibly by periodically writing out the buffered
  data to disk in the fsm. Since the files are buffered, downloading
  very large files can exhaust the memory of the Erlang node, causing
  it to hang or crash.

* pervon:content/3 should return a list of tuples containing the name,
  file type and file contents, rather than writing them directly to disk

* add option to enable/disable debug messages and tracing

* have peep only display images over a certain size
