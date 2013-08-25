require "rails/railtie"

module Altria
  module Ikachan
    class Railtie < Rails::Railtie
      initializer "altria.ikachan" do
        require "altria/ikachan/initializer"
      end
    end
  end
end
