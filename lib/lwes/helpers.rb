module Lwes
  module Helpers
    # converts snake cased strings to camelcase
    def camelcase(str)
      str = str.to_s
      str.gsub(/^[a-z]|_+[a-z]/){|str| str.upcase}.gsub("_", '')
    end
  end
end