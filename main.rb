require 'date'
require 'active_support'
require 'active_support/core_ext'

class Chain
    
    def initialize(start_date, periods)
        @start_date = Date.parse(start_date)
        @periods = periods
        @shift = @start_date.day
    end
public
    def valid?
        ##check if the input is correct, then
        results = []
        @current_date = @start_date
        @periods.each do |period| 
            splited_period =  period.split(/M|D/).map{|n| n.to_i}
            case splited_period.size
            when 3
                results << daily(splited_period)
                @current_date = @current_date.next_day
            when 2
                results << monthly(splited_period)           
                if (Date.valid_date?(@current_date.year, @current_date.next_month.month, @shift))
                    @current_date = Date.new(@current_date.year, @current_date.next_month.month, @shift)
                else
                    @current_date = @current_date.next_month.end_of_month
                end
            when 1
                results << annualy(splited_period)
                @current_date = @current_date.next_year
            end
        end
        return results.all?{|res| res == true}
    end

private
    def start_date_equal?
        date = Date.parse(@start_date)
    end

    def daily(period)
        return @current_date.year == period[0] && @current_date.month == period[1] && @current_date.day == period[2] 
    end

    def monthly(period)
        return @current_date.year == period[0] && @current_date.month == period[1]
    end

    def annualy(period)
        return @current_date.year == period[0]
    end

end


periods_chain = Chain.new("30.01.2023", ["2023M1", "2023M2", "2023M3D30"])
p periods_chain.valid?