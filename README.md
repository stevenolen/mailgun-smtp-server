# mailgun-smtp-server

This is a [docker](https://www.docker.io) image that makes use of [midi-smtp-server](https://github.com/4commerce-technologies-AG/midi-smtp-server) project and the [mailgun-ruby](https://github.com/mailgun/mailgun-ruby/) sdk to accept SMTP email via standard methods and relay messages to the mailgun via the mailgun HTTP API rather than the mailgun smtp servers.  It's a neat little tool that allows you to act as an SMTP server for legacy systems, but operate without using outgoing SMTP traffic (which may be blocked by your ISP).

## Usage

```bash
docker run --name mail \
  -e MG_KEY=yourmailgunapikey \
  -e MG_DOMAIN=yourmailgundomain \
  -p 25:25
  stevenolen/mailgun-smtp-server
```

  * `MG_SMTPD_SIMULATENOUS_CONNECTIONS` can be passed to allow more than 4 simulatenous connections
  * `MG_SMTPD_OPTIONS` maps to `opts` parameter in midi-smtp-server's `Smtpd` class.

# License/Author/Credits

Author: Steve Nolen

License: Apache v2 (see `LICENSE` file in this repository for details)

Credits: 
  * Thanks to [Tom Freudenberg](http://www.4commerce.de/), [4commerce technologies AG](http://www.4commerce.de/) for the awesome, extensible and dreadfully simple smtp server.
  * Thanks to [mailgun](https://mailgun.com) for their service and ruby sdk.
