module Redcar
  class StripTrailingSpaces
    def self.before_save(doc)
      if doc.mirror.is_a?(Redcar::Project::FileMirror)
        # Read cursor position and adjust line offset
        cursor_line = doc.cursor_line
        line_offset = doc.cursor_line_offset
        line = doc.get_line(cursor_line)
        line_offset = line.rstrip.size if line_offset > line.rstrip.size

        doc.text = doc.to_s.split("\n").each{|s| s.rstrip!}.join("\n")

        # Adjust cursor offset and make visible
        offset=doc.offset_at_line(cursor_line) + line_offset
        doc.cursor_offset=offset
        doc.ensure_visible(offset)
      end
    end
  end
end