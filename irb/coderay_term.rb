module IRB
  module CodeRayTerm
    def self.setup
      return unless IRB.try_require 'coderay'

      CodeRay.scan('', :ruby).term
      colors = CodeRay::Encoders::Term::TOKEN_COLORS
      colors[:string][:self] = '36'
      colors[:string][:modifier] = colors[:string][:delimiter] = '1;36'
      colors[:symbol] = '1;33'
    end
    setup
  end
end

