desc "Publish to forge on enterprismodules"
task :publish do
  file = Rake::FileList["./pkg/*.tar.gz"]
  system "scp #{file} forge@forge.enterprisemodules.com:~/modules"
end
