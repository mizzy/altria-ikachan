require "net/http"
require "uri"
require "string-irc"

module Altria
  module Ikachan
    class Notifier
      attr_reader :job

      def initialize(job)
        @job      = job
        @build    = job.current_build
        @uri      = URI.parse(job.ikachan_base_url)
        @channels = channels
      end

      def after_execute
        if @build.status
          message = StringIrc.new("Success: #{@job.name} \##{@build.id}").green.bold
        else
          message = StringIrc.new("Fail: #{@job.name} \##{@build.id}").red.bold
        end

        @channels.each do |channel|
          Net::HTTP.start(@uri.host, @uri.port) {|http|
            body = "channel=#{channel}"
            res = http.post('/join', body)

            body = "channel=#{channel}&message=#{message}"
            res = http.post('/notice', body)
          }
        end
      end

      def channels
        @job.ikachan_irc_channels.split(' ').map do |channel|
          channel = '#' + channel if channel !~ /^#/
          channel
        end
      end
    end
  end
end
