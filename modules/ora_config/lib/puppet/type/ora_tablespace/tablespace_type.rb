# doc
module TablespaceType
  def tablespace_type
    case resource[:contents]
    when :permanent, :undo
      'datafile'
    when :temporary
      'tempfile'
    else
      fail "internal error. #{resource[:contents]} is an invalid content type."
    end
  end
end
