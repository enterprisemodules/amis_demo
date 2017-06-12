newproperty(:comment) do
  include EasyType

  desc <<-EOT
   This property shows the text of the applied patches.

    We noticed that the patch numbers are informational, but
    the most important information is the textual representation
    of the contents of the patch. Therefore, this type reports
    this information when using `$ puppet resource ora_opatch`.
    It is ignored when you apply a puppet manifest. You can still
    use it in your manifest

  EOT

  def insync?(to)
    true # Ignore this property when comparing.
  end

  to_translate_to_resource do |raw_resource|
    raw_resource[:comment]
  end
end
