require 'date'
require 'active_support'
require 'active_support/core_ext'

class Chain
    
    def initialize(start_date, periods)
        @start_date = Date.parse(start_date)
        @periods = periods
        @shift = @start_date.day
    end

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

    def add(new_period_type)
        case new_period_type
        when "annually"
            last_date = @periods[-1].split(/M|D/)[0].to_i
            @periods.push((last_date + 1).to_s)
            p @periods
        when "monthly"
            #case when?
            last_date = @periods[-1].split(/M|D/).map{|n| n.to_i}
            date_to_daily = Date.new(last_date[0], last_date[1], 1).next_month
            @periods.push(date_to_daily.year.to_s + "M" + date_to_daily.month.to_s)
        when "daily"
            last_date = @periods[-1].split(/M|D/).map{|n| n.to_i}
            case last_date.size
            when 1
                date_to_daily = Date.new(last_date[0], 1, 1).next_day
                @periods.push(date_to_daily.year.to_s)
            when 2
                date_to_daily = Date.new(last_date[0], last_date[1], @shift).next_day
                @periods.push(date_to_daily.year.to_s + "M" + date_to_daily.month.to_s)
            when 3
                date_to_daily = Date.new(last_date[0], last_date[1], last_date[2]).next_day
                @periods.push(date_to_daily.year.to_s + "M" + date_to_daily.month.to_s + "D" + date_to_daily.day.to_s)
            end
        end
        @periods
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
