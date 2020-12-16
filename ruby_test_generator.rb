#!/usr/bin/env ruby
#
# The Ruby Test Generator is a command line program.
# It uses GraphWalker to generate test sequences and inputs.
# It can execute a method in a Ruby model class file for each element.
# The element names in the model file, and the model class file must match exactly.
# The Ruby Test Generator stops when edge coverage has been reached, or no next element is available.

require "json"
require "optparse"
require "rest-client"

module RubyTestGenerator

  # Parse the command line options
  # @return [Hash] - A hash of the command line options
  def self.parse_options
    options = {}
    built_opts = {}

    option_parser = OptionParser.new  do |opts|
      opts.banner = "Usage: ruby_test_generator.rb {options}"
      opts.separator(" ")

      opts.on("-j", "--json [JSON]", String, "{optional} Path to the JSON model file to be loaded into GraphWalker (.json)") do |json|
        options[:json] = json
      end

      opts.on("-u", "--url  [URL]", String, "{optional} Base URL of the GraphWalker REST API") do |url|
        options[:url] = url
      end

      opts.on("-r", "--ruby [RUBY]", String, "{optional} Path to the Ruby model class file to be executed (.rb)") do |ruby|
        options[:ruby] = ruby
      end

      opts.on("-s", "--save [SAVE]", String, "{optional} Path to the directory of the walk file to be saved") do |save|
        options[:save] = save
      end

      opts.on("-w", "--walk [WALK]", String, "{optional} Path to the walk file to be executed (.wlk)") do |walk|
        options[:walk] = walk
      end

      opts.on("-h", "--help", "Print this help message") do
        puts opts
        exit
      end
      built_opts = opts
    end

    option_parser.parse!(options)

    if options.empty?
      puts built_opts
      exit
    end

    return options
  end

  # Load the Ruby model class file
  # @param [String] - Path to the Ruby model class file
  # @raise [Error] - Error if the Ruby model class does not load
  # @return [Object] - The name of the class in the model class file
  def self.load_ruby_model_class(model_class_file)
    model_class_file_full = File.join (model_class_file)
    load_result = load(model_class_file_full)
    unless (load_result == true)
      raise "ERROR: Model class file #{model_class_file} failed to load."
    end

    # Determine classname from file name
    model_class_file_basename = File.basename(model_class_file_full,".rb")
    model_class_name = class_name_from_file_name(model_class_file_basename)
    Object.const_get(model_class_name)
  end

  # Load the model file
  # @param [String] - Path to the model file (*.json)
  # @param [String] - Base url for the GraphWalker REST API
  # @raise [Error] - Error if the model file is not found, or does not load into GraphWalker
  def self.load_model_json(model_json_file, base_url)
    model_json_file_full = File.join (model_json_file)
    unless File.exists?(model_json_file_full)
      raise  "ERROR: Model JSON file #{model_json_file} was not found."
    end

    gw_load_url = "#{base_url}/load"

    load_response = RestClient.post(gw_load_url, File.new("#{model_json_file_full}").read.to_s, {:content_type => 'text/plain'})

    unless (JSON.parse(load_response)['result'] == "ok")
      raise "ERROR: Failed to load JSON model file #{model_json_file_full} into GraphWalker at URL #{gw_load_url}"
    end
  end

  # Save the walk array to a walk file
  # @param walk [Array] - An ordered list of element names
  # @param save_directory [String] -  Path to the directory where the walk file will be saved
  def self.save_walk_sequence_to_file (walk, save_directory)
    walk_file_path = File.join(save_directory, "walk-" + Time.now.to_i.to_s + ".wlk")
    if File.exists?(walk_file_path)
      raise  "ERROR: Walk file #{walk_file_path} already exists"
    end
    File.open(walk_file_path, "w+") do |f|
      f.puts(walk)
    end
    puts "Saved the walk to the file: #{walk_file_path}"
  end

  # Execute the element method in the model class
  # @param class_obj [Class] - the model class object
  # @param element [String] - The name of the element method being called
  def self.send_model_class_method (class_obj, element)
    unless class_obj.methods.include? element.to_sym
      raise "ERROR: Method #{element} not defined in class #{class_obj.name.to_s}"
    end
    element_response = class_obj.send(element)
  end


  # Run from a walk file
  # @param walk_file_path [String] - Path to the walk file to be run
  def self.run_from_walk_file(options)
    puts "Ruby Test Generator has started to replay the walk file #{options[:walk]}."
    startTime = Time.now.to_f

    walk_file_path = options[:walk]
    if(options[:ruby])
      model_class = load_ruby_model_class(options[:ruby])
    end
    File.readlines(walk_file_path).each do |element_name|
      # output the element name
      element_method = element_name.strip!
      puts "ELEMENT: #{element_method}"

      # Call the model element method in the model class
      if(options[:ruby])
        element_response = send_model_class_method(model_class, element_method)
        puts element_response
        unless (element_response.include?"SUCCESS") || (element_response.include?"PENDING")
          raise(element_response)
        end
      end
    end

    # Calculate elapsed time
    endTime = Time.now.to_f
    elapsedTime = endTime - startTime

    puts "Ruby Test Generator replayed the walk file in:  #{elapsedTime} seconds."
    puts ""

    return "COMPLETED"
  end

  # Run from GraphWalker REST API
  # The graphWalker container must be running with a model
  # @param options [Hash] - the command line options
  # @raise [Error] - Raise error if GraphWalker does not response as expected
  def self.run_from_graph_walker (options)

    # Initialize walk array
    walk = []

    # Default GraphWalker base url to local
    base_url= "http://localhost:8887/graphwalker"

    if(options[:url])
      base_url = options[:url]
    end
    puts "Ruby Test Generator is using GraphWalker REST API at #{base_url}."

    # Load the GraphWalker model
    if(options[:json])
      model_json_file_full = File.join (options[:json])
      load_model_json(options[:json], base_url)
      puts "Ruby Test Generator has loaded a JSON model into GraphWalker."
    end

    puts "GraphWalker is starting its walk."

    # Initialize walk counter and timer
    walk_counter = 0
    startTime = Time.now.to_f

    # Restart the GraphWalker model to its initial state
    # Raise error if GraphWalker does not respond
    restart_url = "#{base_url}/restart"
    restart_response = RestClient.put("#{restart_url}","")

    unless (JSON.parse(restart_response)['result'] == "ok")
      raise "GraphWalker restart endpoint did not return a result of \"ok\"."
    end

    # Load the Ruby model class
    if(options[:ruby])
      model_class = load_ruby_model_class(options[:ruby])
    end

    # Request the next element from GraphWalker
    # Break if edge coverage has been achieved, or if there is no next element
    # Raise error if GraphWalker does not respond
    loop do
      # Get the execution statistics
      statistics_url = "#{base_url}/getStatistics"
      statistics_response = RestClient.get("#{statistics_url}")

      # statistics_response = `curl -s #{statistics_url}`
      unless (JSON.parse(statistics_response)['result'] == "ok")
        raise "GraphWalker getStatistics endpoint did not return a result of \"ok\"."
      end
      if (JSON.parse(statistics_response)['edgeCoverage'].to_i == 100)
        puts "GraphWalker reached 100% edge coverage. Congratulations!"
        break
      end

      # Check that GraphWalker model has a next element
      # Raise error if GraphWalker does not respond
      hasNext_url =  "#{base_url}/hasNext"
      hasNext_response = RestClient.get("#{hasNext_url}")
      unless (JSON.parse(hasNext_response)['result'] == "ok")
        raise "GraphWalker hasNext endpoint did not return a result of \"ok\"."
      end
      unless (JSON.parse(hasNext_response)['hasNext'] == "true")
        puts "GraphWalker hasNext endpoint did not return a result of \"true\"."
        break
      end

      # Get the next element name
      # Raise error if GraphWalker does not respond
      getNext_url =  "#{base_url}/getNext"
      getNext_response = RestClient.get("#{getNext_url}")
      unless (JSON.parse(getNext_response)['result'] == "ok")
        raise "GraphWalker getNext endpoint did not return a result of \"ok\"."
      end
      element_name = JSON.parse(getNext_response)['currentElementName']

      # output the element name
      puts "ELEMENT: #{element_name}"

      # Increment walk counter
      walk_counter += 1

      # add the element to the walk array
      if(options[:save])
        walk << element_name
      end

      # Call the model element method in the model class
      if(options[:ruby])
        element_response = send_model_class_method(model_class, element_name)
        puts element_response
        unless (element_response.include?"SUCCESS") || (element_response.include?"PENDING")
          raise(element_response)
        end
      end
    end

    # Calculate elapsed time
    endTime = Time.now.to_f
    elapsedTime = endTime - startTime

    puts "GraphWalker walked that model in: #{walk_counter} steps in #{elapsedTime} seconds."

    # Save the walk array to a walk file
    if(options[:save])
      save_walk_sequence_to_file(walk, options[:save])
    end

    puts ""

    return "COMPLETED"
  end

  # Return a Ruby class name from a Ruby class file name
  def self.class_name_from_file_name(file_name)
    file_name.split('_').map{|e|e.capitalize}.join
  end

end

if $0 == __FILE__
    options = RubyTestGenerator.parse_options

    if options[:walk]
      RubyTestGenerator.run_from_walk_file(options)
    else
      RubyTestGenerator.run_from_graph_walker(options)
    end
end