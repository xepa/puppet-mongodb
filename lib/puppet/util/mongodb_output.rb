module Puppet
  module Util
    module MongodbOutput
      def self.sanitize(data)
        # Dirty hack to remove JavaScript objects
        data.gsub!(%r{^({.+"msg":"Started a new thread for the timer service"}\n)}, '') # hack to remove tls / auth spam see https://github.com/mongodb/mongo/commit/f7f6c6928320873089b443da007de119b926f605
        data.gsub!(%r{\w+\((\d+).+?\)}, '\1') # Remove extra parameters from 'Timestamp(1462971623, 1)' Objects
        data.gsub!(%r{\w+\((.+?)\)}, '\1')

        data.gsub!(%r{^Error\:.+}, '')
        data.gsub!(%r{^.*warning\:.+}, '') # remove warnings if sslAllowInvalidHostnames is true
        data.gsub!(%r{^.*The server certificate does not match the host name.+}, '') # remove warnings if sslAllowInvalidHostnames is true mongo 3.x
        data
      end
    end
  end
end
