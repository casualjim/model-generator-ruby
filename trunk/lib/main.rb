dir = File.expand_path(File.dirname(__FILE__))

require 'yaml'
require 'dbi'
require 'rexml/document'
require "ftools"
require dir + '/inflector'
require dir + "/inflections"
require dir + "/string"
include REXML

require dir + '/light_speed_repository'

require dir + '/command_args'

args = CommandArgs.new(ARGV)

if args[:project_file].nil? || args[:project_file].empty?
	puts "Please specify a path to the csproj file to append the model files to."
end

ls = LightSpeedRepository.new args[:project_file], args[:namespace], args[:datacontext_prefix], args[:model_path]

ls.entity_base = args[:base_class] unless args[:base_class].nil? || args[:base_class].empty?

ls.excluded_tables = %w(KeyTable sysdiagrams ModuleVersions)
ls.add_files_to_vs_project