# frozen_string_literal: true

module R3EXS
  # 一个简单的 Logger
  class Logger
    # Low-level information, mostly for developers.
    DEBUG = 0
    # Generic (useful) information about system operation.
    INFO = 1
    # A warning.
    WARN = 2

    @level = INFO

    class << self
      attr_accessor :level

      def debug(message)
        logger(DEBUG, message) if level <= DEBUG
      end

      def info(message)
        logger(INFO, message) if level <= INFO
      end

      def warn(message)
        logger(WARN, message) if level <= WARN
      end

      def logger(level, message)
        case level
        when DEBUG
          puts("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} [DEBUG]: #{message}")
        when INFO
          puts("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} [INFO]: #{message}")
        when WARN
          ::Kernel.warn("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} [WARN]: #{message}")
        else
          ::Kernel.warn("#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} [UNKNOWN]: #{message}")
        end
      end
    end
  end
end
