namespace :grape do
  task :routes => :environment do
    Grape::API.subclasses.each do |subclass|
      subclass.routes.each do |e|
        puts "%-10s %-6s %-24s %s" % [subclass, e.request_method, e.path, e.description]
      end
      puts
    end
  end
end