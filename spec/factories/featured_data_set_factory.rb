Factory.define :featured_data_set do |fds|
  fds.start_at Time.parse("2010-12-01 13:00:00 Z")
  fds.stop_at Time.parse("2010-12-08 12:59:59 Z")
  fds.note ""
  fds.association :data_set
end
