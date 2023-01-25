start = Time.now

input = File.open('inputs/25-sample.txt')
input = File.open('inputs/25.txt')

def snafu2num(snafu)
    num = 0
    snafu.split('').reverse.each_with_index do |digit, index|
        case digit
        when '-'
            digit = -1
        when '='
            digit = -2
        else
            digit = digit.to_i
        end
        num += digit * (5**index)
    end
    num
end

def num2snafu(num)
    base5 = num.to_s(5)
    carry = 0
    snafu = ''
    base5.split('').reverse.each do |digit|
        digit = digit.to_i + carry
        if digit == 3
            digit = '='
            carry = 1
        elsif digit == 4
            digit = '-'
            carry = 1
        elsif digit > 4
            digit = (digit - 5).to_s
            carry = 1
        else
            digit = digit.to_s
            carry = 0
        end
        snafu = digit + snafu
    end
    snafu = carry.to_s + snafu if carry != 0
    snafu
end

total = 0
input.each do |line|
    line.strip!
    total += snafu2num(line)
end

puts total
puts num2snafu(total)

puts "Time taken: #{Time.now - start}"