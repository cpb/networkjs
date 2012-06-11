
begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

begin
  require 'jasmine-headless-webkit'
  require 'jasmine/headless/task'

  Jasmine::Headless::Task.new
rescue LoadError => e
  namespace :jasmine do
    task :headless do
      abort "Jasmine Headless is not available, try running bundle install"
    end
  end
end

namespace :g do
  desc "Create new class and spec"
  task :class, [:name] do |t, args|
    raise "You need to provide a name" unless args.name

    puts "creating public/javascripts/#{args.name}.js"
    Pathname.new("public/javascripts/#{args.name}.coffee").open('w') do |file|
      file.write(<<-END)
#= require commonjs

class #{args.name}
  constructor: ->

exports.#{args.name} = #{args.name}
END
    end

    puts "creating spec/javascripts/#{args.name}_spec.js"
    Pathname.new("spec/javascripts/#{args.name}Spec.coffee").open('w') do |file|
      file.write(<<-END)
#= require #{args.name}

@#{args.name} = exports.#{args.name}

describe "#{args.name}", ->

END
    end
  end
end
