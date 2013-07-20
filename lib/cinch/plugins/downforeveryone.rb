require "mechanize"
module Cinch
  module Plugins
    class DownForEveryone
      include Cinch::Plugin

      def initialize(*args)
        super

        @agent = Mechanize.new
        @agent.user_agent_alias = "Linux Mozilla"
      end

      match(/isit(?:down|up)\?? (.+)/)
      def execute(m, url)
        if up?(url)
          m.reply "It's just you. #{url} is up."
        else
          m.reply "It's not just you! #{url} looks down from here."
        end
      end

      private
      def up?(url)
        url = url.gsub(/^https?:\/\//, '')
        page = @agent.get("http://downforeveryoneorjustme.com/#{url}")
        !!page.at('[id="container"]').content.match(/http\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?( is up\.)/)
      end
    end
  end
end
