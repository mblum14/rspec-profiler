require 'rspec/core/formatters/progress_formatter'

module Math::Array
  def sum
    self.inject(0){ |accum, i| accum + i }
  end

  def mean
    self.sum/self.length.to_f
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0) { |accum, i| accum + (i - m) ** 2 }
    sum / (self.length).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
end

class Profiler < RSpec::Core::Formatters::ProgressFormatter
  def dump_profile
    groups = {}
    examples.each do |e|
      e.location =~ /\/spec\//
      key = $'.gsub(/\/.*$/,'').strip.to_sym
      if groups.has_key? key
        groups[key] = groups[key] << e
      else
        groups[key] = [e]
      end
    end

    groups.each_key do |group_name|
      print_report(groups[group_name.to_sym], group_name.to_s)
    end
  end

  protected

  def print_report(grouped_examples, group_name)
    grouped_examples = grouped_examples.sort_by do |e|
      e.execution_result[:run_time]
    end.reverse

    times = grouped_examples.map { |e| e.execution_result[:run_time] }
    times.extend Math::Array
    mean = times.mean
    stddev = times.standard_deviation
    k = 2
    grouped_examples.reject! { |e| e.execution_result[:run_time] < (mean + k * stddev) }

    output.puts "\n\nGroup: #{bold magenta(group_name.to_s.capitalize)}"
    output.puts "#{bold red(grouped_examples.size)} of #{bold green(times.size)} spec(s) were 2 or greater standard deviations above the mean"
    output.puts cyan "#{"Mean execution time:"} #{format_time(mean)}"
    output.puts cyan "#{"Standard Deviation:"} #{"%.5f" % stddev}"

    grouped_examples.each_with_index do |example, i|
      location = example.location.match(/\/spec\/.*$/)[0]
      output.puts cyan("#{i+1}.\t#{format_time(example.execution_result[:run_time])}") + white(" \t#{format_caller(location)}")
    end
  end

  def format_time(duration)
    if duration > 60
      minutes = duration.to_i / 60
      seconds = duration - minutes * 60

      red "#{minutes}m #{format_seconds(seconds)}s"
    elsif duration > 10
      red "#{format_seconds(duration)}s"
    elsif duration > 3
      yellow "#{format_seconds(duration)}s"
    else
      "#{format_seconds(duration)}s"
    end
  end

  def format_seconds(float)
    precision ||= (float < 1) ? SUB_SECOND_PRECISION : DEFAULT_PRECISION
    sprintf("%.#{precision}f", float)
  end

  def cyan(text)
    color(text, "\e[36m")
  end
  
end
