module OracleFeature
  def self.oracle_running_check
    `pgrep -f "^(ora|xe)_pmon_.+$"` != ''
  end

  Puppet.features.add(:oracle_running) do
    oracle_running_check
  end

  Puppet.features.send :meta_def, 'oracle_running?' do
    name = :oracle_running
    final = @results[name]
    @results[name] = OracleFeature.oracle_running_check unless final
    @results[name]
  end
end
