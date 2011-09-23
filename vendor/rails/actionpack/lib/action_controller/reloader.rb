#Edited By Salil as patch gven at
# http://github.com/rails/rails/commit/d37ac7958fc88fdbf37a8948102f6b4e45c530b3


require 'thread'  #this line is added

module ActionController
  class Reloader
    @@lock = Mutex.new   #this line is added

    class BodyWrapper
      #def initialize(body) #this line is deleted
      def initialize(body, lock) #this line is added
        @body = body
	@lock = lock #this line is added
      end

      def close
        @body.close if @body.respond_to?(:close)
      ensure
        Dispatcher.cleanup_application
	@lock.unlock #this line is added
      end

      def method_missing(*args, &block)
        @body.send(*args, &block)
      end

      def respond_to?(symbol, include_private = false)
        symbol == :close || @body.respond_to?(symbol, include_private)
      end
    end

    #def initialize(app) #this line is deleted
    def initialize(app, lock = @@lock)   #this line is added
      @app = app
      @lock = lock    #this line is added
    end

    def call(env)
      @lock.lock  #this line is added
      Dispatcher.reload_application
      status, headers, body = @app.call(env)
      # We do not want to call 'cleanup_application' in an ensure block
      # because the returned Rack response body may lazily generate its data. This
      # is for example the case if one calls
      #
      #   render :text => lambda { ... code here which refers to application models ... }
      #
      # in an ActionController.
      #
      # Instead, we will want to cleanup the application code after the request is
      # completely finished. So we wrap the body in a BodyWrapper class so that
      # when the Rack handler calls #close during the end of the request, we get to
      # run our cleanup code.
      #[status, headers, BodyWrapper.new(body)]  #this line is deleted
      [status, headers, BodyWrapper.new(body, @lock)]  #this line is added
    end
  end
end
