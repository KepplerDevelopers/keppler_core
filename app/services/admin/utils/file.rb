# frozen_string_literal: true

module Admin
  module Utils
    # Git Handler
    class File
      def size_format(size)
        units = %w[B KB MB GB TB Pb EB]
        return '0.0 B' if size.zero?
        exp = (Math.log(size) / Math.log(1024)).to_i
        exp = 6 if exp > 6
        [(size.to_f / 1024**exp).round(2), units[exp]].join(' ')
      end
    end
  end
end
