class Seeds
  def self.load
    [1, 2].each do |pass|
      DataLoader.new(
        :model_path => Rails.root.join("db/seeds/pass_#{pass}"),
        :verbosity  => 1
      ).run
    end
  end
end
