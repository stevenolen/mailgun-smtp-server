require 'mailgun'
require 'midi-smtp-server'

# sync stdout so logging shows up
$stdout.sync = true

# Server class
class MailgunSmtpd < MidiSmtpServer::Smtpd
  def start
    unless ENV.key?('MG_DOMAIN') && ENV.key?('MG_KEY')
      printf "#{Time.now}: You must set the environment variables MG_DOMAIN and MG_KEY. Exiting...\n"
      exit(false)
    end

    @@mg_client = Mailgun::Client.new ENV['MG_KEY']
    @@mg_domain = ENV['MG_DOMAIN']
    super
  end

  def on_message_data_event(ctx)
    logger.debug("[#{ctx[:envelope][:from]}] for recipient(s): [#{ctx[:envelope][:to]}]...")

    data = {
      to: ctx[:envelope][:to], 
      message: ctx[:message][:data]
    }

    @@mg_client.send_message @@mg_domain, data
  end
end

listen_port = ENV['MG_SMTPD_PORT'] || 25
listen_addr = ENV['MG_SMTPD_ADDRESS'] || '0.0.0.0'
listen_simul = ENV['MG_SMTPD_SIMULATENOUS_CONNECTIONS'] || 4
listen_options = ENV['MG_SMTPD_OPTIONS'] || {}

printf "#{Time.now}: Starting MailgunSmtpd on #{listen_addr}:#{listen_port}...\n"
server = MailgunSmtpd.new(listen_port, listen_addr, listen_simul, listen_options)

server.start
server.join

# setup exit code
BEGIN {
  at_exit {
    # check to shutdown connection
    if server
      puts "#{Time.now}: Shutting down MailgunSmtpd..."
      # gracefully connections down
      server.shutdown
      # check once if some connection(s) need(s) more time
      sleep 2 unless server.connections == 0 
      # stop all threads and connections
      server.stop
    end
  }
}
