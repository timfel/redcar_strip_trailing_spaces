module Redcar
  class StripTrailingSpaces
    def self.before_save(doc)
      if doc.mirror.is_a?(Redcar::Project::FileMirror)
        read_cursor(doc)
        doc.text = strip_spaces(doc)
        set_cursor(doc)
      end
    end

    private

    def read_cursor(doc)
      @cursor_line = doc.cursor_line
      @line_offset = doc.cursor_line_offset
      line = doc.get_line(@cursor_line)
      @line_offset = line.rstrip.size if @line_offset > line.rstrip.size
    end

    def strip_spaces(doc)
      doc.to_s.split("\n").each{|s| s.rstrip!}.join("\n")
    end

    def set_cursor(doc)
      offset=doc.offset_at_line(@cursor_line) + @line_offset
      doc.cursor_offset=offset
      doc.ensure_visible(offset)
    end
  end
end