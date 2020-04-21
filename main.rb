module Enumerable
    def my_each
        for i in 0...self.size
            yield(self[i])
        end
    self
    end

    def my_each_with_index
        for i in 0...self.size
            yield(self[i], i)
        end
        self
    end
    def my_select
        arr = []
        self.my_each{|x| arr << x if yield(x) == true}
        arr
    end
    def my_all?
        self.my_each{|x| return false if yield(x) == false}
        return true
    end
    def my_none?
        self.my_each{|x| return false if yield(x) == true}
        return true
    end
    def my_count(&prc)
        count = 0
        self.my_each{|x| count += 1 if prc.call(x) == true}
        count
    end
    def my_map(&prc)
        arr = Array.new
        self.my_each{|x| arr << prc.call(x)}
        arr
    end
    def my_inject(num_1=nil, &prc)
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


a = [2, 5, 7, 8].my_inject {|acc, x| acc + x}

p a

p multiply_els([2,4,5]) 