module Redcar
  class StripTrailingSpaces
    def self.storage
      @storage ||= begin
        storage = Plugin::Storage.new('strip_trailing_spaces_plugin')
        storage.set_default('enabled', false)
        storage
      end
    end

    def self.menus
      Menu::Builder.build do
        sub_menu "Plugins" do
          sub_menu "Strip Trailing Spaces" do
            if (Redcar::StripTrailingSpaces.storage['enabled'])
              item "Disable Plugin", DisablePlugin
            else
              item "Enable Plugin", EnablePlugin
            end
          end
        end
      end
    end

    def self.before_save(doc)
      if (doc.mirror.is_a?(Redcar::Project::FileMirror) && storage['enabled'])
        indenter = doc.controllers(Redcar::AutoIndenter::DocumentController)[0]
        indenter = nil unless indenter.is_a?(Redcar::AutoIndenter::DocumentController)

        indenter.increase_ignore if indenter != nil
        doc.line_count.times do |l|
          doc.replace_line(l) { |line_text| line_text.rstrip }
        end
        indenter.decrease_ignore if indenter != nil
      end
    end

    class EnablePlugin < Redcar::Command
      def execute
        Redcar::StripTrailingSpaces.storage['enabled'] = true
        Redcar.app.refresh_menu!
      end
    end

    class DisablePlugin < Redcar::Command
      def execute
        Redcar::StripTrailingSpaces.storage['enabled'] = false
        Redcar.app.refresh_menu!
      end
    end
  end
end
