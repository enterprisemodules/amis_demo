# rubocop: disable Metrics/ClassLength
# rubocop: disable Metrics/LineLength
# rubocop: disable Metrics/MethodLength

require 'easy_type/helpers'
require 'fileutils'
begin
  require 'puppet/file_serving/content'
  require 'puppet/file_serving/metadata'
  require 'puppet/file_serving/terminus_helper'

  require 'puppet/util/http_proxy'
  require 'puppet/network/http'
  require 'puppet/network/http/api/indirected_routes'
  require 'puppet/network/http/compression'
rescue LoadError
  Puppet.debug 'HTTP download support not found in this version of puppet.'
end
module EasyType
  #
  # This class allows you to use a source anywhere you'd like. The source can be a:
  # - local file
  # - a file:/ type url
  # - a puppet:/ type url
  # - a http(s):// type url
  #
  # If the file is a zip file, a tar file, a tgz or a tar.z, you can also auto extract the file to a certain directory.
  #
  # By default the file will be fetches, uncompressed and unzipped (or untarred). You can control this however by:
  #   auto_uncompress false
  #   auto_unzip false
  #
  #
  class SourceDir < Puppet::Parameter
    include EasyType::Helpers

    def self.inherited(subclass)
      subclass.desc <<-'EOT'
        A source directory, but can also contain a zip or a tar file.

        This parameter can contain the following types of values:

        * `puppet:` URIs, which point to files in modules or Puppet file server
        mount points.
        * Fully qualified paths to locally available files (including files on NFS
        shares or Windows mapped drives).
        * `file:` URIs, which behave the same as local file paths.
        * `http:` URIs, which point to files served by common web servers

        The normal form of a `puppet:` URI is:

        `puppet:///modules/<MODULE NAME>/<FILE PATH>`

        This will fetch a file from a module on the Puppet master (or from a
        local module when using Puppet apply). Given a `modulepath` of
        `/etc/puppetlabs/code/modules`, the example above would resolve to
        `/etc/puppetlabs/code/modules/<MODULE NAME>/files/<FILE PATH>`.

        ## Container file

        When the file is a container file, it will automaticaly be extracted. At this point in
        time the follwoing container types are supported:

        - zip
        - tar

        ## Compressed files

        When the file is compressed, it will be uncompressed before beeing procesed further. This means that for example
        a file `https://www.puppet.com/files/all.tar.gz` will be uncompressed before being unpackes with `tar`

        ## Examples

        Here are some examples:

        ### Regular directories

            ... { '...':
              ...
              source  => '/home/software',
              ...
            }

        The `/home/software` will be used by the custom type. Other Puppet code must make sure the directory contains the right files.

        ### A puppet url containing a zip file

            ... { '...':
              ...
              source  => 'puppet:///modules/software/software.zip',
              tmp_dir => '/tmp/mysoftware'
              ...
            }

        The `software.zip` file will be fetched from the puppet server software module and put in `/tmp/mysoftware`, it will be unzipped and used for the actions
        in the custom type. The file will be temporary put in


        ### A http url containing a tar file

        ... { '...':
          ...
          source  => 'http:///www.enterprisemodules.com/software/software.tar',
          tmp_dir => '/tmp/mysoftware'
          ...
        }


        The `software.tar` file will be fetched from the named web server and put in `/tmp/mysoftware`, it will be untarred and
        used for the actions in the custom type.

        ### A file url fcontaining a compressed tar file

        ... { '...':
          ...
          source  => 'file:///nfsshare/software/software.tar.Z',
          tmp_dir => '/tmp/mysoftware'
          ...
        }

        The `software.tar.Z` file will be fetched from the namedd irectory, it will be uncompressed and then untarred on and put in `/tmp/mysoftware`
        and used for the actions in the custom type.

      EOT
    end

    def initialize(options = {})
      super
      @fetched = false
    end

    validate do |value|
      return if Puppet::Util.absolute_path?(value)

      begin
        uri = URI.parse(URI.escape(value))
      rescue => detail
        raise Puppet::Error, "Could not understand source #{value}: #{detail}", detail
      end

      raise "Cannot use relative URLs '#{value}'" unless uri.absolute?
      raise "Cannot use opaque URLs '#{value}'" unless uri.hierarchical?
      unless %w(file puppet http https).include?(uri.scheme)
        raise "Cannot use URLs of type '#{uri.scheme}' as source for fileserving"
      end
    end

    #
    # Control the automatic unpacking (unzip or untar) of the file
    #
    def self.auto_unpack(value)
      @do_unpack = value
    end

    #
    # Control the automatic uncompresing of the file
    #
    def self.auto_uncompress(value)
      @do_uncompress = value
    end

    #
    #
    # Process the parameter. If the source is not yet fetched, if will first fetch, uncompress and
    # unpack the file.
    #
    # The worflow is:
    #
    # 1) Decide on location of `tmp_dir`. If not specfied it is `/tmp/${title}`
    # 2) If the file is a remote file, copy it to the `tmp_dir`
    # 3) If the file is compressed, uncompress it. In the same `tmp_dir`
    # 4) If the file is a container (zip or tar) unpack it to the `tmp_dir\${file_name}`
    #
    #
    def process
      unless fetched?
        fetch
        uncompress
        unpack
        @value
      end
      @value
    end

    def clean
      FileUtils.rm_rf(tmp_dir)
    end

    private

    # rubocop: disable Style/GuardClause
    def uncompress
      if do_uncompress? && uncompressable_file?(@value)
        if gzfile?(@value) || targzfile?(@value)
          gzip(@value, uncompressed_name)
        else
          raise "#{@value} is an unrecognised compressed file format."
        end
        @value = uncompressed_name
      end
    end
    # rubocop: enable Style/GuardClause

    def unpack
      if do_unpack? && unpackable_file?(@value)
        if zipfile?(@value)
          unzip(@value, extract_dir)
        elsif tarfile?(@value)
          untar(@value, extract_dir)
        else
          raise "#{@value} is an unrecognised packed file format."
        end
        @value = extract_dir
      end
    end

    def do_unpack?
      value = self.class.instance_variable_get(:@do_unpack)
      value.nil? ? true : value
    end

    def do_uncompress?
      value = self.class.instance_variable_get(:@do_uncompress)
      value.nil? ? true : value
    end

    def fetch
      if file_url?(@value)
        @value = URI(@value).path
      elsif puppet_url?(@value)
        puppet_dowload(@value, fetch_destination)
        @value = fetch_destination
      elsif http_url?(@value)
        http_download(@value, fetch_destination)
        @value = fetch_destination
      end
      @fetched = true
    end

    def fetched?
      @fetched
    end

    def tmp_dir
      raise 'Internal error. Type also needs a tmp_dir parameter' unless resource.respond_to?(:tmp_dir)
      dir = resource.tmp_dir
      unless File.exist?(dir)
        Puppet.debug "Creating temporary directory #{dir}"
        FileUtils.mkdir_p(dir)
      end
      dir
    end

    def uncompressed_name
      uri = URI(@value)
      path = uri.path
      name = Pathname.new(path).basename.to_s.split('.')[0..-2].join('.')
      "#{tmp_dir}/#{name}"
    end

    def extract_dir
      uri = URI(@value)
      path = uri.path
      name = Pathname.new(path).basename.to_s.split('.')[0..-2].join('.')
      "#{tmp_dir}/#{name}"
    end

    def fetch_destination
      uri = URI(@value)
      path = uri.path
      name = Pathname.new(path).basename
      "#{tmp_dir}/#{name}"
    end

    def puppet_dowload(url, path)
      Puppet.debug "Fetching file from url #{url} into #{path}."
      content = get_puppet_file(url)
      File.open(path, 'w') do |file|
        file.write content
      end
      FileUtils.chmod(0o755, path)
    end

    def http_download(url, path)
      raise "Parameter #{name} is #{url}. HTTP download support not found in this version of puppet." unless Puppet::Util::HttpProxy.respond_to?(:request_with_redirects)
      Puppet.debug "Fetching file from url #{url} into #{path}."
      connection = Puppet::FileServing::Content.indirection.find(url, :environment => resource.catalog.environment_instance, :links => true)
      raise "Could not find any content at #{url}" unless connection
      File.open(path, 'w') do |file|
        file.write connection.content
      end
      FileUtils.chmod(0o755, path)
    end

    def unzip(file, destination)
      raise "source file #{file} not found." unless File.exist?(file)
      Puppet.info "#{path}: Unzipping source #{file} to #{destination}"
      environment = {}
      environment[:PATH] = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
      Puppet::Util::Execution.execute("unzip -o #{file} -d #{destination}", :failonfail => true, :custom_environment => environment)
      Puppet.info "#{path}: Done Unzipping source #{file} to #{destination}"
    end

    def untar(file, destination)
      raise "source file #{file} not found." unless File.exist?(file)
      Puppet.info "#{path}: Untarring source #{file} to #{destination}"
      environment = {}
      environment[:PATH] = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
      FileUtils.mkdir_p(destination)
      Puppet::Util::Execution.execute("tar xf #{file} -C #{destination}", :failonfail => true, :custom_environment => environment)
      Puppet.info "#{path}: Done Untarring source #{file} to #{destination}"
    end

    def gzip(file, destination)
      raise "source file #{file} not found." unless File.exist?(file)
      Puppet.info "#{path}: Uncompressing source #{file} to #{destination}"
      environment = {}
      environment[:PATH] = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
      Puppet::Util::Execution.execute("gzip -c -d #{file} > #{destination}", :failonfail => true, :custom_environment => environment)
      Puppet.info "#{path}: Done Uncompressing source #{file} to #{destination}"
    end

    def file_url?(url)
      url.scan(%r{^file://.*$}) != []
    end

    def puppet_url?(url)
      url.scan(%r{^puppet://.*$}) != []
    end

    def http_url?(url)
      url.scan(%r{^https?://.*$}) != []
    end

    def uncompressable_file?(file)
      gzfile?(file) || targzfile?(file)
    end

    def unpackable_file?(file)
      zipfile?(file) || tarfile?(file)
    end

    def zipfile?(file)
      file_with_extension?(file, 'zip')
    end

    def tarfile?(file)
      file_with_extension?(file, 'tar')
    end

    def gzfile?(file)
      file_with_extension?(file, 'gz')
    end

    def targzfile?(file)
      ['tar.gz', 'tar.Z'].any? { |ext| file_with_extension?(file, ext) }
    end

    def file_with_extension?(file, extension)
      Pathname(file).extname.casecmp(".#{extension}").zero?
    end
  end
end
