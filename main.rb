require 'byebug'

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
      my_each { |x| return false unless x }
    end
    true
  end

  def my_any?(arg = nil, &prc)
    if block_given?
      my_each { |x| return true if prc.call(x) }
    elsif arg.is_a?(Regexp)
      my_each { |x| return true if arg.match?(x.to_s) == true }
    elsif arg.is_a?(Class)
      my_each { |x| return true if x.is_a?(arg) }
    elsif arg.nil? == false
      my_each { |x| return true if x == arg }
    else
      my_each { |x| return true if x }
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

  def my_inject(arg = nil, arg_2 = nil, &prc)
    array = to_a
    ind = 0
    if block_given? == false
      if arg.is_a?(Symbol)
        while ind < array.size - 1
          array[0] = array[0].send(arg, array[ind + 1])
          ind += 1
        end
      elsif arg.is_a?(Integer)
        while ind < array.size
          if ind.zero?
            array[0] = arg.send(arg_2, array[ind])
          else
            array[0] = array[0].send(arg_2, array[ind])
          end
          ind += 1
        end
      end
    elsif block_given?
      if arg.nil?
        array.my_each_with_index do |_ele, ind|
          array[0] = prc.call(array[0], array[ind + 1]) if ind < array.size - 1
        end
      else
        array.my_each_with_index do |_ele, ind|
          array[0] = prc.call(arg, array[0]) if ind.zero?
          array[0] = prc.call(array[0], array[ind]) if ind.positive?
        end
      end
    end
    array[0]
  end
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def multiply_els(array)
  array.my_inject{ |product, n| product - n }
end

# test cases that were corrected thanks to the preview help from tse

p [1, false, 'hi', []].my_all? == false
p [1, 2, 3].my_any? == true
p [1, 2, nil].my_any? == true
p [false, false, nil].my_any? == false
p [1, 2, 3].my_any?(Integer) == true
p [1, 'demo', false].my_any?(Integer) == true
p ['demo', false, nil].my_any?(Integer) == false
p %w[dog door rod blade].my_any?(/t/)  == false
p %w[dog door rod blade].my_any?(/d/) == true
p [1, 2, 3].my_any?(3) == true
p [1, 2, 2].my_any?(3) == false

array = [1, 2, 3, 4, 5]
operation = proc { |sum, n| sum + n }
p array.my_inject(&operation)
p (1...50).inject (4) { |prod, n| prod * n }
