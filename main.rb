module Enumerable
    def my_each
        if block_given?
            for i in 0...self.size
                yield(self[i])
            end
        return self
        end         
        to_enum
    end

    def my_each_with_index
        if block_given?
            for i in 0...self.size
                yield(self[i], i)
            end
            return self
        end
        to_enum
    end
    def my_select
        return to_enum if block_given? == false
        arr = []
        self.my_each{|x| arr << x if yield(x) == true}
        arr
    end
    def my_all?
        return to_enum unless block_given?
        self.my_each{|x| return false if yield(x) == false}
        return true
    end
    def my_none?
        return to_enum if block_given? == false
        self.my_each{|x| return false if yield(x) == true}
        return true
    end
    def my_count(&prc)
        return to_enum unless block_given?
        count = 0
        self.my_each{|x| count += 1 if prc.call(x) == true}
        count
    end
    def my_map(prc=nil)
        if block_given? && prc == nil
            arr = Array.new
            self.my_each{|x| arr << yield(x)}
            arr
        else

            arr = Array.new
            self.my_each{|x| arr << prc.call(x)}
            arr
        end
    end
    def my_inject(num_1=nil, &prc)
        return to_enum unless block_given?
        if num_1 == nil
            self.my_each_with_index do |ele, ind|
                if ind < self.size - 1
                    self[0] = prc.call(self[0], self[ind + 1]) 
                end
            end
        else  
            self.my_each_with_index do |ele, ind|
                if ind == 0
                    self[0] = prc.call(num_1, self[0])
                elsif ind > 0
                    self[0] = prc.call(self[0], self[ind])
                end
        end
        end
        return self[0]
    end



end
def multiply_els(array)
    array.my_inject {|acc, x| acc * x}
end

test = Proc.new{|x| x + 5}
p [2, 3, 4, 5].my_map {|x| x * 5}