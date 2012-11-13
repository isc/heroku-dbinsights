class Heroku::Command::Dbinsights < Heroku::Command::Base
  
  def initialize(*args)
    super
    if respond_to? 'api'
      @config_vars = api.get_config_vars(app).body
    else
      @config_vars = heroku.config_vars(app)
    end
    @dbinsights_url = @config_vars["DBINSIGHTS_URL"]
    abort " !   Please add the dbinsights addon first." unless @dbinsights_url
    require 'rest_client'
  end
  
  def index
    puts "In order to create line charts and pie charts from your data,"
    puts "Dbinsights will store an encrypted version of the DATABASE_URL of your application"
    puts "(removing the addon will delete that info from the DbInsights database)"
    puts "Do you confirm the plugin execution ? (yes / no)"
    print "> "
    answer = STDIN.gets
    if answer.chomp == 'yes'
      RestClient::Resource.new(@dbinsights_url).put :account => {:db_url => @config_vars['DATABASE_URL']}
      puts "Successfully enabled DbInsights for the current app."
    else
      puts "Plugin execution aborted."
    end
  end
end
