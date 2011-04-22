module Lwes
  module Helpers
    def camelcase(str)
      str = str.to_s
      str.gsub(/^[a-z]|_+[a-z]/){|str| str.upcase}.gsub("_", '')
    end
  end
end