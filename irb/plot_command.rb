module IRB
  module PlotCommand
    class << self; attr_accessor :fork; end
    def self.plot(array)
      array = array.to_a if array.is_a?(Hash)
      array = array.transpose
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          plot.data << Gnuplot::DataSet.new(array) do |ds|
            ds.with = "linespoints"
            ds.notitle
          end
        end
      end
      true
    end

    def self.setup_fork
      Gnuplot.module_eval do
        class << self
          alias_method :open_no_fork, :open
          def open(persist=true, &block)
            begin
              # cleanup the previous zombies
              Process.wait(-1, Process::WNOHANG)
            rescue
            end
            _open = proc { open_no_fork(persist, &block) }
            IRB::PlotCommand.fork ? fork { _open.call } : _open.call
          end
        end
      end
    end

    def self.setup
      return unless IRB.try_require 'gnuplot'
      IRB::PlotCommand.setup_fork
      Pry::CommandSet.new do
        create_command "plot", "gnuplot an array of 2D points" do
          group "Math"

          def options(opt)
            opt.on :f, "no-fork", "Do not fork gnuplot"
          end

          def process
            cmd = eval(args.join(' '))
            cmd = eval(cmd) if cmd.is_a?(String)
            IRB::PlotCommand.fork = !opts.present?(:'no-fork')
            IRB::PlotCommand.plot(cmd)
          end
        end
      end.tap { |cmd| Pry::Commands.import cmd }
    end
  end
end

IRB::PlotCommand.setup
