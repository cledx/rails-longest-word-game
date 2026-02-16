require "json"
require "open-uri"
require "time"

class GamesController < ApplicationController
    def new
        @letters = new_letters
        @start_time = Time.now
    end

    def score
        @letters = params[:letters].split
        answer = params[:word_attempt]
        end_time = Time.now
        start_time = Time.parse(params[:start_time])
        results = ["#{answer.capitalize} is not in the grid", "#{answer.capitalize} is not a valid English word"]
        if contains_letters?(@letters, answer)
            if english_word?(answer)
                #CORRECT ANSWER  
                @result = calc_score(start_time, end_time, answer)
            else
                #NOT AN ENGLISH WORD
                @result = results[1]
            end
        else
            #NOT IN THE GRID
            @result = results[0]
        end
    end
    
    #start_time, end_time, , time: end_time - start_time, score: (answer.size * 10) - (score[:time].to_i * 2) 
    def calc_score(start_time, end_time, answer)
        time = end_time - start_time
        return { msg: "#{answer.capitalize} is a valid answer!", time: time, score: ((answer.size * 10) - (time * 2))}
    end

    def new_letters
        letters = []
        10.times { letters << rand(97..122).chr.upcase }
        if letters.join.match?(/[aeiou]/i)
            return letters
        else
            return new_letters
        end
    end

    def contains_letters?(letters, answer)
        answer.upcase.chars.each do |letter|
            unless letters.include?(letter) && letters.count(letter) >= answer.upcase.chars.count(letter)
                return false
            end
        end
        return true
    end

    def english_word?(answer)
        word_data = JSON.parse(URI.parse("https://dictionary.lewagon.com/#{answer}").read)
        return word_data["found"]
    end
end
