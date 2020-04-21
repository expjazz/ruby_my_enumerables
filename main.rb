module Enumerable
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def my_each
    i = 0
    if block_given?
      while i < length
        yield(self[i])
        i += 1
      end
      return self
    end
    to_enum
  end

  def my_each_with_index
    i = 0
    if block_given?
      while i <= length - 1
        yield(self[i], i)
        i += 1
      end
      return self
    end
    to_enum
  end

  def my_select
    arr = []
    return to_enum unless block_given?

    my_each { |x| arr << x if yield(x) == true }
    arr
  end

  def my_all?(arg = nil, &prc)
    if block_given?
      my_each { |x| return false if prc.call(x) == false }
    elsif arg.is_a?(Regexp)
      my_each { |x| return false if arg.match?(x.to_s) == false }
    elsif arg.is_a?(Class)
      my_each { |x| return false if x.is_a?(arg) == false }
    elsif arg.nil? == false
      my_each { |x| return false if x != arg }
    else
      my_each { |x| return false if x.nil? == true }
    end
    true
  end

  def my_any?(&prc)
    if block_given?
      my_each { |x| return true if prc.call(x) }
    else
      my_each { |x| return true if x.nil? == false }
    end
    false
  end

  def my_none?(arg = nil, &prc)
    if block_given?
      my_each { |x| return false if prc.call(x) == true }
    elsif arg.is_a?(Regexp)
      my_each { |x| return false if arg.match?(x.to_s) == true }
    elsif arg.is_a?(Class)
      my_each { |x| return false if x.is_a?(arg) == true }
    elsif arg.nil? == false
      my_each { |x| return false if x == arg }
    else
      my_each { |x| return false if x.nil? == false }
    end
    true
  end

  def my_count(arg = nil, &prc)
    count = 0
    if block_given?
      my_each { |x| count += 1 if prc.call(x) == true }
    elsif block_given? == false && arg.nil?
      my_each { |x| count += 1 if x.nil? == false }
    elsif arg.nil? == false
      my_each { |x| count += 1 if x == arg }
    end
    count
  end

  def my_map(&prc)
    return to_enum unless block_given?

    arr = []
    my_each { |x| arr << prc.call(x) }
    arr
  end

  def my_inject(arg = nil, arg_2 = nil)

    ind = 0
    if block_given? == false
      if arg.is_a?(Symbol)
        while ind < length - 1
          self[0] = self[0] + self[ind + 1] if arg[0] == '+'
          self[0] = self[0] - self[ind + 1] if arg[0] == '-'
          self[0] = self[0] * self[ind + 1] if arg[0] == '*'
          self[0] = self[0] / self[ind + 1] if arg[0] == '/'
          ind += 1
        end
      elsif arg.is_a?(Integer)
        while ind < length - 1
          self[0] = self[0] + arg if arg_2[0] == '+' && ind.zero?
          self[0] = self[0] + self[ind + 1] if arg_2[0] == '+'
          self[0] = self[0] - arg if arg_2[0] == '-' && ind.zero?
          self[0] = self[0] - self[ind + 1] if arg_2[0] == '-'
          self[0] = self[0] * arg if arg_2[0] == '*' && ind.zero?
          self[0] = self[0] * self[ind + 1] if arg_2[0] == '*'
          self[0] = self[0] / arg if arg_2[0] == '/' && ind.zero?
          self[0] = self[0] / self[ind + 1] if arg_2[0] == '/'
          ind += 1
        end
      end
    elsif block_given?
      if arg.nil?
        my_each_with_index do |_ele, ind|
          self[0] = yield(self[0], self[ind + 1]) if ind < length - 1
        end
      else
        my_each_with_index do |_ele, ind|
          self[0] = yield(num_1, self[0]) if ind.zero?
          self[0] = yield(self[0], self[ind]) if ind.positive?
        end
      end
    end
    self[0]
  end
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(array)
  array.my_inject{ |product, n| product - n }
end
p multiply_els([3, 2, 1])