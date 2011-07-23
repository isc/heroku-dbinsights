module Heroku::Command
  class Dbinsights < BaseWithApp
    Help.group("DBInsights") do |group|
      group.command "dbinsights",                      "enable db insights for the current app"
    end
    
    def initialize(*args)
      super
      @config_vars = heroku.config_vars(app)
      @dbinsights_url = @config_vars["DBINSIGHTS_URL"]
      abort(" !   Please add the dbinsights addon first.") unless @dbinsights_url
    end
    
    def index
      RestClient::Resource.new(@dbinsights_url).put :account => {:db_url => @config_vars['DATABASE_URL']}
      puts "Successfully enabled db insights for the current app."
    end

  end
end