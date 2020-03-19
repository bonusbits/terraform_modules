module Orchestrator
  module Erb
    require 'erb'

    # Create Rendered File from ERB Template Locally
    def self.create_file(file, template, acl)
      # file = full path and file name to create
      # template = full path to .erb file
      rendered_content = Orchestrator::Erb.render_template(template)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Erb.create_file] rendered_content', rendered_content)
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Erb.create_file] rendered_content.class', rendered_content.class)

      File.open(file, 'w') do |f|
        f.write rendered_content
        File.chmod(acl, file)
        Orchestrator::ConsoleOutputs.message_item('File Created', file)
      end
    end

    # Return rendered Ruby file Template object. Used for creating remote files using rendered content in heredoc shell call
    def self.render_template(template)
      # template = full path to .erb file
      rendered_template = ERB.new(File.read(template)).result
      Orchestrator::ConsoleOutputs.debug_message_item('[Orchestrator::Erb.render_template] rendered_template', rendered_template)
      rendered_template
    end

    # TODO: WIP
    # def render_k8s_template(template)
    #   erb_template = ERB.new(File.read(template)).result
    #   rendered_service = YAML.safe_load(erb_template)
    #   # Write Rendered Config Data to file
    #   File.open(template, 'w') { |file| file.write(rendered_service.to_yaml) }
    # end
  end
end
