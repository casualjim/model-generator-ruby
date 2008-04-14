# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 
require 'optparse'

class CommandArgs < Hash
  
  def initialize(args)
    super()
    
    self[:project_file] = Dir['*.csproj'][0]
    options = OptionParser.new do |opts|
      opts.banner = "Usage: #$0 [options]"
      opts.on('-P', '--project-file-location PATH',  'The location of the project file ') do |path|
        self[:project_file] = path
      end

      opts.on('-n', '--namespace NAMESPACE', 'The namespace of that will contain the models') do |namespace|
        self[:namespace] = namespace
      end
      
      opts.on('-c', '--context-prefix PREFIX', 'The prefix of the DataContext name for Linq support ') do |prefix|
        self[:datacontext_prefix] = prefix
      end
      
      opts.on('-m', '--model-path PATH', 'The folder to generate the models in') do |path|
        self[:model_path] = path
      end
      
      opts.on('-b', '--entity-base-class BASENAME', 'The class to use as a base class for the entities') do |base_name|
          self[:base_class] = base_name
      end
      
      opts.on_tail('-h', '--help', 'display this help and exit') do
        puts opts
        exit
      end
    end

    options.parse!(args) 
  end
  
end
