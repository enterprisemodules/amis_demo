# Docs
class Version
  include Comparable

  def initialize(version)
    @version = version
  end

  def <=>(other)
    my_version = translate_version(@version)
    other = translate_version(other)
    Gem::Version.new(my_version) <=> Gem::Version.new(other)
  end

  private

  def translate_version(version)
    case version
    when 'latest', :latest
      '999.999.999'
    when 'absent', :absent
      '0.0.0'
    else
      version
    end
  end

  def to_s
    @version
  end
end
